#!/bin/bash

MANBA_DIR="$HOME/Documents"
BACKUP_DIR="$HOME/Backups"
SANA=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FAYL="$BACKUP_DIR/backup_$SANA.log"

mkdir -p "$BACKUP_DIR"

echo "=== BACKUP BOSHLANMOQDA ===" | tee "$LOG_FAYL"
echo "Sana: $(date)" | tee -a "$LOG_FAYL"
echo "Manba: $MANBA_DIR" | tee -a "$LOG_FAYL"
echo "" | tee -a "$LOG_FAYL"

nusxalandi=0
xato=0

for fayl in "$MANBA_DIR"/*; do
    if [ -f "$fayl" ]; then
        fayl_nomi=$(basename "$fayl")
        
        if cp "$fayl" "$BACKUP_DIR/${fayl_nomi}_$SANA"; then
            echo "✓ $fayl_nomi" | tee -a "$LOG_FAYL"
            ((nusxalandi++))
        else
            echo "✗ $fayl_nomi - XATO!" | tee -a "$LOG_FAYL"
            ((xato++))
        fi
    fi
done

echo "" | tee -a "$LOG_FAYL"
echo "=== NATIJA ===" | tee -a "$LOG_FAYL"
echo "Nusxalandi: $nusxalandi" | tee -a "$LOG_FAYL"
echo "Xatolar: $xato" | tee -a "$LOG_FAYL"