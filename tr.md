
## 1️⃣6️⃣ CRON, SYSTEMD TIMERS VA SCHEDULING
**Global nomi:** Cron, Systemd Timers & Automation  
**O'zbek nomi:** Cron, systemd timers va avtomatlashtirish

### Cron nima?

Cron - vazifalarni vaqt bo'yicha avtomatik bajarishimkonini beradi.

**Hayotiy misol:** Signal soati - har kuni ertalab 7:00 da uyg'otadi. Cron ham shu kabi - "har dushanba 10:00 da backup qil" deyish mumkin.

### Cron sintaksisi

```
* * * * * buyruq
│ │ │ │ │
│ │ │ │ └─── Hafta kuni (0-7, 0 va 7 = Yakshanba)
│ │ │ └───── Oy (1-12)
│ │ └─────── Kun (1-31)
│ └───────── Soat (0-23)
└─────────── Daqiqa (0-59)
```

**Maxsus belgilar:**
- `*` - Har biri
- `,` - Ro'yxat (1,5,10)
- `-` - Diapazon (1-5)
- `/` - Qadam (*/5 = har 5 daqiqada)

### Crontab boshqaruvi

```bash
# Crontab ni tahrirlash
crontab -e

# Hozirgi crontab ni ko'rish
crontab -l

# Crontab ni o'chirish
crontab -r

# Boshqa foydalanuvchi uchun (root kerak)
sudo crontab -u username -e
```

### Cron misollar

```bash
# Har daqiqada
* * * * * /path/to/script.sh

# Har 5 daqiqada
*/5 * * * * /path/to/script.sh

# Har soatda (soatning boshida)
0 * * * * /path/to/script.sh

# Har kuni 03:00 da
0 3 * * * /path/to/backup.sh

# Har dushanba 09:00 da (1 = Dushanba)
0 9 * * 1 /path/to/weekly.sh

# Har oyning birinchi kuni 00:00 da
0 0 1 * * /path/to/monthly.sh

# Ish kunlari (Dushanba-Juma) 08:00 da
0 8 * * 1-5 /path/to/workday.sh

# Dam olish kunlari (Shanba-Yakshanba) 10:00 da
0 10 * * 6,0 /path/to/weekend.sh

# Har 15 daqiqada, 09:00 dan 17:00 gacha, ish kunlari
*/15 9-17 * * 1-5 /path/to/business_hours.sh

# Yanvar, Aprel, Iyul, Oktabrda, har oyning 1-kunida
0 0 1 1,4,7,10 * /path/to/quarterly.sh
```

### Cron environment

Cron minimal environment da ishlaydi:

```bash
# PATH ni belgilash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Shell
SHELL=/bin/bash

# Email (xatolar uchun)
MAILTO=admin@example.com

# Ishchi katalog
HOME=/home/user

# Vazifalar
0 * * * * /path/to/script.sh
```

**Yaxshi amaliyot:**

```bash
# crontab
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=admin@example.com

# Backup (har kuni 02:00)
0 2 * * * /home/user/scripts/backup.sh >> /var/log/backup.log 2>&1

# Tozalash (har dushanba 01:00)
0 1 * * 1 find /tmp -type f -mtime +7 -delete

# Monitoring (har 5 daqiqada)
*/5 * * * * /usr/local/bin/check_server.sh
```

### Cron dan skriptni to'g'ri chaqirish

```bash
#!/bin/bash

# Cron uchun skript
# /home/user/scripts/cron_backup.sh

# To'liq yo'llar ishlatish!
BACKUP_DIR="/home/user/backups"
SOURCE_DIR="/home/user/important"
LOG_FILE="/var/log/backup.log"

# PATH ni sozlash
export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"

# Log ga yozish
{
    echo "=== $(date) ==="
    
    # Backup
    if tar -czf "$BACKUP_DIR/backup_$(date +%Y%m%d).tar.gz" "$SOURCE_DIR"; then
        echo "✓ Backup muvaffaqiyatli"
    else
        echo "✗ Backup xato!" >&2
        exit 1
    fi
    
} >> "$LOG_FILE" 2>&1
```

### Cron amaliy misollar

#### 1. Avtomatik backup tizimi

```bash
#!/bin/bash
# /usr/local/bin/daily_backup.sh

set -euo pipefail

readonly BACKUP_ROOT="/backups"
readonly RETENTION_DAYS=30
readonly LOG="/var/log/backup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

# Backup papkalari
declare -a DIRS=(
    "/home"
    "/etc"
    "/var/www"
)

# Yangi backup
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

log "Backup boshlandi"

for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        dir_name=$(basename "$dir")
        log "Backup: $dir"
        
        if tar -czf "$BACKUP_DIR/${dir_name}.tar.gz" "$dir" 2>>"$LOG"; then
            log "✓ $dir"
        else
            log "✗ $dir - XATO"
        fi
    fi
done

# Eski backuplarni o'chirish
log "Eski backuplarni tozalash ($RETENTION_DAYS kun)"
find "$BACKUP_ROOT" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} + 2>>"$LOG"

log "Backup tugadi"

# crontab:
# 0 2 * * * /usr/local/bin/daily_backup.sh
```

#### 2. Server monitoring

```bash
#!/bin/bash
# /usr/local/bin/monitor.sh

set -euo pipefail

readonly LOG="/var/log/monitor.log"
readonly EMAIL="admin@example.com"
readonly ALERT_FILE="/tmp/alert_sent"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

send_alert() {
    local subject=$1
    local message=$2
    
    # Oxirgi alert dan 1 soat o'tganmi?
    if [ -f "$ALERT_FILE" ]; then
        local last_alert=$(stat -c %Y "$ALERT_FILE")
        local now=$(date +%s)
        local diff=$((now - last_alert))
        
        if [ $diff -lt 3600 ]; then
            log "Alert spam: o'tkazib yuborildi"
            return
        fi
    fi
    
    echo "$message" | mail -s "$subject" "$EMAIL"
    touch "$ALERT_FILE"
    log "Alert yuborildi: $subject"
}

# CPU tekshirish
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
cpu_int=${cpu%.*}

if [ $cpu_int -gt 80 ]; then
    send_alert "CPU yuqori" "CPU ishlatilishi: ${cpu}%"
fi

# RAM tekshirish
ram=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')

if [ $ram -gt 85 ]; then
    send_alert "RAM yuqori" "RAM ishlatilishi: ${ram}%"
fi

# Disk tekshirish
while read line; do
    usage=$(echo "$line" | awk '{print $5}' | cut -d'%' -f1)
    mount=$(echo "$line" | awk '{print $6}')
    
    if [ $usage -gt 90 ]; then
        send_alert "Disk to'lgan" "$mount: ${usage}% to'lgan"
    fi
done < <(df -h | grep '^/dev/')

log "Monitor check OK"

# crontab:
# */5 * * * * /usr/local/bin/monitor.sh
```

#### 3. Log rotation

```bash
#!/bin/bash
# /usr/local/bin/rotate_logs.sh

set -euo pipefail

readonly LOG_DIR="/var/log/myapp"
readonly RETENTION_DAYS=30
readonly COMPRESS=1

rotate_log() {
    local logfile=$1
    
    if [ ! -f "$logfile" ]; then
        return
    fi
    
    # Hajmni tekshirish (10MB dan katta)
    local size=$(stat -c%s "$logfile")
    if [ $size -lt 10485760 ]; then
        return
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local rotated="${logfile}.${timestamp}"
    
    # Rotate
    mv "$logfile" "$rotated"
    touch "$logfile"
    
    # Compress
    if [ $COMPRESS -eq 1 ]; then
        gzip "$rotated"
        echo "✓ Rotated va compressed: $rotated.gz"
    else
        echo "✓ Rotated: $rotated"
    fi
}

# Barcha .log fayllarni rotate qilish
find "$LOG_DIR" -name "*.log" -type f | while read logfile; do
    rotate_log "$logfile"
done

# Eski loglarni o'chirish
find "$LOG_DIR" -name "*.log.*" -mtime +$RETENTION_DAYS -delete

echo "Log rotation tugadi"

# crontab:
# 0 0 * * * /usr/local/bin/rotate_logs.sh
```

### Systemd Timers

Zamonaviy alternativa - systemd timers. Crondan afzalliklari:
- Yaxshiroq logging (journalctl)
- Dependency management
- Aniqroq vaqt kontroli
- Skriptni o'tkazib yuborilgan bo'lsa, keyinroq bajarish

#### Timer yaratish

**1. Service fayli yarating:**

```ini
# /etc/systemd/system/backup.service

[Unit]
Description=Daily Backup Service
Wants=backup.timer

[Service]
Type=oneshot
User=root
ExecStart=/usr/local/bin/backup.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

**2. Timer fayli yarating:**

```ini
# /etc/systemd/system/backup.timer

[Unit]
Description=Daily Backup Timer
Requires=backup.service

[Timer]
# Har kuni 02:00 da
OnCalendar=daily
OnCalendar=*-*-* 02:00:00

# Agar o'tkazib yuborilgan bo'lsa, restart dan keyin bajarish
Persistent=true

[Install]
WantedBy=timers.target
```

**3. Yoqish va boshqarish:**

```bash
# Timer ni reload qilish
sudo systemctl daemon-reload

# Timer ni yoqish
sudo systemctl enable backup.timer

# Timer ni ishga tushirish
sudo systemctl start backup.timer

# Status ko'rish
sudo systemctl status backup.timer

# Keyingi bajarilish vaqti
sudo systemctl list-timers backup.timer

# Loglarni ko'rish
sudo journalctl -u backup.service

# To'xtatish
sudo systemctl stop backup.timer
sudo systemctl disable backup.timer
```

### OnCalendar sintaksisi

```ini
# Har daqiqada
OnCalendar=*:*

# Har 5 daqiqada
OnCalendar=*:0/5

# Har kuni 03:00 da
OnCalendar=daily
# yoki
OnCalendar=*-*-* 03:00:00

# Har dushanba 09:00 da
OnCalendar=Mon 09:00

# Har oyning 1-kuni
OnCalendar=*-*-01 00:00:00

# Ish kunlari 08:00 da
OnCalendar=Mon..Fri 08:00

# Har soatning 0 va 30 daqiqasida
OnCalendar=*:00,30

# Murakkab
OnCalendar=Mon,Wed,Fri 10:00
```

**Vaqtni test qilish:**

```bash
# OnCalendar ni test qilish
systemd-analyze calendar "Mon 09:00"
systemd-analyze calendar "Mon..Fri 08:00"
systemd-analyze calendar "*-*-01 00:00:00"
```

### Timer amaliy misollar

#### 1. System cleanup timer

```ini
# /etc/systemd/system/cleanup.service
[Unit]
Description=System Cleanup Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/cleanup.sh
User=root
StandardOutput=journal
```

```ini
# /etc/systemd/system/cleanup.timer
[Unit]
Description=Daily System Cleanup Timer

[Timer]
OnCalendar=daily
OnCalendar=*-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

```bash
#!/bin/bash
# /usr/local/bin/cleanup.sh

set -euo pipefail

echo "=== System Cleanup ==="

# Temp files
echo "Cleaning /tmp..."
find /tmp -type f -atime +7 -delete
find /tmp -type d -empty -delete

# Old logs
echo "Cleaning old logs..."
find /var/log -name "*.log.*" -mtime +30 -delete

# Package cache
echo "Cleaning package cache..."
apt-get clean

# Journal logs (faqat 7 kunlik qoldirish)
echo "Cleaning journal logs..."
journalctl --vacuum-time=7d

echo "✓ Cleanup tugadi"
```

#### 2. Database backup timer

```ini
# /etc/systemd/system/db-backup.service
[Unit]
Description=Database Backup Service
After=mysql.service
Requires=mysql.service

[Service]
Type=oneshot
User=backup
Group=backup
ExecStart=/usr/local/bin/db_backup.sh
StandardOutput=journal
StandardError=journal
```

```ini
# /etc/systemd/system/db-backup.timer
[Unit]
Description=Database Backup Timer (every 6 hours)

[Timer]
OnCalendar=*-*-* 00,06,12,18:00:00
Persistent=true
AccuracySec=1m

[Install]
WantedBy=timers.target
```

```bash
#!/bin/bash
# /usr/local/bin/db_backup.sh

set -euo pipefail

readonly BACKUP_DIR="/backups/database"
readonly RETENTION_DAYS=7
readonly DB_USER="backup_user"
readonly DB_PASS="secret_password"

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup barcha databases
echo "=== Database Backup ==="

mysql -u"$DB_USER" -p"$DB_PASS" -e "SHOW DATABASES;" | \
    grep -v "Database\|information_schema\|performance_schema\|mysql" | \
    while read db; do
        echo "Backing up: $db"
        
        mysqldump -u"$DB_USER" -p"$DB_PASS" \
            --single-transaction \
            --routines \
            --triggers \
            "$db" | gzip > "$BACKUP_DIR/${db}_${TIMESTAMP}.sql.gz"
        
        echo "✓ $db"
    done

# Eski backuplarni o'chirish
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "✓ Backup tugadi"
```

### at - Bir martalik vazifalar

`at` - faqat bir marta bajarilishi kerak bo'lgan vazifalar uchun.

```bash
# 10 daqiqadan keyin
echo "backup.sh" | at now + 10 minutes

# Bugun 15:00 da
echo "cleanup.sh" | at 15:00

# Ertaga 09:00 da
echo "report.sh" | at 09:00 tomorrow

# Ma'lum sanada
echo "task.sh" | at 10:00 2025-12-31

# File dan
at 22:00 < commands.txt

# Interaktiv
at 16:00
> /usr/local/bin/backup.sh
> ^D  (Ctrl+D)

# Vazifalarni ko'rish
atq

# Vazifani o'chirish
atrm JOB_NUMBER
```

### anacron - Doimiy ishlamaydigan kompyuterlar uchun

```bash
# /etc/anacrontab

SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# period  delay  job-id  command
1         5      daily   run-parts /etc/cron.daily
7         10     weekly  run-parts /etc/cron.weekly
@monthly  15     monthly run-parts /etc/cron.monthly

# Format:
# period - kunlarda
# delay - daqiqalarda (boshqa vazifalardan keyin)
# job-id - noyob nom
# command - bajarilishi kerak bo'lgan buyruq
```

### Amaliy loyiha: Keng qamrovli monitoring tizimi

```bash
#!/bin/bash
# /usr/local/bin/comprehensive_monitor.sh

set -euo pipefail

#############################################
# COMPREHENSIVE SYSTEM MONITORING
#############################################

readonly CONFIG_FILE="/etc/monitor.conf"
readonly LOG_FILE="/var/log/monitor.log"
readonly ALERT_LOG="/var/log/monitor_alerts.log"
readonly STATE_DIR="/var/lib/monitor"

mkdir -p "$STATE_DIR"

# Default config
CPU_THRESHOLD=80
RAM_THRESHOLD=85
DISK_THRESHOLD=90
LOAD_THRESHOLD=4.0
ALERT_EMAIL="admin@example.com"
ALERT_COOLDOWN=3600  # 1 soat

# Config yuklash
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

alert() {
    local subject=$1
    local message=$2
    local alert_file="$STATE_DIR/alert_${subject// /_}"
    
    # Cooldown tekshirish
    if [ -f "$alert_file" ]; then
        local last_alert=$(stat -c %Y "$alert_file")
        local now=$(date +%s)
        local diff=$((now - last_alert))
        
        if [ $diff -lt $ALERT_COOLDOWN ]; then
            log "Alert cooldown: $subject"
            return
        fi
    fi
    
    # Alert yuborish
    echo "$message" | mail -s "[ALERT] $subject" "$ALERT_EMAIL"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $subject: $message" >> "$ALERT_LOG"
    touch "$alert_file"
    
    log "ALERT: $subject"
}

# CPU monitoring
check_cpu() {
    local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local cpu_int=${cpu%.*}
    
    log "CPU: ${cpu}%"
    
    if [ $cpu_int -gt $CPU_THRESHOLD ]; then
        local top_processes=$(ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "%s %s%%\n", $11, $3}')
        alert "CPU yuqori" "CPU ishlatilishi: ${cpu}%\n\nEng ko'p ishlatuvchilar:\n$top_processes"
        return 1
    fi
    
    return 0
}

# RAM monitoring
check_ram() {
    local ram=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
    local ram_used=$(free -h | grep Mem | awk '{print $3}')
    local ram_total=$(free -h | grep Mem | awk '{print $2}')
    
    log "RAM: ${ram}% ($ram_used / $ram_total)"
    
    if [ $ram -gt $RAM_THRESHOLD ]; then
        local top_processes=$(ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "%s %s%%\n", $11, $4}')
        alert "RAM yuqori" "RAM ishlatilishi: ${ram}% ($ram_used / $ram_total)\n\nEng ko'p ishlatuvchilar:\n$top_processes"
        return 1
    fi
    
    return 0
}

# Disk monitoring
check_disk() {
    local has_alert=0
    
    while read line; do
        local usage=$(echo "$line" | awk '{print $5}' | cut -d'%' -f1)
        local mount=$(echo "$line" | awk '{print $6}')
        local used=$(echo "$line" | awk '{print $3}')
        local total=$(echo "$line" | awk '{print $2}')
        
        log "DISK $mount: ${usage}% ($used / $total)"
        
        if [ $usage -gt $DISK_THRESHOLD ]; then
            local big_dirs=$(du -h "$mount" 2>/dev/null | sort -hr | head -5)
            alert "Disk to'lgan: $mount" "$mount: ${usage}% to'lgan ($used / $total)\n\nEng katta kataloglar:\n$big_dirs"
            has_alert=1
        fi
    done < <(df -h | grep '^/dev/')
    
    return $has_alert
}

# Load average monitoring
check_load() {
    local load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
    local cpu_count=$(nproc)
    
    log "Load: $load (CPU: $cpu_count)"
    
    # Bash da float matematik yo'q, bc ishlatamiz
    local threshold_exceeded=$(echo "$load > $LOAD_THRESHOLD" | bc -l)
    
    if [ $threshold_exceeded -eq 1 ]; then
        local top_processes=$(ps aux --sort=-%cpu | head -11 | tail -10 | awk '{printf "%s %s%%\n", $11, $3}')
        alert "Load yuqori" "Load average: $load (threshold: $LOAD_THRESHOLD)\nCPU count: $cpu_count\n\nTop processes:\n$top_processes"
        return 1
    fi
    
    return 0
}

# Service monitoring
check_services() {
    local services=("nginx" "mysql" "redis" "php-fpm")
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            log "Service OK: $service"
        else
            alert "Service down" "$service to'xtab qoldi!"
            log "Service DOWN: $service"
        fi
    done
}

# Network monitoring
check_network() {
    local interfaces=$(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$')
    
    for iface in $interfaces; do
        if ip link show "$iface" | grep -q "state UP"; then
            log "Network OK: $iface"
        else
            alert "Network down" "Interface $iface o'chiq!"
            log "Network DOWN: $iface"
        fi
    done
}

# Certificate expiry check
check_certificates() {
    local cert_dir="/etc/ssl/certs"
    local warn_days=30
    
    if [ ! -d "$cert_dir" ]; then
        return
    fi
    
    find "$cert_dir" -name "*.crt" -o -name "*.pem" | while read cert; do
        if openssl x509 -in "$cert" -noout -checkend $((warn_days * 86400)) 2>/dev/null; then
            : # OK
        else
            local expiry=$(openssl x509 -in "$cert" -noout -enddate 2>/dev/null | cut -d= -f2)
            alert "Certificate expiring" "$cert will expire on $expiry"
            log "Certificate expiring: $cert"
        fi
    done
}

# Asosiy monitoring
main() {
    log "=== Monitoring check boshlandi ==="
    
    local errors=0
    
    check_cpu || ((errors++))
    check_ram || ((errors++))
    check_disk || ((errors++))
    check_load || ((errors++))
    check_services
    check_network
    check_certificates
    
    if [ $errors -eq 0 ]; then
        log "✓ Barcha tekshiruvlar OK"
    else
        log "⚠ $errors ta muammo topildi"
    fi
    
    log "=== Monitoring check tugadi ==="
}

main "$@"
```

**Config fayli:**

```bash
# /etc/monitor.conf

CPU_THRESHOLD=85
RAM_THRESHOLD=90
DISK_THRESHOLD=85
LOAD_THRESHOLD=5.0
ALERT_EMAIL="admin@example.com"
ALERT_COOLDOWN=1800  # 30 daqiqa
```

**Systemd timer:**

```ini
# /etc/systemd/system/monitor.service
[Unit]
Description=System Monitoring Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/comprehensive_monitor.sh
StandardOutput=journal
StandardError=journal

# /etc/systemd/system/monitor.timer
[Unit]
Description=System Monitoring Timer (every 5 minutes)

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
```

### 📝 Vazifalar:

1. **Vazifa 1:** Cron bilan har kuni 02:00 da backup qiladigan skript yozing (loglar bilan)
2. **Vazifa 2:** Systemd timer yarating: har 10 daqiqada disk hajmini tekshirsin
3. **Vazifa 3:** at buyrug'i bilan vaqtinchalik task scheduler yarating
4. **Vazifa 4:** Log rotation tizimi: 10MB dan katta loglarni avtomatik gzip qilsin
5. **Vazifa 5:** Monitoring skript: CPU, RAM, Disk tekshirib, muammo bo'lsa email yuborsin

---

## 1️⃣7️⃣ TARMOQ BUYRUQLARI
**Global nomi:** Network Commands  
**O'zbek nomi:** Tarmoq buyruqlari

### ping - Server mavjudligini tekshirish

```bash
# Oddiy ping
ping google.com

# 5 ta paket
ping -c 5 google.com

# Interval (soniya)
ping -i 2 google.com

# Timeout
ping -W 2 google.com

# IPv4 majburiy
ping -4 google.com

# IPv6
ping -6 google.com

# Katta paket (MTU test)
ping -s 1500 google.com
```

**Amaliy misol:**

```bash
#!/bin/bash

check_host() {
    local host=$1
    
    if ping -c 3 -W 2 "$host" &>/dev/null; then
        echo "✓ $host - Online"
        return 0
    else
        echo "✗ $host - Offline"
        return 1
    fi
}

# Serverlar ro'yxati
hosts=("google.com" "github.com" "192.168.1.1")

for host in "${hosts[@]}"; do
    check_host "$host"
done
```

### curl - HTTP so'rovlar

```bash
# Oddiy GET
curl https://api.example.com

# Response headersni ko'rish
curl -I https://example.com

# POST so'rov
curl -X POST https://api.example.com/users \
    -H "Content-Type: application/json" \
    -d '{"name":"Sardor","age":25}'

# Faylga saqlash
curl -o file.html https://example.com
curl -O https://example.com/file.pdf  # Asl nom bilan

# Download progress
curl -# -O https://example.com/large.zip

# Authentication
curl -u username:password https://api.example.com

# Headers
curl -H "Authorization: Bearer TOKEN" https://api.example.com

# Follow redirects
curl -L https://short.url

# Timeout
curl --connect-timeout 5 --max-time 10 https://example.com

# Verbose (debug)
curl -v https://example.com

# Silent
curl -s https://api.example.com

# JSON response formatting
curl -s https://api.example.com | jq '.'
```

**API testing:**

```bash
#!/bin/bash

API_URL="https://api.example.com"
API_KEY="your_key_here"

# GET request
get_users() {
    curl -s -H "Authorization: Bearer $API_KEY" \
        "$API_URL/users" | jq '.'
}

# POST request
create_user() {
    local name=$1
    local email=$2
    
    curl -s -X POST \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"name\":\"$name\",\"email\":\"$email\"}" \
        "$API_URL/users" | jq '.'
}

# Test
get_users
create_user "Sardor" "sardor@example.com"
```

### wget - Fayllarni yuklab olish

```bash
# Oddiy download
wget https://example.com/file.zip

# Boshqa nom bilan
wget -O myfile.zip https://example.com/file.zip

# Davom ettirish (resume)
wget -c https://example.com/large.iso

# Background
wget -b https://example.com/file.zip

# Rekursiv (butun saytni)
wget -r -np -k https://example.com

# Limit speed
wget --limit-rate=200k https://example.com/file.zip

# User agent
wget --user-agent="Mozilla/5.0" https://example.com

# Multiple files
wget -i urls.txt

# Mirror (sayt nusxasi)
wget --mirror --convert-links --page-requisites https://example.com
```

### ssh - Masofaviy ulanish

```bash
# Oddiy ulanish
ssh user@192.168.1.100

# Port bilan
ssh -p 2222 user@example.com

# Buyruqni bajarish
ssh user@server 'ls -la /var/www'

# File yaratish
ssh user@server 'cat > /tmp/file.txt' < local_file.txt

# Tunnel (port forwarding)
ssh -L 8080:localhost:80 user@server  # Local → Remote
ssh -R 8080:localhost:80 user@server  # Remote → Local

# Dynamic tunnel (SOCKS proxy)
ssh -D 1080 user@server

# Key bilan
ssh -i ~/.ssh/id_rsa user@server

# X forwarding (GUI)
ssh -X user@server

# Keep alive
ssh -o ServerAliveInterval=60 user@server

# Verbose (debug)
ssh -vvv user@server
```

**SSH key yaratish:**

```bash
# Key generatsiya
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Server ga ko'chirish
ssh-copy-id user@server

# Yoki qo'lda
cat ~/.ssh/id_rsa.pub | ssh user@server 'cat >> ~/.ssh/authorized_keys'
```

**SSH config:**

```bash
# ~/.ssh/config

Host myserver
    HostName 192.168.1.100
    User sardor
    Port 22
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60

Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3

# Ishlatish
ssh myserver
```

### scp - Secure copy

```bash
# Local → Remote
scp file.txt user@server:/path/to/destination/

# Remote → Local
scp user@server:/path/to/file.txt ./

# Katalogni ko'chirish
scp -r myfolder/ user@server:/path/

# Port bilan
scp -P 2222 file.txt user@server:/path/

# Ko'p fayllar
scp file1.txt file2.txt user@server:/path/

# Wildcard
scp *.txt user@server:/path/

# Bandwidth limit
scp -l 1000 large.zip user@server:/path/  # 1000 Kbit/s

# Preserve attributes
scp -p file.txt user@server:/path/

# Verbose
scp -v file.txt user@server:/path/
```

### rsync - Sinxronizatsiya

```bash
# Oddiy copy
rsync source/ destination/

# Remote ga
rsync -avz folder/ user@server:/path/

# Dry run (test)
rsync -avzn source/ dest/

# Progress
rsync -avz --progress source/ dest/

# Delete (destinationda ortiqcha fayllarni o'chirish)
rsync -avz --delete source/ dest/

# Exclude
rsync -avz --exclude '*.log' --exclude 'temp/' source/ dest/

# Include faqat
rsync -avz --include '*.txt' --exclude '*' source/ dest/

# Bandwidth limit
rsync -avz --bwlimit=1000 source/ dest/  # KB/s

# Resume
rsync -avzP source/ dest/

# SSH port
rsync -avz -e "ssh -p 2222" source/ user@server:/path/
```

**Parametrlar:**
- `-a` - Archive (rekursiv, permissions, timestamps)
- `-v` - Verbose
- `-z` - Compress
- `-P` - Progress va partial
- `-n` - Dry run
- `--delete` - O'chirish

**Backup skripti:**

```bash
#!/bin/bash

SOURCE="/var/www"
DEST="user@backup-server:/backups/www/"
LOG="/var/log/rsync_backup.log"

{
    echo "=== $(date) ==="
    
    rsync -avz --delete \
        --exclude='*.log' \
        --exclude='temp/' \
        "$SOURCE/" "$DEST" 
    
    if [ $? -eq 0 ]; then
        echo "✓ Backup muvaffaqiyatli"
    else
        echo "✗ Backup xato"
    fi
    
} | tee -a "$LOG"
```

### netstat / ss - Tarmoq holati

```bash
# Barcha ulanishlar
netstat -a
ss -a

# Tinglovchi portlar
netstat -tuln
ss -tuln

# Established ulanishlar
netstat -tn
ss -tn

# Processlar bilan
netstat -tulnp
ss -tulnp

# Statistika
netstat -s
ss -s

# Routing table
netstat -r
```

### ip - Tarmoq konfiguratsiyasi

```bash
# IP manzillarni ko'rish
ip addr show
ip a

# Ma'lum interface
ip addr show eth0

# IP qo'shish
sudo ip addr add 192.168.1.100/24 dev eth0

# IP o'chirish
sudo ip addr del 192.168.1.100/24 dev eth0

# Interface yoqish/o'chirish
sudo ip link set eth0 up
sudo ip link set eth0 down

# Routing table
ip route show

# Default gateway qo'shish
sudo ip route add default via 192.168.1.1

# Static route
sudo ip route add 10.0.0.0/24 via 192.168.1.254
```

### nmap - Port scanning

```bash
# Oddiy scan
nmap 192.168.1.100

# Host topish
nmap -sn 192.168.1.0/24

# Port range
nmap -p 1-1000 192.168.1.100

# Ma'lum portlar
nmap -p 80,443,8080 192.168.1.100

# Service version
nmap -sV 192.168.1.100

# OS detection
sudo nmap -O 192.168.1.100

# Aggressive scan
sudo nmap -A 192.168.1.100

# Top 100 ports
nmap --top-ports 100 192.168.1.100

# TCP SYN scan (stealth)
sudo nmap -sS 192.168.1.100

# UDP scan
sudo nmap -sU 192.168.1.100
```

### nc (netcat) - Network swiss army knife

```bash
# Port tekshirish
nc -zv example.com 80

# Port range
nc -zv example.com 20-100

# Chat server
nc -l 1234                    # Server
nc localhost 1234             # Client

# File transfer
nc -l 1234 > received.txt     # Server
nc localhost 1234 < sent.txt  # Client

# Port forwarding
nc -l 8080 | nc example.com 80

# Banner grabbing
echo "" | nc example.com 80

# UDP
nc -u example.com 53
```

### dig - DNS query

```bash
# Oddiy query
dig example.com

# Qisqa natija
dig +short example.com

# Ma'lum DNS server
dig @8.8.8.8 example.com

# Record turlari
dig example.com MX      # Mail servers
dig example.com NS      # Name servers
dig example.com TXT     # Text records
dig example.com AAAA    # IPv6

# Reverse lookup
dig -x 8.8.8.8

# Trace
dig +trace example.com
```

### Amaliy loyiha: Network monitor

```bash
#!/bin/bash

#############################################
# NETWORK MONITORING DASHBOARD
#############################################

set -euo pipefail

readonly LOG_FILE="/var/log/netmonitor.log"
readonly ALERT_EMAIL="admin@example.com"

# Ranglar
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Host availability
check_hosts() {
    local -a hosts=(
        "8.8.8.8:Google DNS"
        "1.1.1.1:Cloudflare DNS"
        "google.com:Google"
        "github.com:GitHub"
    )
    
    echo -e "\n${YELLOW}=== HOST AVAILABILITY ===${NC}"
    
    for entry in "${hosts[@]}"; do
        IFS=':' read -r host name <<< "$entry"
        
        if ping -c 2 -W 2 "$host" &>/dev/null; then
            echo -e "${GREEN}✓${NC} $name ($host)"
        else
            echo -e "${RED}✗${NC} $name ($host) - OFFLINE"
            log "ALERT: $name offline"
        fi
    done
}

# Port check
check_ports() {
    local -a services=(
        "localhost:80:HTTP"
        "localhost:443:HTTPS"
        "localhost:22:SSH"
        "localhost:3306:MySQL"
    )
    
    echo -e "\n${YELLOW}=== PORT STATUS ===${NC}"
    
    for entry in "${services[@]}"; do
        IFS=':' read -r host port name <<< "$entry"
        
        if nc -z -w2 "$host" "$port" &>/dev/null; then
            echo -e "${GREEN}✓${NC} $name (port $port) - OPEN"
        else
            echo -e "${RED}✗${NC} $name (port $port) - CLOSED"
            log "WARNING: $name port $port closed"
        fi
    done
}

# Network interfaces
check_interfaces() {
    echo -e "\n${YELLOW}=== NETWORK INTERFACES ===${NC}"
    
    ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$' | while read iface; do
        if ip link show "$iface" | grep -q "state UP"; then
            local ip=$(ip -4 addr show "$iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
            echo -e "${GREEN}✓${NC} $iface - UP ($ip)"
        else
            echo -e "${RED}✗${NC} $iface - DOWN"
            log "ALERT: Interface $iface down"
        fi
    done
}

# Bandwidth usage
check_bandwidth() {
    echo -e "\n${YELLOW}=== BANDWIDTH USAGE ===${NC}"
    
    local iface=$(ip route | grep default | awk '{print $5}')
    
    if [ -z "$iface" ]; then
        echo "No default interface"
        return
    fi
    
    # RX/TX statistics
    local rx_bytes=$(cat "/sys/class/net/$iface/statistics/rx_bytes")
    local tx_bytes=$(cat "/sys/class/net/$iface/statistics/tx_bytes")
    
    local rx_mb=$(echo "scale=2; $rx_bytes/1024/1024" | bc)
    local tx_mb=$(echo "scale=2; $tx_bytes/1024/1024" | bc)
    
    echo "Interface: $iface"
    echo "  RX: ${rx_mb} MB"
    echo "  TX: ${tx_mb} MB"
}

# Active connections
check_connections() {
    echo -e "\n${YELLOW}=== ACTIVE CONNECTIONS ===${NC}"
    
    local established=$(ss -tn | grep ESTAB | wc -l)
    local listening=$(ss -tuln | wc -l)
    
    echo "Established: $established"
    echo "Listening: $listening"
    
    echo -e "\n${YELLOW}Top 5 connections:${NC}"
    ss -tn | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -5
}

# DNS check
check_dns() {
    echo -e "\n${YELLOW}=== DNS RESOLUTION ===${NC}"
    
    local test_domains=("google.com" "github.com" "cloudflare.com")
    
    for domain in "${test_domains[@]}"; do
        if dig +short "$domain" &>/dev/null; then
            local ip=$(dig +short "$domain" | head -1)
            echo -e "${GREEN}✓${NC} $domain → $ip"
        else
            echo -e "${RED}✗${NC} $domain - FAILED"
            log "ALERT: DNS resolution failed for $domain"
        fi
    done
}

# Internet speed test (simplified)
check_speed() {
    echo -e "\n${YELLOW}=== INTERNET SPEED ===${NC}"
    
    # Download test
    echo -n "Testing download speed... "
    local start=$(date +%s)
    curl -s -o /dev/null -w "%{speed_download}" https://speed.cloudflare.com/__down?bytes=10000000
    local speed=$(curl -s -o /dev/null -w "%{speed_download}" https://speed.cloudflare.com/__down?bytes=10000000)
    local speed_mbps=$(echo "scale=2; $speed/1024/1024*8" | bc)
    echo "${speed_mbps} Mbps"
}

# Firewall status
check_firewall() {
    echo -e "\n${YELLOW}=== FIREWALL STATUS ===${NC}"
    
    if command -v ufw &>/dev/null; then
        local status=$(sudo ufw status | head -1)
        echo "UFW: $status"
    elif command -v firewall-cmd &>/dev/null; then
        local status=$(sudo firewall-cmd --state 2>/dev/null || echo "inactive")
        echo "Firewalld: $status"
    else
        echo "No firewall detected"
    fi
}

# Network statistics
show_statistics() {
    echo -e "\n${YELLOW}=== NETWORK STATISTICS ===${NC}"
    
    netstat -s 2>/dev/null | head -20 || ss -s
}

# Main dashboard
main() {
    clear
    echo "╔════════════════════════════════════════╗"
    echo "║   NETWORK MONITORING DASHBOARD         ║"
    echo "║   $(date '+%Y-%m-%d %H:%M:%S')                  ║"
    echo "╚════════════════════════════════════════╝"
    
    check_hosts
    check_interfaces
    check_ports
    check_connections
    check_bandwidth
    check_dns
    check_firewall
    show_statistics
    
    echo -e "\n${GREEN}✓ Monitoring complete${NC}"
}

# Continuous monitoring mode
monitor_mode() {
    while true; do
        main
        echo -e "\n${YELLOW}Updating in 30 seconds... (Ctrl+C to stop)${NC}"
        sleep 30
    done
}

# CLI
case ${1:-once} in
    once)
        main
        ;;
    monitor)
        monitor_mode
        ;;
    *)
        echo "Usage: $0 [once|monitor]"
        exit 1
        ;;
esac
```

### 📝 Vazifalar:

1. **Vazifa 1:** ping va curl bilan serverlarni tekshiruvchi skript (online/offline status)
2. **Vazifa 2:** rsync bilan avtomatik backup tizimi (SSH orqali remote serverga)
3. **Vazifa 3:** Port scanner: berilgan IP dagi ochiq portlarni topuvchi (nc yoki nmap)
4. **Vazifa 4:** SSH bilan masofaviy komandalar bajaruvchi va natijalarni log qiluvchi skript
5. **Vazifa 5:** Network monitor: har 5 daqiqada ulanishlarni, bandwidth ni tekshiruvchi dashboard

---

## 1️⃣8️⃣ PAKET BOSHQARUV
**Global nomi:** Package Management  
**O'zbek nomi:** Paket boshqaruv

### APT (Debian/Ubuntu)

```bash
# Paketlar ro'yxatini yangilash
sudo apt update

# Tizimni yangilash
sudo apt upgrade

# Full upgrade (eski paketlarni o'chirish)
sudo apt full-upgrade

# Paket o'rnatish
sudo apt install nginx

# Ko'p paketlar
sudo apt install nginx mysql-server php

# Paket o'chirish
sudo apt remove nginx

# To'liq o'chirish (config bilan)
sudo apt purge nginx

# Paket qidirish
apt search nginx

# Paket haqida ma'lumot
apt show nginx

# O'rnatilgan paketlar
apt list --installed

# Yangilanishi kerak bo'lgan paketlar
apt list --upgradable

# Foydalanilmayotgan paketlarni tozalash
sudo apt autoremove

# Cache tozalash
sudo apt clean
sudo apt autoclean

# Broken packages tuzatish
sudo apt --fix-broken install
```

**Amaliy skript:**

```bash
#!/bin/bash

# Tizimni yangilash
echo "=== SYSTEM UPDATE ==="

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt clean

echo "✓ Update complete"

# Yangilanish kerak bo'lgan paketlar
upgradable=$(apt list --upgradable 2>/dev/null | grep -c upgradable)

if [ $upgradable -gt 0 ]; then
    echo "⚠ $upgradable paket yangilanishi kerak"
else
    echo "✓ Barcha paketlar yangi"
fi
```

### YUM/DNF (RHEL/CentOS/Fedora)

```bash
# Paketlar ro'yxatini yangilash
sudo yum check-update
sudo dnf check-update

# Paket o'rnatish
sudo yum install nginx
sudo dnf install nginx

# Paket o'chirish
sudo yum remove nginx
sudo dnf remove nginx

# Tizimni yangilash
sudo yum update
sudo dnf update

# Paket qidirish
yum search nginx
dnf search nginx

# Paket haqida ma'lumot
yum info nginx
dnf info nginx

# O'rnatilgan paketlar
yum list installed
dnf list installed

# Repository lar
yum repolist
dnf repolist

# Cache tozalash
sudo yum clean all
sudo dnf clean all

# Grouplar
sudo yum groupinstall "Development Tools"
sudo dnf groupinstall "Development Tools"
```

### Pacman (Arch Linux)

```bash
# Tizimni yangilash
sudo pacman -Syu

# Paket o'rnatish
sudo pacman -S nginx

# Paket o'chirish
sudo pacman -R nginx

# To'liq o'chirish (dependencies bilan)
sudo pacman -Rns nginx

# Paket qidirish
pacman -Ss nginx

# O'rnatilgan paketlarni qidirish
pacman -Qs nginx

# Paket haqida ma'lumot
pacman -Si nginx

# O'rnatilgan paket haqida
pacman -Qi nginx

# Orphaned paketlarni o'chirish
sudo pacman -Rns $(pacman -Qtdq)

# Cache tozalash
sudo pacman -Sc
```

### Snap (Universal packages)

```bash
# Snap o'rnatish
sudo apt install snapd

# Paket o'rnatish
sudo snap install code --classic

# O'rnatilgan paketlar
snap list

# Paket yangilash
sudo snap refresh code

# Barcha paketlarni yangilash
sudo snap refresh

# Paket o'chirish
sudo snap remove code

# Paket qidirish
snap find "text editor"

# Paket haqida ma'lumot
snap info code
```

### Flatpak (Universal packages)

```bash
# Flatpak o'rnatish
sudo apt install flatpak

# Repository qo'shish
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Paket o'rnatish
flatpak install flathub org.gimp.GIMP

# O'rnatilgan paketlar
flatpak list

# Paket ishlatish
flatpak run org.gimp.GIMP

# Paket yangilash
flatpak update org.gimp.GIMP

# Barcha paketlarni yangilash
flatpak update

# Paket o'chirish
flatpak uninstall org.gimp.GIMP
```

### From Source (Manba koddan o'rnatish)

```bash
# Dependencies o'rnatish
sudo apt install build-essential

# Download
wget https://example.com/software-1.0.tar.gz
tar -xzf software-1.0.tar.gz
cd software-1.0

# Configure
./configure --prefix=/usr/local

# Compile
make

# Install
sudo make install

# Uninstall (agar Makefile da bo'lsa)
sudo make uninstall
```

**Amaliy skript:**

```bash
#!/bin/bash

install_from_source() {
    local url=$1
    local name=$(basename "$url" .tar.gz)
    
    echo "=== Installing $name from source ==="
    
    # Download
    wget "$url" -O "/tmp/$name.tar.gz"
    
    # Extract
    tar -xzf "/tmp/$name.tar.gz" -C /tmp
    
    # Build
    cd "/tmp/$name"
    ./configure --prefix=/usr/local
    make
    sudo make install
    
    # Cleanup
    cd -
    rm -rf "/tmp/$name" "/tmp/$name.tar.gz"
    
    echo "✓ $name installed"
}

# Usage
install_from_source "https://example.com/app-1.0.tar.gz"
```

### Amaliy loyiha: Package manager

```bash
#!/bin/bash

#############################################
# UNIVERSAL PACKAGE MANAGER WRAPPER
#############################################

set -euo pipefail

# Detect OS and package manager
detect_pm() {
    if command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

PM=$(detect_pm)

if [ "$PM" = "unknown" ]; then
    echo "✗ Package manager not detected"
    exit 1
fi

# Update
pm_update() {
    echo "=== Updating package lists ==="
    
    case $PM in
        apt)
            sudo apt update
            ;;
        dnf|yum)
            sudo $PM check-update || true
            ;;
        pacman)
            sudo pacman -Sy
            ;;
    esac
}

# Upgrade
pm_upgrade() {
    echo "=== Upgrading system ==="
    
    case $PM in
        apt)
            sudo apt upgrade -y
            ;;
        dnf|yum)
            sudo $PM upgrade -y
            ;;
        pacman)
            sudo pacman -Syu --noconfirm
            ;;
    esac
}

# Install
pm_install() {
    local packages=("$@")
    
    echo "=== Installing: ${packages[*]} ==="
    
    case $PM in
        apt)
            sudo apt install -y "${packages[@]}"
            ;;
        dnf|yum)
            sudo $PM install -y "${packages[@]}"
            ;;
        pacman)
            sudo pacman -S --noconfirm "${packages[@]}"
            ;;
    esac
}

# Remove
pm_remove() {
    local packages=("$@")
    
    echo "=== Removing: ${packages[*]} ==="
    
    case $PM in
        apt)
            sudo apt remove -y "${packages[@]}"
            ;;
        dnf|yum)
            sudo $PM remove -y "${packages[@]}"
            ;;
        pacman)
            sudo pacman -R --noconfirm "${packages[@]}"
            ;;
    esac
}

# Search
pm_search() {
    local query=$1
    
    echo "=== Searching: $query ==="
    
    case $PM in
        apt)
            apt search "$query"
            ;;
        dnf|yum)
            $PM search "$query"
            ;;
        pacman)
            pacman -Ss "$query"
            ;;
    esac
}

# Info
pm_info() {
    local package=$1
    
    case $PM in
        apt)
            apt show "$package"
            ;;
        dnf|yum)
            $PM info "$package"
            ;;
        pacman)
            pacman -Si "$package"
            ;;
    esac
}

# Clean
pm_clean() {
    echo "=== Cleaning cache ==="
    
    case $PM in
        apt)
            sudo apt autoremove -y
            sudo apt clean
            ;;
        dnf|yum)
            sudo $PM autoremove -y
            sudo $PM clean all
            ;;
        pacman)
            sudo pacman -Sc --noconfirm
            ;;
    esac
}

# List installed
pm_list() {
    case $PM in
        apt)
            apt list --installed
            ;;
        dnf|yum)
            $PM list installed
            ;;
        pacman)
            pacman -Q
            ;;
    esac
}

# Usage
usage() {
    cat << EOF
Universal Package Manager Wrapper
Detected: $PM

Usage: $0 COMMAND [ARGS]

COMMANDS:
    update              Update package lists
    upgrade             Upgrade all packages
    install PKG...      Install packages
    remove PKG...       Remove packages
    search QUERY        Search packages
    info PKG            Package information
    clean               Clean cache
    list                List installed packages
    
EXAMPLES:
    $0 update
    $0 install nginx mysql
    $0 search python
    $0 clean
EOF
    exit 0
}

# Main
case ${1:-help} in
    update)
        pm_update
        ;;
    upgrade)
        pm_update
        pm_upgrade
        pm_clean
        ;;
    install)
        shift
        pm_install "$@"
        ;;
    remove)
        shift
        pm_remove "$@"
        ;;
    search)
        pm_search "$2"
        ;;
    info)
        pm_info "$2"
        ;;
    clean)
        pm_clean
        ;;
    list)
        pm_list
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        echo "Unknown command: $1"
        usage
        ;;
esac
```

### 📝 Vazifalar:

1. **Vazifa 1:** Tizimni avtomatik yangilovchi skript (update, upgrade, cleanup)
2. **Vazifa 2:** Ko'p paketlarni bir vaqtda o'rnatuvchi skript (ro'yxat fayldan)
3. **Vazifa 3:** Package manager detector: OS ni aniqlaydi va mos buyruqlarni ishlatadi
4. **Vazifa 4:** Backup qiluvchi skript: o'rnatilgan paketlar ro'yxatini saqlaydi va qayta o'rnatadi
5. **Vazifa 5:** Security updates checker: faqat xavfsizlik yangilanishlarini o'rnatadi

---

Keyingi 3 ta mavzu qoldi:
19. Best practices
20. Amaliy loyihalar
21. Cheat sheet

Davom ettiraymi?