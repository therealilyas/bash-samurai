#!/bin/bash

INTERVAL=5  # Tekshirish oralig'i (soniya)
LOG_FAYL="system_monitor.log"

echo "=== TIZIM MONITORING BOSHLANDI ===" | tee "$LOG_FAYL"
echo "Interval: ${INTERVAL}s" | tee -a "$LOG_FAYL"
echo "Log: $LOG_FAYL" | tee -a "$LOG_FAYL"
echo "" | tee -a "$LOG_FAYL"

hisoblagich=1

while true; do
    VAQT=$(date "+%Y-%m-%d %H:%M:%S")
    
    # CPU yuklanishi
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    
    # RAM
    RAM=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100}')
    
    # Disk
    DISK=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
    
    # Log ga yozish
    echo "[$VAQT] #$hisoblagich - CPU: ${CPU}% | RAM: ${RAM}% | Disk: ${DISK}%" | tee -a "$LOG_FAYL"
    
    # Ogohlantirish
    CPU_INT=${CPU%.*}
    if [ $CPU_INT -gt 80 ] || [ ${RAM%.*} -gt 85 ] || [ $DISK -gt 90 ]; then
        echo "  ⚠️  DIQQAT: Yuqori yuklanish!" | tee -a "$LOG_FAYL"
    fi
    
    ((hisoblagich++))
    sleep $INTERVAL
done