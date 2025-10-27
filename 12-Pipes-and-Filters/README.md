## 1️⃣2️⃣ PIPE VA FILTRLAR (grep, awk, sed, cut, sort, uniq)
**Global nomi:** Pipes and Filters  
**O'zbek nomi:** Pipe va filtrlar

### Pipe (|) nima?

Pipe - bu bir buyruqning natijasini boshqa buyruqqa uzatish. Konveyer lentasidek.

**Hayotiy misol:** Zavod konveyeri - har bir ishchi o'z ishini qiladi va keyingisiga uzatadi. Birinchisi kesadi, ikkinchisi bo'yaydi, uchinchisi qadoqlaydi.

```bash
# Oddiy pipe
ls | wc -l                # Fayllar sonini sanash

# Ko'p pipe
cat fayl.txt | grep "muhim" | sort | uniq
```

### grep - Qidirish filtri

`grep` - matndan kerakli qatorlarni topish.

**Global pattern:** grep = Global Regular Expression Print

#### Asosiy ishlatish:

```bash
# Oddiy qidirish
grep "qidiruv" fayl.txt

# Katta-kichik harfga e'tibor bermay
grep -i "qidiruv" fayl.txt

# Butun so'zni qidirish
grep -w "test" fayl.txt

# Qator raqami bilan
grep -n "xato" log.txt

# Invers (ushbu so'z BO'LMAGAN qatorlar)
grep -v "spam" email.txt

# Rekursiv (barcha fayllarda)
grep -r "TODO" /project/

# Faqat fayl nomlari
grep -l "error" *.log

# Faqat sonini ko'rsatish
grep -c "success" log.txt
```

**Hayotiy misollar:**

```bash
# IP manzillarni topish
grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' access.log

# Email topish
grep -E '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' users.txt

# Xatolarni filtrlash
grep -i "error\|warning\|critical" system.log

# Kontekst bilan (oldingi va keyingi qatorlar)
grep -C 3 "exception" app.log    # 3 ta qator oldin va keyin
grep -B 2 "error" app.log         # 2 ta qator oldin
grep -A 5 "error" app.log         # 5 ta qator keyin
```

**Pipe bilan:**
```bash
# Fayllar ichidan qidirish
ls -la | grep "\.txt$"

# Process topish
ps aux | grep "nginx"

# Active userlar
who | grep -v "^$"

# Log dan IP lar
cat access.log | grep "404" | awk '{print $1}' | sort | uniq
```

### awk - Matn qayta ishlash tili

`awk` - ustunlar bilan ishlash uchun kuchli vosita.

#### Asosiy tushunchalar:

- `$1, $2, $3` - ustunlar (bo'sh joy yoki tab bilan ajratilgan)
- `$0` - butun qator
- `NR` - qator raqami
- `NF` - ustunlar soni

```bash
# Birinchi ustunni chiqarish
awk '{print $1}' fayl.txt

# Bir nechta ustun
awk '{print $1, $3}' fayl.txt

# Maxsus format
awk '{print "Ism:", $1, "Yosh:", $2}' users.txt

# Hisob-kitoblar
awk '{sum += $1} END {print "Jami:", sum}' raqamlar.txt
```

**Hayotiy misollar:**

```bash
# Disk hajmini ko'rish (faqat foiz)
df -h | awk 'NR>1 {print $5, $6}'

# RAM ishlatilishi
free -m | awk 'NR==2 {printf "%.2f%%\n", $3/$2*100}'

# CSV dan ustun olish
awk -F',' '{print $2}' data.csv

# Log dan IP va vaqt
awk '{print $1, $4}' access.log

# Shartli chiqarish
awk '$3 > 100 {print $1, $3}' sales.txt    # 3-ustun 100 dan katta

# Bir nechta shart
awk '$3 > 50 && $4 == "active" {print $0}' users.txt
```

**Murakkab misollar:**

```bash
# Jami va o'rtacha
awk '{sum+=$1; count++} END {print "Jami:", sum, "O'rtacha:", sum/count}' numbers.txt

# Top 10 IP
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# CSV ni HTML jadvalga
awk -F',' 'BEGIN {print "<table>"} 
             {print "<tr><td>" $1 "</td><td>" $2 "</td></tr>"} 
             END {print "</table>"}' data.csv
```

### sed - Matn tahrirlovchi

`sed` - Stream EDitor, matnni qayta ishlash va o'zgartirish uchun.

#### Asosiy buyruqlar:

```bash
# Almashtirish (birinchi uchraganini)
sed 's/eski/yangi/' fayl.txt

# Barcha uchraganlarini almashtirish
sed 's/eski/yangi/g' fayl.txt

# Katta-kichik harfga e'tibor bermay
sed 's/eski/yangi/gi' fayl.txt

# Faylni o'zgartirish (-i)
sed -i 's/eski/yangi/g' fayl.txt

# Ma'lum qatorni o'chirish
sed '3d' fayl.txt                 # 3-qatorni o'chirish
sed '1,5d' fayl.txt               # 1-5 qatorlarni o'chirish
sed '/pattern/d' fayl.txt         # Pattern bo'lgan qatorlarni

# Qatorlarni chiqarish
sed -n '1,10p' fayl.txt           # Faqat 1-10 qatorlar
sed -n '/pattern/p' fayl.txt      # Faqat pattern bo'lgan qatorlar
```

**Hayotiy misollar:**

```bash
# IP manzilni almashtirish
sed 's/192.168.1.1/10.0.0.1/g' config.txt

# Izohlarni o'chirish
sed '/^#/d' skript.sh

# Bo'sh qatorlarni o'chirish
sed '/^$/d' fayl.txt

# Qator boshiga qo'shish
sed 's/^/PREFIX: /' fayl.txt

# Qator oxiriga qo'shish
sed 's/$/ - SUFFIX/' fayl.txt

# Ma'lum qatordan keyin qo'shish
sed '/pattern/a\Yangi qator' fayl.txt

# Ma'lum qatordan oldin qo'shish
sed '/pattern/i\Yangi qator' fayl.txt

# Qatorni almashtirish
sed '/pattern/c\Yangi matn' fayl.txt
```

**Murakkab misollar:**

```bash
# HTML teglarni o'chirish
sed 's/<[^>]*>//g' index.html

# Email maskirovka
sed 's/\([a-z]\)[a-z]*@/\1***@/g' emails.txt
# sardor@example.com → s***@example.com

# Raqamlarni format qilish
sed 's/\([0-9]\{3\}\)\([0-9]\{3\}\)\([0-9]\{4\}\)/\1-\2-\3/' phones.txt
# 9981234567 → 998-123-4567

# Bir nechta almashtirish
sed -e 's/foo/bar/g' -e 's/hello/salom/g' fayl.txt

# Config faylni yangilash
sed -i.backup 's/^port=.*/port=8080/' config.ini
```

### cut - Ustunlarni kesish

```bash
# Ma'lum ustunni olish (bo'sh joy bilan)
cut -d' ' -f1 fayl.txt            # Birinchi ustun

# Bir nechta ustun
cut -d',' -f1,3 data.csv          # 1 va 3-ustunlar

# Diapazon
cut -d':' -f1-3 /etc/passwd       # 1 dan 3 gacha

# Belgilar pozitsiyasi bo'yicha
cut -c1-10 fayl.txt               # Birinchi 10 ta belgi
```

**Hayotiy misollar:**

```bash
# Foydalanuvchi nomlari
cut -d':' -f1 /etc/passwd

# CSV dan email
cut -d',' -f3 users.csv

# Log dan vaqt
cut -d' ' -f4,5 access.log

# PATH ni ajratish
echo $PATH | tr ':' '\n'
```

### sort - Saralash

```bash
# Alifbo tartibida
sort fayl.txt

# Teskari tartibda
sort -r fayl.txt

# Raqamli tartibda
sort -n numbers.txt

# Ma'lum ustun bo'yicha
sort -k2 fayl.txt                 # 2-ustun bo'yicha
sort -t',' -k3 data.csv           # Vergul bilan, 3-ustun

# Unique + sort
sort -u fayl.txt                  # Dublikatlarni olib tashlash

# Katta-kichik harfga e'tibor bermay
sort -f fayl.txt

# Inson o'qiy oladigan raqamlar (1K, 1M)

```bash
# Inson o'qiy oladigan raqamlar (1K, 1M)
sort -h fayl.txt

# Bir nechta kalit
sort -k1,1 -k2n fayl.txt          # 1-ustun matn, 2-ustun raqam
```

**Hayotiy misollar:**

```bash
# Fayllarni hajmi bo'yicha
ls -lh | sort -k5 -h

# IP manzillarni saralash
sort -t'.' -k1,1n -k2,2n -k3,3n -k4,4n ip_list.txt

# Sanani saralash
sort -t'-' -k1,1n -k2,2n -k3,3n dates.txt

# En ko'p takrorlangan qatorlar
sort fayl.txt | uniq -c | sort -rn | head -10

# Foydalanuvchilarni ID bo'yicha
sort -t':' -k3 -n /etc/passwd
```

### uniq - Dublikatlarni boshqarish

**⚠️ Muhim:** `uniq` faqat ketma-ket turgan dublikatlarni o'chiradi! Avval `sort` qiling!

```bash
# Dublikatlarni o'chirish
sort fayl.txt | uniq

# Dublikatlarni sanash
sort fayl.txt | uniq -c

# Faqat dublikatlarni ko'rsatish
sort fayl.txt | uniq -d

# Faqat noyob qatorlar
sort fayl.txt | uniq -u

# Ma'lum ustunni e'tiborsiz qoldirish
uniq -f1 fayl.txt                 # Birinchi ustunni e'tiborsiz

# Katta-kichik harfga e'tibor bermay
uniq -i fayl.txt
```

**Hayotiy misollar:**

```bash
# En ko'p uchraydigan so'zlar
cat book.txt | tr ' ' '\n' | sort | uniq -c | sort -rn | head -20

# IP statistikasi
awk '{print $1}' access.log | sort | uniq -c | sort -rn

# Faqat bir marta uchraganlar
sort words.txt | uniq -u

# Dublikatlar ro'yxati
sort emails.txt | uniq -d

# Har bir element necha marta
cat items.txt | sort | uniq -c | awk '{print $2 ": " $1 " marta"}'
```

### tr - Belgilarni almashtirish

```bash
# Kichik harfga
tr 'A-Z' 'a-z' < fayl.txt

# Katta harfga
tr 'a-z' 'A-Z' < fayl.txt

# Bo'sh joylarni o'chirish
tr -d ' ' < fayl.txt

# Ketma-ket bo'sh joylarni bitta qilish
tr -s ' ' < fayl.txt

# Yangi qatorni vergulga
tr '\n' ',' < fayl.txt

# Maxsus belgilarni o'chirish
tr -d '[:punct:]' < fayl.txt
```

**Hayotiy misollar:**

```bash
# DOS formatni Unix ga
tr -d '\r' < windows.txt > unix.txt

# Raqamlarni o'chirish
tr -d '0-9' < fayl.txt

# Faqat raqamlarni qoldirish
tr -cd '0-9' < fayl.txt

# Parol yaratish
tr -dc 'A-Za-z0-9!@#$%' < /dev/urandom | head -c 16
```

### paste - Qatorlarni birlashtirish

```bash
# Ikki faylni yonma-yon
paste fayl1.txt fayl2.txt

# Maxsus delimiter
paste -d',' fayl1.txt fayl2.txt

# Barcha qatorlarni bitta qatorda
paste -s fayl.txt

# Bir nechta fayl
paste fayl1.txt fayl2.txt fayl3.txt
```

**Hayotiy misol:**
```bash
# Ism va email birlashtirish
paste -d',' ismlar.txt emaillar.txt > contacts.csv
```

### join - Umumiy maydon bo'yicha birlashtirish (SQL JOIN)

```bash
# Birinchi ustun bo'yicha
join fayl1.txt fayl2.txt

# Ma'lum ustun bo'yicha
join -1 2 -2 1 fayl1.txt fayl2.txt    # fayl1 ning 2-ustuni = fayl2 ning 1-ustuni

# Maxsus delimiter
join -t',' fayl1.csv fayl2.csv

# Left join (fayl1 dagi barcha qatorlar)
join -a1 fayl1.txt fayl2.txt

# Full outer join
join -a1 -a2 fayl1.txt fayl2.txt
```

### Murakkab Pipe zanjiri

#### 1. Log tahlil tizimi

```bash
#!/bin/bash

LOG="/var/log/nginx/access.log"

echo "=== TOP 10 IP MANZILLAR ==="
awk '{print $1}' "$LOG" | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -10 | \
    awk '{printf "%15s : %5d ta so'\''rov\n", $2, $1}'

echo ""
echo "=== TOP 10 SAHIFALAR ==="
awk '{print $7}' "$LOG" | \
    grep -v '\.\(jpg\|png\|css\|js\)$' | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -10

echo ""
echo "=== STATUS KODLAR ==="
awk '{print $9}' "$LOG" | \
    sort | \
    uniq -c | \
    sort -rn | \
    awk '{printf "%3s : %6d ta\n", $2, $1}'

echo ""
echo "=== TRAFIK BO'YICHA (eng katta fayllar) ==="
awk '{print $10, $7}' "$LOG" | \
    grep -v '^-' | \
    sort -rn | \
    head -10 | \
    awk '{printf "%10s bayt : %s\n", $1, $2}'

echo ""
echo "=== SOATLIK STATISTIKA ==="
awk '{print $4}' "$LOG" | \
    cut -d: -f2 | \
    sort | \
    uniq -c | \
    awk '{printf "%02d:00 - %5d ta so'\''rov\n", $2, $1}'
```

#### 2. Sistem ma'lumotlari to'playdi

```bash
#!/bin/bash

{
    echo "=== TIZIM MA'LUMOTLARI ==="
    echo "Sana: $(date)"
    echo "Host: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo ""
    
    echo "=== CPU ==="
    top -bn1 | grep "Cpu(s)" | \
        sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | \
        awk '{printf "Ishlatilmoqda: %.1f%%\n", 100 - $1}'
    
    echo ""
    echo "=== RAM ==="
    free -h | awk 'NR==2 {printf "Jami: %s | Ishlatilgan: %s (%.1f%%)\n", $2, $3, $3/$2*100}'
    
    echo ""
    echo "=== DISK ==="
    df -h | grep '^/dev/' | \
        awk '{printf "%-20s %8s / %8s (%s)\n", $6, $3, $2, $5}'
    
    echo ""
    echo "=== ENG KO'P RAM ISHLATUVCHILAR ==="
    ps aux | sort -k4 -rn | head -6 | \
        awk 'NR>1 {printf "%5.1f%% %-20s %s\n", $4, $11, $2}'
    
    echo ""
    echo "=== ENG KO'P CPU ISHLATUVCHILAR ==="
    ps aux | sort -k3 -rn | head -6 | \
        awk 'NR>1 {printf "%5.1f%% %-20s %s\n", $3, $11, $2}'
    
    echo ""
    echo "=== TARMOQ ULANISHLARI ==="
    netstat -tn 2>/dev/null | grep ESTABLISHED | \
        awk '{print $5}' | \
        cut -d: -f1 | \
        sort | uniq -c | sort -rn | \
        awk '{printf "%3d ta ulanish : %s\n", $1, $2}'
    
} | tee system_report_$(date +%Y%m%d_%H%M%S).txt
```

#### 3. CSV qayta ishlash

```bash
#!/bin/bash

# Sotuvlar ma'lumotini tahlil qilish
# Format: sana,mahsulot,miqdor,narx

CSV="sales.csv"

echo "=== SOTUVLAR TAHLILI ==="
echo ""

# Jami sotuvlar
echo "Jami sotuvlar:"
awk -F',' 'NR>1 {sum += $3 * $4} END {printf "%.2f so'\''m\n", sum}' "$CSV"

echo ""
echo "Top 5 mahsulotlar:"
awk -F',' 'NR>1 {sales[$2] += $3 * $4} END {for (p in sales) print sales[p], p}' "$CSV" | \
    sort -rn | \
    head -5 | \
    awk '{printf "%10.2f so'\''m - %s\n", $1, $2}'

echo ""
echo "Kunlik statistika:"
awk -F',' 'NR>1 {daily[$1] += $3 * $4} END {for (d in daily) print d, daily[d]}' "$CSV" | \
    sort | \
    awk '{printf "%s : %10.2f so'\''m\n", $1, $2}'

echo ""
echo "O'rtacha sotuvlar:"
awk -F',' 'NR>1 {sum += $3 * $4; count++} END {printf "%.2f so'\''m\n", sum/count}' "$CSV"
```

#### 4. Email extractor va validator

```bash
#!/bin/bash

# Matndan emaillarni ajratib olish va validatsiya qilish

echo "Emaillarni qidirish..."

grep -Eoh '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' *.txt | \
    sort -u | \
    while read email; do
        # Email validatsiya
        if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
            # Domen ajratish
            domen=$(echo "$email" | cut -d'@' -f2)
            echo "$email ($domen)"
        fi
    done | \
    tee emails_list.txt

echo ""
echo "Domen bo'yicha statistika:"
awk -F'[@()]' '{print $2}' emails_list.txt | \
    sort | uniq -c | sort -rn | \
    awk '{printf "%3d ta : %s\n", $1, $2}'
```

#### 5. Real-time log monitor

```bash
#!/bin/bash

LOG="/var/log/nginx/access.log"
INTERVAL=5

echo "Real-time monitoring ($INTERVAL soniya interval)"
echo "Ctrl+C - to'xtatish"
echo ""

while true; do
    clear
    echo "=== $(date) ==="
    echo ""
    
    echo "So'ng ${INTERVAL}s ichida:"
    
    # Oxirgi n qatorni olish
    recent=$(tail -n 1000 "$LOG" | \
             awk -v cutoff="$(date -d "$INTERVAL seconds ago" '+%d/%b/%Y:%H:%M:%S')" \
             '$4 > "["cutoff')
    
    echo ""
    echo "Top IP lar:"
    echo "$recent" | awk '{print $1}' | sort | uniq -c | sort -rn | head -5
    
    echo ""
    echo "Status kodlar:"
    echo "$recent" | awk '{print $9}' | sort | uniq -c | sort -rn
    
    echo ""
    echo "Top sahifalar:"
    echo "$recent" | awk '{print $7}' | sort | uniq -c | sort -rn | head -5
    
    sleep $INTERVAL
done
```

### Amaliy loyiha: To'liq log analyzer

```bash
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
```

### 📝 Vazifalar:

1. **Vazifa 1:** `grep`, `awk`, `sort`, `uniq` dan foydalanib, log fayldagi eng ko'p takrorlangan IP manzillarni toping
2. **Vazifa 2:** CSV fayldan ma'lum ustunlarni olib, `sed` bilan qayta ishlab, yangi CSV yarating
3. **Vazifa 3:** Pipe zanjiri: Fayllarni hajmi bo'yicha saralab, eng katta 10 tasini formatted chiqaring
4. **Vazifa 4:** `awk` yordamida oddiy kalkulator: ikki ustunli fayl (son1, son2), ularning yig'indisi va o'rtachasini hisoblang
5. **Vazifa 5:** Real-time CPU/RAM monitorini `top`, `awk`, `grep` bilan yozing, har 3 soniyada yangilangan

---