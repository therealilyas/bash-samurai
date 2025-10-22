#!/bin/bash

BACKUP_DIR="/backup/$(date +%Y-%m-%d)"
LOG_FAYL="backup.log"

mkdir -p "$BACKUP_DIR"

backup_katalog() {
    local manba=$1
    local nomi=$(basename "$manba")
    
    echo "[$(date +%H:%M:%S)] Boshlanmoqda: $nomi" | tee -a "$LOG_FAYL"
    
    tar -czf "$BACKUP_DIR/${nomi}.tar.gz" "$manba" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "[$(date +%H:%M:%S)] ✓ Tugadi: $nomi" | tee -a "$LOG_FAYL"
    else
        echo "[$(date +%H:%M:%S)] ✗ Xato: $nomi" | tee -a "$LOG_FAYL"
    fi
}

echo "=== BACKUP BOSHLANDI ===" | tee "$LOG_FAYL"
echo "Vaqt: $(date)" | tee -a "$LOG_FAYL"
echo "" | tee -a "$LOG_FAYL"

# Parallel backup
KATALOGLAR=(
    "$HOME/Documents"
    "$HOME/Pictures"
    "$HOME/Projects"
    "$HOME/Videos"
)

for katalog in "${KATALOGLAR[@]}"; do
    if [ -d "$katalog" ]; then
        backup_katalog "$katalog" &
    fi
done

# Hammasi tugashini kutish
wait

echo "" | tee -a "$LOG_FAYL"
echo "=== BACKUP TUGADI ===" | tee -a "$LOG_FAYL"

# Statistika
jami=$(ls -1 "$BACKUP_DIR" | wc -l)
hajm=$(du -sh "$BACKUP_DIR" | cut -f1)

echo "Fayllar: $jami" | tee -a "$LOG_FAYL"
echo "Hajm: $hajm" | tee -a "$LOG_FAYL"