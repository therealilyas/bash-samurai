## 1️⃣1️⃣ FAYL KIRITISH/CHIQARISH VA REDIREKTSIYA
**Global nomi:** File I/O and Redirection  
**O'zbek nomi:** Fayl kiritish/chiqarish va yo'naltirish

### Redirection nima?

Redirection - bu ma'lumot oqimini boshqarish. Dastur natijasini ekranga emas, faylga yozish yoki fayldan o'qish.

**Hayotiy misol:** Suv quvurini turli joylarga yo'naltirish - bog'ga, hovuzga yoki idishga. Ma'lumot ham shunday yo'naltiriladi.

### Standard oqimlar (Streams)

Har bir dastur 3 ta asosiy oqimga ega:

1. **stdin (0)** - Standard Input (kiritish) - klaviaturadan
2. **stdout (1)** - Standard Output (chiqarish) - ekranga
3. **stderr (2)** - Standard Error (xato) - ekranga (xatolar)

```bash
# Oddiy buyruq
echo "Salom"
# stdout → ekranga "Salom"

# Mavjud bo'lmagan fayl
cat mavjud_emas.txt
# stderr → ekranga "cat: mavjud_emas.txt: No such file or directory"
```

### Output Redirection - Chiqarishni yo'naltirish

#### `>` - Faylga yozish (ustiga)

```bash
# Echo natijasini faylga
echo "Salom Dunyo" > fayl.txt

# Buyruq natijasini saqlash
ls -la > fayllar_royxati.txt

# Bir nechta qatorni yozish
cat > matn.txt
Bu birinchi qator
Bu ikkinchi qator
Bu uchinchi qator
# Ctrl+D bosing tugash uchun
```

**⚠️ Diqqat:** `>` mavjud faylni o'chiradi va yangi yozadi!

```bash
echo "Birinchi" > test.txt
cat test.txt           # Birinchi

echo "Ikkinchi" > test.txt
cat test.txt           # Ikkinchi (birinchi o'chdi!)
```

#### `>>` - Faylga qo'shish (oxiriga)

```bash
# Faylning oxiriga qo'shish
echo "Yangi qator" >> fayl.txt

# Log ga yozish
echo "$(date): Dastur boshlandi" >> app.log
echo "$(date): Foydalanuvchi kirdi" >> app.log
```

**Hayotiy misol: Log fayli**
```bash
#!/bin/bash

LOG="dastur.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

log "Dastur ishga tushdi"
log "Ma'lumotlar bazaga ulandi"
log "Foydalanuvchi: $(whoami)"
log "Dastur tugadi"

cat "$LOG"
```

#### `>` vs `>>` farqi

```bash
# Yangi fayl
> fayl.txt                    # Bo'sh fayl yaratish
echo "1" > fayl.txt           # "1" yozish
echo "2" >> fayl.txt          # "1\n2"
echo "3" >> fayl.txt          # "1\n2\n3"

cat fayl.txt
# 1
# 2
# 3
```

### Input Redirection - Kiritishni yo'naltirish

#### `<` - Fayldan o'qish

```bash
# Faylni buyruqga kiritish
wc -l < fayl.txt              # Qatorlar sonini sanash

# sort ga kiritish
sort < tartibsiz.txt

# while ga kiritish
while read qator; do
    echo "Qator: $qator"
done < fayl.txt
```

**Hayotiy misol: Email ro'yxatini qayta ishlash**
```bash
#!/bin/bash

while IFS=',' read ism email telefon; do
    echo "Ism: $ism"
    echo "Email: $email"
    echo "Telefon: $telefon"
    echo "---"
done < foydalanuvchilar.csv
```

#### `<<` - Here Document (Heredoc)

Ko'p qatorli matnni kiritish:

```bash
cat << EOF
Bu birinchi qator
Bu ikkinchi qator
Bu uchinchi qator
EOF
```

**Faylga yozish:**
```bash
cat << EOF > xabar.txt
Hurmatli foydalanuvchi,

Sizning hisobingiz faollashtirildi.
Tizimga kirish uchun quyidagi ma'lumotlarni ishlating:

Username: $USER
Sana: $(date)

Hurmat bilan,
Tizim administratori
EOF
```

**O'zgaruvchilarni escape qilish:**
```bash
# O'zgaruvchilar ishlaydi
cat << EOF
Foydalanuvchi: $USER
Uy: $HOME
EOF

# O'zgaruvchilar ishlamaydi (qo'shtirnoq)
cat << 'EOF'
Foydalanuvchi: $USER
Uy: $HOME
EOF
```

**Hayotiy misol: SQL skript yaratish**
```bash
#!/bin/bash

DB_USER="admin"
DB_NAME="mydb"

mysql -u "$DB_USER" "$DB_NAME" << EOF
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, email) VALUES
('sardor', 'sardor@example.com'),
('olim', 'olim@example.com');

SELECT * FROM users;
EOF
```

#### `<<<` - Here String

Bitta qator matnni kiritish:

```bash
# Oddiy
wc -w <<< "Salom Dunyo Bash"    # 3

# O'zgaruvchi bilan
matn="Bu test matni"
wc -w <<< "$matn"                # 4

# bc ga kiritish
natija=$(bc <<< "10 + 20 * 3")
echo $natija                     # 70
```

### Error Redirection - Xatolarni yo'naltirish

#### `2>` - Xatolarni faylga

```bash
# Faqat xatolarni faylga
ls mavjud_emas.txt 2> xato.log

# Xatolarni yo'qotish
ls mavjud_emas.txt 2> /dev/null

# Oddiy natija ekranga, xatolar faylga
ls /etc /mavjud_emas > natija.txt 2> xato.log
```

#### `2>>` - Xatolarni qo'shib yozish

```bash
# Xatolar logiga qo'shish
find / -name "test.txt" 2>> xatolar.log
```

#### `&>` yoki `>&` - Hammasi bir faylga

```bash
# Natija va xatolar bitta faylga
ls /etc /mavjud_emas &> barchasi.log
# yoki
ls /etc /mavjud_emas >& barchasi.log

# Hammasi append
ls /etc /mavjud_emas &>> barchasi.log
```

#### `2>&1` - Xatolarni stdout ga yo'naltirish

```bash
# Xatolarni ham stdout ga
ls /etc /mavjud_emas > natija.txt 2>&1

# /dev/null ga yo'qotish
command > /dev/null 2>&1
```

**⚠️ Tartib muhim:**
```bash
# NOTO'G'RI
command 2>&1 > fayl.txt    # Faqat stdout faylga, stderr ekranga

# TO'G'RI
command > fayl.txt 2>&1    # Ikkalasi ham faylga
```

**Hayotiy misol: Xatolarni alohida saqlash**
```bash
#!/bin/bash

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

SANA=$(date +%Y-%m-%d)
STDOUT_LOG="$LOG_DIR/output_$SANA.log"
STDERR_LOG="$LOG_DIR/errors_$SANA.log"

# Murakkab operatsiya
{
    echo "Backup boshlanmoqda..."
    tar -czf backup.tar.gz /muhim_papka
    echo "Backup tugadi"
} > "$STDOUT_LOG" 2> "$STDERR_LOG"

# Xatolar bormi?
if [ -s "$STDERR_LOG" ]; then
    echo "⚠️ Xatolar mavjud!"
    cat "$STDERR_LOG"
else
    echo "✓ Muvaffaqiyatli tugadi"
fi
```

### File Descriptors - Fayl deskriptorlar

Linux da har bir ochiq fayl raqam bilan ifodalanadi:
- 0 = stdin
- 1 = stdout
- 2 = stderr
- 3, 4, 5... = maxsus fayllar

#### Maxsus file descriptor yaratish

```bash
#!/bin/bash

# 3-deskriptorni ochish (yozish uchun)
exec 3> output.log

# 3 ga yozish
echo "Bu logga ketadi" >&3
echo "Bu ham" >&3

# Yopish
exec 3>&-

cat output.log
```

**Ikki yo'nalishli descriptor:**
```bash
#!/bin/bash

# O'qish va yozish uchun
exec 3<> temp.txt

# Yozish
echo "Test matn" >&3

# Boshiga qaytish
exec 3>&0

# O'qish
while read -u 3 qator; do
    echo "O'qildi: $qator"
done

# Yopish
exec 3>&-
```

### Pipe va Redirection birgalikda

```bash
# stdout faylga, stderr ekranga
command > output.txt | grep "error"    # NOTO'G'RI (pipe birinchi)

# To'g'ri usul
command 2>&1 | tee output.txt | grep "error"

# Filtrlab faylga
command 2>&1 | grep "muhim" > filtered.log
```

### tee - Ekranga ham, faylga ham

`tee` - bir vaqtning o'zida ekranga va faylga yozadi.

```bash
# Ekranga ham, faylga ham
ls -la | tee fayllar.txt

# Append qilish
echo "Yangi qator" | tee -a fayl.txt

# Bir nechta faylga
command | tee fayl1.txt fayl2.txt fayl3.txt

# sudo bilan faylga yozish
echo "matn" | sudo tee /etc/config.txt > /dev/null
```

**Hayotiy misol: Real-time monitoring**
```bash
#!/bin/bash

LOG="monitor.log"

while true; do
    {
        echo "=== $(date) ==="
        echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')"
        echo "RAM: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')"
        echo "Disk: $(df -h / | awk 'NR==2{print $5}')"
        echo ""
    } | tee -a "$LOG"
    
    sleep 5
done
```

### Amaliy namunalar

#### 1. Log analyzer

```bash
#!/bin/bash

LOG_FAYL="/var/log/nginx/access.log"
NATIJA="log_tahlil.txt"

{
    echo "=== LOG TAHLILI ==="
    echo "Sana: $(date)"
    echo ""
    
    echo "Jami so'rovlar:"
    wc -l < "$LOG_FAYL"
    echo ""
    
    echo "Top 10 IP manzillar:"
    awk '{print $1}' "$LOG_FAYL" | sort | uniq -c | sort -rn | head -10
    echo ""
    
    echo "Top 10 sahifalar:"
    awk '{print $7}' "$LOG_FAYL" | sort | uniq -c | sort -rn | head -10
    echo ""
    
    echo "Status kodlar:"
    awk '{print $9}' "$LOG_FAYL" | sort | uniq -c | sort -rn
    
} > "$NATIJA" 2>&1

echo "✓ Tahlil tugadi: $NATIJA"
```

#### 2. Backup tizimi (to'liq loglar bilan)

```bash
#!/bin/bash

BACKUP_DIR="/backup"
LOG_DIR="/var/log/backup"
SANA=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p "$LOG_DIR"

STDOUT_LOG="$LOG_DIR/backup_${SANA}.log"
STDERR_LOG="$LOG_DIR/backup_errors_${SANA}.log"

# Barcha natija va xatolarni yozish
{
    echo "=== BACKUP BOSHLANDI ==="
    echo "Sana: $(date)"
    echo ""
    
    for katalog in /home /etc /var/www; do
        echo "Backup: $katalog"
        
        arxiv_nomi="$BACKUP_DIR/$(basename $katalog)_${SANA}.tar.gz"
        
        if tar -czf "$arxiv_nomi" "$katalog" 2>&1; then
            echo "✓ Muvaffaqiyatli: $arxiv_nomi"
            ls -lh "$arxiv_nomi"
        else
            echo "✗ Xato: $katalog" >&2
        fi
        
        echo ""
    done
    
    echo "=== BACKUP TUGADI ==="
    echo "Tugash vaqti: $(date)"
    
} > "$STDOUT_LOG" 2> "$STDERR_LOG"

# Email yuborish (agar xato bo'lsa)
if [ -s "$STDERR_LOG" ]; then
    mail -s "Backup xatolari" admin@example.com < "$STDERR_LOG"
fi

# Ekranga chiqarish
cat "$STDOUT_LOG"

if [ -s "$STDERR_LOG" ]; then
    echo ""
    echo "⚠️ XATOLAR:"
    cat "$STDERR_LOG"
fi
```

#### 3. Multi-log writer

```bash
#!/bin/bash

# Bir vaqtda bir nechta log faylga yozish

exec 3> app.log        # Umumiy log
exec 4> error.log      # Xatolar
exec 5> debug.log      # Debug
exec 6> audit.log      # Audit

log_info() {
    echo "[INFO] $(date '+%H:%M:%S') $1" | tee -a /dev/fd/3 /dev/fd/5
}

log_error() {
    echo "[ERROR] $(date '+%H:%M:%S') $1" | tee -a /dev/fd/3 /dev/fd/4 /dev/fd/5
}

log_debug() {
    echo "[DEBUG] $(date '+%H:%M:%S') $1" >&5
}

log_audit() {
    echo "[AUDIT] $(date '+%H:%M:%S') $1" | tee -a /dev/fd/3 /dev/fd/6
}

# Ishlatish
log_info "Dastur boshlandi"
log_debug "Sozlamalar yuklanmoqda"
log_audit "Admin tizimga kirdi"
log_error "Ma'lumotlar bazaga ulanib bo'lmadi"
log_info "Dastur tugadi"

# Yopish
exec 3>&-
exec 4>&-
exec 5>&-
exec 6>&-
```

#### 4. Interactive prompt saver

```bash
#!/bin/bash

# Foydalanuvchi javoblarini saqlash

JAVOBLAR="javoblar.txt"

{
    echo "=== ANKETA ==="
    echo "Sana: $(date)"
    echo ""
    
    read -p "Ismingiz: " ism
    echo "Ism: $ism"
    
    read -p "Yoshingiz: " yosh
    echo "Yosh: $yosh"
    
    read -p "Shahringiz: " shahar
    echo "Shahar: $shahar"
    
    read -p "Email: " email
    echo "Email: $email"
    
    echo ""
    echo "=== SO'ROVNOMA TUGADI ==="
    
} | tee "$JAVOBLAR"

echo ""
echo "Javoblaringiz saqlandi: $JAVOBLAR"
```

#### 5. Command recorder

```bash
#!/bin/bash

# Buyruqlar tarixini batafsil yozish

RECORD_LOG="buyruqlar_tarix.log"

exec > >(tee -a "$RECORD_LOG")
exec 2>&1

echo "=== SESSIYA BOSHLANDI ==="
echo "Sana: $(date)"
echo "User: $USER"
echo "PWD: $PWD"
echo ""

# Har bir buyruqdan keyin log
trap 'echo "[$(date +%H:%M:%S)] Buyruq bajarildi: exit code $?"' DEBUG

# Sessiya tugashida
trap 'echo ""; echo "=== SESSIYA TUGADI ==="; echo "Sana: $(date)"' EXIT

# Interaktiv shell
bash
```

### /dev/null - "Qora tuynuk"

`/dev/null` - hamma narsani yutib yuboradigan maxsus fayl.

```bash
# Natijani yo'qotish
command > /dev/null

# Xatolarni yo'qotish
command 2> /dev/null

# Hammasi ni yo'qotish
command > /dev/null 2>&1
# yoki
command &> /dev/null

# Jim-jit bajarish
find / -name "test.txt" 2> /dev/null
```

**Hayotiy misol:**
```bash
# Faylni tekshirish (xatosiz)
if ls fayl.txt &> /dev/null; then
    echo "Fayl mavjud"
else
    echo "Fayl yo'q"
fi
```

### /dev/zero va /dev/random

```bash
# Katta bo'sh fayl yaratish
dd if=/dev/zero of=bigfile.img bs=1M count=100

# Tasodifiy ma'lumot
dd if=/dev/random of=random.dat bs=1M count=10

# Tasodifiy parol
tr -dc 'A-Za-z0-9!@#$%' < /dev/urandom | head -c 16
```

### Named Pipes (FIFO)

```bash
# FIFO yaratish
mkfifo mypipe

# Terminal 1: O'qish
cat < mypipe

# Terminal 2: Yozish
echo "Salom pipe orqali!" > mypipe
```

**Hayotiy misol: Progress monitoring**
```bash
#!/bin/bash

PIPE="/tmp/progress_pipe"
mkfifo "$PIPE"

# Background monitor
{
    while read progress; do
        echo -ne "\rProgress: $progress%"
    done < "$PIPE"
} &

MONITOR_PID=$!

# Asosiy ish
for i in {1..100}; do
    echo $i > "$PIPE"
    sleep 0.1
done

# Tozalash
kill $MONITOR_PID
rm "$PIPE"
echo ""
echo "✓ Tugadi!"
```

### 📝 Vazifalar:

1. **Vazifa 1:** Buyruq natijasini faylga, xatolarni alohida faylga yozuvchi skript
2. **Vazifa 2:** Here document yordamida HTML sahifa yaratuvchi dastur
3. **Vazifa 3:** `tee` dan foydalanib, real-time log ko'rsatuvchi va saqlovchi skript
4. **Vazifa 4:** Bir nechta file descriptor bilan ishlash: INFO, WARNING, ERROR loglar
5. **Vazifa 5:** stdin dan ma'lumot olib, qayta ishlab, stdout va faylga chiqaruvchi filtr

---