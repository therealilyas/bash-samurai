#!/bin/bash

BACKUP_DIR="$HOME/Backups"
SANA=$(date +%Y-%m-%d_%H-%M-%S)
HOSTNAME=$(hostname)
LOG_FAYL="$BACKUP_DIR/backup.log"

mkdir -p "$BACKUP_DIR"

# Log funktsiyasi
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FAYL"
}

log "=== BACKUP BOSHLANDI ==="
log "Server: $HOSTNAME"

# Backup papkasi
BACKUP_PAPKA="$BACKUP_DIR/${HOSTNAME}_${SANA}"
mkdir -p "$BACKUP_PAPKA"

# Muhim kataloglar
declare -a KATALOGLAR=(
    "$HOME/Documents"
    "$HOME/Pictures"
    "$HOME/Projects"
    "/etc/nginx"
    "/var/www"
)

jami_hajm=0
muvaffaqiyatli=0
xato=0

for katalog in "${KATALOGLAR[@]}"; do
    if [ ! -d "$katalog" ]; then
        log "⊘ $katalog topilmadi"
        ((xato++))
        continue
    fi
    
    katalog_nomi=$(basename "$katalog")
    arxiv="${BACKUP_PAPKA}/${katalog_nomi}.tar.gz"
    
    log "⟳ Backup: $katalog"
    
    # Subshell da (parallel)
    (
        if tar -czf "$arxiv" -C "$(dirname "$katalog")" "$katalog_nomi" 2>/dev/null; then
            hajm=$(du -h "$arxiv" | cut -f1)
            log "✓ $katalog → $arxiv ($hajm)"
        else
            log "✗ Xato: $katalog"
        fi
    ) &
    
    # Maksimal 3 ta parallel
    while (( $(jobs -r | wc -l) >= 3 )); do
        sleep 1
    done
done

# Barcha tugatilishini kutish
wait

# Eski backuplarni tozalash (30 kundan eski)
log "⟳ Eski backuplarni tozalash..."
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +30 -delete

# Jami hajm
jami_hajm=$(du -sh "$BACKUP_PAPKA" | cut -f1)

log "=== NATIJA ==="
log "Backup papka: $BACKUP_PAPKA"
log "Jami hajm: $jami_hajm"
log "Muvaffaqiyatli: $muvaffaqiyatli"
log "Xatolar: $xato"
log "=== BACKUP TUGADI ==="