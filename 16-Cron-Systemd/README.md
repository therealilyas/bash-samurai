
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