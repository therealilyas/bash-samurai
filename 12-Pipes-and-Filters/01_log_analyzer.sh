#!/bin/bash

# ====================================
# NGINX LOG ANALYZER
# ====================================

LOG_FAYL="${1:-/var/log/nginx/access.log}"
NATIJA_DIR="log_tahlil_$(date +%Y%m%d_%H%M%S)"

# Papka yaratish
mkdir -p "$NATIJA_DIR"

echo "=== LOG TAHLIL TIZIMI ==="
echo "Log fayl: $LOG_FAYL"
echo "Natija: $NATIJA_DIR"
echo ""

# 1. Umumiy statistika
{
    echo "=== UMUMIY STATISTIKA ==="
    echo "Jami so'rovlar: $(wc -l < "$LOG_FAYL")"
    echo "Birinchi so'rov: $(head -1 "$LOG_FAYL" | awk '{print $4, $5}')"
    echo "Oxirgi so'rov: $(tail -1 "$LOG_FAYL" | awk '{print $4, $5}')"
    echo ""
} | tee "$NATIJA_DIR/umumiy.txt"

# 2. IP statistika
{
    echo "=== TOP 20 IP MANZILLAR ==="
    awk '{print $1}' "$LOG_FAYL" | \
        sort | uniq -c | sort -rn | head -20 | \
        awk '{printf "%7d ta so'\''rov : %s\n", $1, $2}'
    
    echo ""
    echo "=== GEOGRAFIYA (agar GeoIP o'rnatilgan bo'lsa) ==="
    awk '{print $1}' "$LOG_FAYL" | sort -u | \
        while read ip; do
            country=$(geoiplookup "$ip" 2>/dev/null | cut -d: -f2 | cut -d, -f1)
            echo "$country"
        done | sort | uniq -c | sort -rn | head -10
        
} | tee "$NATIJA_DIR/ip_statistika.txt"

# 3. Status kodlar
{
    echo "=== STATUS KODLAR ==="
    awk '{print $9}' "$LOG_FAYL" | \
        sort | uniq -c | sort -rn | \
        awk '{
            code=$2
            count=$1
            if (code ~ /^2/) status="✓ Muvaffaqiyat"
            else if (code ~ /^3/) status="↻ Redirect"
            else if (code ~ /^4/) status="✗ Mijoz xatosi"
            else if (code ~ /^5/) status="✗ Server xatosi"
            else status="?"
            printf "%3s : %6d ta (%s)\n", code, count, status
        }'
} | tee "$NATIJA_DIR/status_kodlar.txt"

# 4. Sahifalar
{
    echo "=== TOP 50 SAHIFALAR ==="
    awk '{print $7}' "$LOG_FAYL" | \
        grep -v '\.\(jpg\|jpeg\|png\|gif\|css\|js\|ico\|woff\|ttf\)$' | \
        sort | uniq -c | sort -rn | head -50 | \
        awk '{printf "%6d ta : %s\n", $1, $2}'
} | tee "$NATIJA_DIR/top_sahifalar.txt"

# 5. Xatolar
{
    echo "=== 4XX XATOLAR ==="
    awk '$9 ~ /^4/ {print $7, $9}' "$LOG_FAYL" | \
        sort | uniq -c | sort -rn | head -20 | \
        awk '{printf "%6d ta : %s (kod: %s)\n", $1, $2, $3}'
    
    echo ""
    echo "=== 5XX XATOLAR ==="
    awk '$9 ~ /^5/ {print $7, $9}' "$LOG_FAYL" | \
        sort | uniq -c | sort -rn | head -20 | \
        awk '{printf "%6d ta : %s (kod: %s)\n", $1, $2, $3}'
} | tee "$NATIJA_DIR/xatolar.txt"

# 6. Vaqt tahlili
{
    echo "=== SOATLIK TAQSIMOT ==="
    awk '{print $4}' "$LOG_FAYL" | \
        cut -d: -f2 | \
        sort | uniq -c | \
        awk '{printf "%02d:00 - %02d:59 : %5d ta so'\''rov ", $2, $2, $1; 
              for(i=0;i<$1/100;i++) printf "█"; printf "\n"}'
    
    echo ""
    echo "=== KUNLIK TAQSIMOT ==="
    awk '{print $4}' "$LOG_FAYL" | \
        cut -d: -f1 | cut -d'/' -f1 | \
        sort | uniq -c | \
        awk '{printf "%2s : %6d ta so'\''rov\n", $2, $1}'
} | tee "$NATIJA_DIR/vaqt_tahlili.txt"

# 7. User Agent
{
    echo "=== TOP BRAUZERLAR ==="
    awk -F'"' '{print $6}' "$LOG_FAYL" | \
        grep -v '^$' | \
        sort | uniq -c | sort -rn | head -20 | \
        awk '{$1=$1; printf "%6d ta : %s\n", $1, substr($0, index($0,$2))}'
    
    echo ""
    echo "=== BOTLAR ==="
    awk -F'"' '$6 ~ /[Bb]ot|[Ss]pider|[Cc]rawl/ {print $6}' "$LOG_FAYL" | \
        sort | uniq -c | sort -rn | head -10
} | tee "$NATIJA_DIR/user_agents.txt"

# 8. Trafik hajmi
{
    echo "=== TRAFIK TAHLILI ==="
    
    jami=$(awk '{sum += $10} END {print sum}' "$LOG_FAYL")
    echo "Jami trafik: $(echo "scale=2; $jami/1024/1024/1024" | bc) GB"
    
    echo ""
    echo "=== ENG KATTA FAYLLAR ==="
    awk '$10 ~ /^[0-9]+$/ {print $10, $7}' "$LOG_FAYL" | \
        sort -rn | head -20 | \
        awk '{printf "%10s MB : %s\n", $1/1024/1024, $2}'
} | tee "$NATIJA_DIR/trafik.txt"

# 9. Referer
{
    echo "=== TOP REFERERLAR ==="
    awk -F'"' '{print $4}' "$LOG_FAYL" | \
        grep -v '^-$' | grep -v '^$' | \
        sort | uniq -c | sort -rn | head -20 | \
        awk '{$1=$1; printf "%6d ta : %s\n", $1, substr($0, index($0,$2))}'
} | tee "$NATIJA_DIR/refererlar.txt"

# 10. HTML hisobot yaratish
{
    cat << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Log Tahlili</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; }
        h1 { color: #333; border-bottom: 3px solid #007bff; padding-bottom: 10px; }
        h2 { color: #555; margin-top: 30px; }
        pre { background: #f8f9fa; padding: 15px; border-left: 4px solid #007bff; overflow-x: auto; }
        .timestamp { color: #999; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Nginx Log Tahlili</h1>
        <p class="timestamp">Yaratilgan: $(date)</p>
        <p><strong>Log fayl:</strong> $LOG_FAYL</p>
EOF

    for fayl in "$NATIJA_DIR"/*.txt; do
        echo "<h2>$(basename "$fayl" .txt)</h2>"
        echo "<pre>$(cat "$fayl")</pre>"
    done

    echo "</div></body></html>"
} > "$NATIJA_DIR/hisobot.html"

echo ""
echo "✓ Tahlil tugadi!"
echo "📁 Natijalar: $NATIJA_DIR/"
echo "🌐 HTML hisobot: $NATIJA_DIR/hisobot.html"