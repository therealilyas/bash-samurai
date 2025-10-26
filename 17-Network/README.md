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