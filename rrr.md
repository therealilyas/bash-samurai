## 🔟 TO'LDIRISH, TIZIMLI BUYRUQLAR VA SUBSHELL
**Global nomi:** Globbing, Command Expansion & Subshells  
**O'zbek nomi:** To'ldirish, tizimli buyruqlar va subshell

### Globbing (Wildcard) - Fayl nomi shablonlari

Globbing - bu fayllarni nomi bo'yicha qidirish uchun maxsus belgilar.

**Hayotiy misol:** Do'konda "Barcha qizil olma" deb so'rasangiz - bu globbing. Aniq nom emas, shart.

#### Asosiy wildcard belgilar:

**1. `*` - Istalgan belgilar (0 yoki ko'p)**

```bash
# Barcha fayllar
ls *

# .txt bilan tugaydigan fayllar
ls *.txt

# test bilan boshlanadigan fayllar
ls test*

# Ichida "log" bo'lgan fayllar
ls *log*

# Katalogdagi barcha .jpg fayllar
ls images/*.jpg
```

**Misollar:**
```bash
# Barcha Python fayllar
for fayl in *.py; do
    echo "Python fayl: $fayl"
done

# Barcha backup fayllarni o'chirish
rm *backup*

# 2024 bilan boshlanadigan papkalar
ls -d 2024*/
```

**2. `?` - Bitta belgi**

```bash
# Aniq 4 ta belgili fayllar
ls ????.txt

# test1.txt, test2.txt, testA.txt (test + 1 belgi + .txt)
ls test?.txt

# file1.log, file2.log, ... file9.log
ls file?.log
```

**3. `[ ]` - Belgilar to'plami**

```bash
# a, b yoki c bilan boshlanadigan
ls [abc]*.txt

# 1, 2 yoki 3 bilan boshlanadigan
ls [123]*.log

# Diapazon: a dan z gacha
ls [a-z]*.txt

# Raqamlar: 0 dan 9 gacha
ls file[0-9].txt

# Katta harflar
ls [A-Z]*.pdf

# Inkor: a, b, c DAN BOSHQA
ls [!abc]*.txt
# yoki
ls [^abc]*.txt
```

**Misollar:**
```bash
# Faqat katta harf bilan boshlanadigan
ls [A-Z]*

# Raqam bilan tugaydigan fayllar
ls *[0-9].txt

# Barcha soz va undosh harflar
ls *[aeiouAEIOU]*
```

**4. `{ }` - Brace expansion (takrorlash)**

```bash
# Bir nechta variantlar
echo {red,green,blue}
# Natija: red green blue

# Papkalar yaratish
mkdir {2021,2022,2023,2024}

# Diapazon
echo {1..10}
# Natija: 1 2 3 4 5 6 7 8 9 10

echo {a..z}
# Natija: a b c d e f ... x y z

# Qadam bilan
echo {0..100..10}
# Natija: 0 10 20 30 40 50 60 70 80 90 100

# Ichma-ich
echo {A,B}{1,2}
# Natija: A1 A2 B1 B2
```

**Hayotiy misollar:**
```bash
# Yil bo'yicha papkalar
mkdir 2024-{01..12}
# 2024-01, 2024-02, ..., 2024-12

# Backup nusxalari
cp fayl.txt{,.backup}
# cp fayl.txt fayl.txt.backup

# Fayllarni nusxalash
cp important.doc{,.$(date +%F)}
# important.doc.2025-10-23

# Ko'p kengaytmali qidirish
ls *.{jpg,png,gif}
# Barcha rasm fayllar
```

**5. `**` - Rekursiv qidiruv (Bash 4+)**

```bash
# Globstar yoqish
shopt -s globstar

# Barcha kataloglardagi .txt fayllar
ls **/*.txt

# Ichma-ich barcha Python fayllar
ls **/*.py
```

### Command Substitution - Buyruq natijasini olish

Buyruq natijasini o'zgaruvchiga saqlash:

#### Usul 1: `$( )` (tavsiya etiladi)

```bash
# Bugungi sana
bugun=$(date +%Y-%m-%d)
echo "Bugun: $bugun"

# Fayllar soni
soni=$(ls | wc -l)
echo "Fayllar: $soni ta"

# Disk hajmi
disk=$(df -h / | awk 'NR==2 {print $5}')
echo "Disk: $disk to'lgan"

# Hozirgi foydalanuvchi
user=$(whoami)
echo "Salom, $user!"
```

#### Usul 2: `` ` ` `` - Backtick (eski usul)

```bash
# Eski usul
bugun=`date +%Y-%m-%d`

# Yangi usul afzal ($( ) ko'rinishi aniqroq)
bugun=$(date +%Y-%m-%d)
```

**Ichma-ich substitution:**
```bash
# Katalog hajmini topish
katalog="/home/sardor"
hajm=$(du -sh $(find "$katalog" -type f) | awk '{sum+=$1} END {print sum}')

# Eng katta faylni topish
eng_katta=$(ls -lS | head -2 | tail -1 | awk '{print $9}')
echo "Eng katta fayl: $eng_katta"
```

**Hayotiy misollar:**
```bash
# Backup fayl nomi
backup_fayl="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$backup_fayl" mening_papka/

# Log fayli yaratish
log="log_$(hostname)_$(date +%F).log"
echo "Dastur boshlandi" > "$log"

# Eski fayllarni arxivlash
arxiv="arxiv_$(date +%Y-%m).tar.gz"
find . -mtime +30 -type f -print0 | tar -czf "$arxiv" --null -T -
```

### Process Substitution - Jarayon natijasini fayl sifatida

`<( )` - buyruq natijasini vaqtinchalik fayl sifatida ishlatish:

```bash
# Ikki katalogni solishtirish
diff <(ls dir1) <(ls dir2)

# Saralangan ro'yxatlarni birlashtirish
comm <(sort fayl1.txt) <(sort fayl2.txt)

# Fayllar hajmini taqqoslash
paste <(ls -1) <(ls -lh | awk '{print $5}')
```

**Hayotiy misol: Log tahlil**
```bash
# Eng ko'p uchraydigan IP manzillar
diff <(cat access.log | awk '{print $1}' | sort | uniq -c | sort -rn | head -10) \
     <(cat access.log.1 | awk '{print $1}' | sort | uniq -c | sort -rn | head -10)
```

### Subshell - Alohida shell muhiti

`( )` - Buyruqlarni alohida shell muhitida ishlatish:

```bash
# Hozirgi katalog
echo "Avval: $(pwd)"

# Subshell da - hozirgi katalogni o'zgartirish
(
    cd /tmp
    echo "Subshell ichida: $(pwd)"
    touch test.txt
)

# Tashqarida - o'zgarmagan
echo "Keyin: $(pwd)"
```

**Foydasi:**
- Asl muhitni o'zgartirmaydi
- O'zgaruvchilar faqat subshell ichida
- Parallel ishlash uchun

```bash
# Parallel backuplar
(
    echo "Backup 1 boshlandi..."
    tar -czf backup1.tar.gz papka1/
    echo "Backup 1 tugadi"
) &

(
    echo "Backup 2 boshlandi..."
    tar -czf backup2.tar.gz papka2/
    echo "Backup 2 tugadi"
) &

# Barcha subshell larni kutish
wait
echo "Barcha backuplar tayyor!"
```

### Background va Foreground

```bash
# Background da ishlatish (&)
sleep 10 &
echo "Sleep background da, biz davom etamiz"

# Jarayonlarni ko'rish
jobs

# Foreground ga olib chiqish
fg %1

# Background ga yuborish (Ctrl+Z dan keyin)
bg %1

# Jarayonni to'xtatish
kill %1
```

**Hayotiy misol: Ko'p ishni parallel bajarish**
```bash
#!/bin/bash

echo "Ko'p fayllarni qayta ishlash..."

for fayl in *.jpg; do
    (
        echo "Qayta ishlanmoqda: $fayl"
        convert "$fayl" -resize 800x600 "resized_$fayl"
        echo "✓ $fayl tayyor"
    ) &
    
    # 4 tadan ortiq parallel jarayon yo'q
    if (( $(jobs -r | wc -l) >= 4 )); then
        wait -n  # Birortasi tugashini kutish
    fi
done

wait  # Barcha tugashini kutish
echo "Hammasi tayyor!"
```

### Tilde expansion (~)

```bash
# Uy katalogi
cd ~
cd ~/Documents
cd ~/Desktop

# Boshqa foydalanuvchi uyi
cd ~username

# Oldingi katalog
cd ~-
# yoki
cd -

# PATH ga qo'shish
export PATH="$PATH:~/bin:~/scripts"
```

### Parameter expansion - O'zgaruvchilarni kengaytirish

```bash
# Oddiy
echo $fayl

# Xavfsiz (bo'sh joy bilan)
echo "${fayl}"

# Default qiymat
echo "${port:-8080}"  # Agar port bo'sh bo'lsa 8080

# Bo'sh bo'lsa berish va saqlash
port=${port:=8080}

# Bo'sh bo'lsa xato
fayl=${fayl:?"Fayl kiritilmadi!"}

# Bo'sh bo'lmasa, boshqa qiymat
echo "${port:+Server ishlamoqda}"
```

**Matn bilan ishlash:**
```bash
fayl="document.backup.txt"

# Uzunlik
echo ${#fayl}                    # 20

# Kesish
echo ${fayl:0:8}                 # document

# Oldidan o'chirish
echo ${fayl#*.}                  # backup.txt (qisqa)
echo ${fayl##*.}                 # txt (uzun)

# Orqadan o'chirish
echo ${fayl%.*}                  # document.backup (qisqa)
echo ${fayl%%.*}                 # document (uzun)

# Almashtirish
echo ${fayl/backup/final}        # document.final.txt
echo ${fayl//./–}                # document-backup-txt

# Katta-kichik
echo ${fayl^^}                   # DOCUMENT.BACKUP.TXT
echo ${fayl,,}                   # document.backup.txt
```

### Amaliy loyiha: Fayl organizatori

```bash
#!/bin/bash

shopt -s nullglob  # Bo'sh glob dan xato bermaslik

echo "=== FAYL ORGANIZATORI ==="
echo "Katalog: $(pwd)"
echo ""

# Hisoblagichlar
jami=0
suratrlar=0
hujjatlar=0
videoar=0
musiqa=0
arxivlar=0
boshqalar=0

# Papkalar yaratish
mkdir -p Sorted/{Images,Documents,Videos,Music,Archives,Others}

# Rasmlar
for fayl in *.{jpg,jpeg,png,gif,bmp,svg}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Images/
    echo "📷 $fayl → Images/"
    ((suratlar++))
    ((jami++))
done

# Hujjatlar
for fayl in *.{txt,doc,docx,pdf,odt,xls,xlsx,ppt,pptx}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Documents/
    echo "📄 $fayl → Documents/"
    ((hujjatlar++))
    ((jami++))
done

# Videolar
for fayl in *.{mp4,avi,mkv,mov,wmv,flv}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Videos/
    echo "🎬 $fayl → Videos/"
    ((videoar++))
    ((jami++))
done

# Musiqa
for fayl in *.{mp3,wav,flac,aac,ogg}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Music/
    echo "🎵 $fayl → Music/"
    ((musiqa++))
    ((jami++))
done

# Arxivlar
for fayl in *.{zip,tar,gz,bz2,7z,rar}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Archives/
    echo "📦 $fayl → Archives/"
    ((arxivlar++))
    ((jami++))
done

# Boshqalar
for fayl in *; do
    [ -f "$fayl" ] || continue
    [ "$fayl" != "$(basename $0)" ] || continue  # Skriptni o'chirmaslik
    mv "$fayl" Sorted/Others/
    echo "📎 $fayl → Others/"
    ((boshqalar++))
    ((jami++))
done

# Natija
echo ""
echo "=== NATIJA ==="
echo "Jami ko'chirildi: $jami"
echo "  Suratlar: $suratlar"
echo "  Hujjatlar: $hujjatlar"
echo "  Videolar: $videoar"
echo "  Musiqa: $musiqa"
echo "  Arxivlar: $arxivlar"
echo "  Boshqalar: $boshqalar"

# Bo'sh papkalarni o'chirish
find Sorted -type d -empty -delete
```

### Amaliy loyiha: Smart backup

```bash
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
```

### 📝 Vazifalar:

1. **Vazifa 1:** Wildcard yordamida katalogdagi barcha .log fayllarni topib, o'chiruvchi skript yozing
2. **Vazifa 2:** Brace expansion bilan 12 oylik papkalar yarating (2024-01, 2024-02, ...)
3. **Vazifa 3:** Command substitution yordamida tizim ma'lumotlarini (CPU, RAM, Disk) yig'uvchi skript
4. **Vazifa 4:** Subshell da 5 ta faylni parallel ravishda nusxalovchi dastur yozing
5. **Vazifa 5:** Globbing pattern yordamida fayllarni turlariga ko'ra (tur-rasm/, tur-hujjat/) ajratuvchi organizator

---

Keyingi mavzularni ham shu tarzda davom ettiraymi? Qolgan 11 ta mavzu:
11. Fayl kiritish/chiqarish va redirektsiya
12. Pipe va filtrlar (grep, awk, sed, cut, sort, uniq)
13. Arraylar va associative arraylar
14. Regex va grep/egrep
15. Script yozish va debug usullari
16. Cron, systemd timers
17. Tarmoq buyruqlari
18. Paket boshqaruv
19. Best practices
20. Amaliy loyihalar
21. Cheat sheet