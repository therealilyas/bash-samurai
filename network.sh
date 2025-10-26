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
