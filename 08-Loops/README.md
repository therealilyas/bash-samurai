## 8️⃣ TAKRORLASH SIKLLARI (for, while, until, select)
**Global nomi:** Loops (for, while, until, select)  
**O'zbek nomi:** Takrorlash sikllari

### Sikl nima?

Sikl - bu bir xil amalni qayta-qayta bajarish mexanizmi. Masalan, 100 ta faylni qayta nomlash yoki 1 dan 50 gacha raqamlarni chop etish.

**Hayotiy misol:** Zinadan chiqish - har bir pog'onada bir xil harakat takrorlanadi (oyoq ko'tarish, qo'yish), faqat raqam o'zgaradi.

### for - Ma'lum sondagi takrorlash

`for` - ro'yxatdagi har bir element uchun amallarni bajaradi.

#### Sintaksis 1: Ro'yxat bilan

```bash
for o'zgaruvchi in ro'yxat; do
    # amallar
done
```

**Oddiy misol:**
```bash
#!/bin/bash

for son in 1 2 3 4 5; do
    echo "Son: $son"
done

# Natija:
# Son: 1
# Son: 2
# Son: 3
# Son: 4
# Son: 5
```

**Ismlar bilan:**
```bash
#!/bin/bash

for ism in Ali Vali Sardor Olim; do
    echo "Salom, $ism!"
done

# Natija:
# Salom, Ali!
# Salom, Vali!
# Salom, Sardor!
# Salom, Olim!
```

#### Sintaksis 2: Diapazon bilan (brace expansion)

```bash
# 1 dan 10 gacha
for i in {1..10}; do
    echo $i
done

# 0 dan 100 gacha, 10 tadan
for i in {0..100..10}; do
    echo $i
done

# Harflar
for harf in {a..z}; do
    echo $harf
done
```

**Hayotiy misol: Papkalar yaratish**
```bash
#!/bin/bash

# 2024 yil oylarini yaratish
for oy in {01..12}; do
    mkdir -p "2024-$oy"
    echo "✓ 2024-$oy yaratildi"
done
```

#### Sintaksis 3: C-style for

```bash
for ((i=0; i<10; i++)); do
    echo "Hisob: $i"
done
```

**Tushuntirish:**
- `i=0` - boshlang'ich qiymat
- `i<10` - shart (10 gacha)
- `i++` - har safar 1 ga oshir

**Misol: Ulushlar jadvali**
```bash
#!/bin/bash

read -p "Sonni kiriting: " son

echo "=== $son ning ko'paytma jadvali ==="
for ((i=1; i<=10; i++)); do
    natija=$((son * i))
    echo "$son × $i = $natija"
done
```

#### Fayllar ustida ishlash

```bash
# Hozirgi katalogdagi barcha .txt fayllar
for fayl in *.txt; do
    echo "Fayl: $fayl"
done

# Barcha .jpg rasmlarni qayta nomlash
hisoblagich=1
for rasm in *.jpg; do
    yangi_nom="photo_$(printf "%03d" $hisoblagich).jpg"
    mv "$rasm" "$yangi_nom"
    echo "$rasm → $yangi_nom"
    ((hisoblagich++))
done
```

**Hayotiy misol: Backup yaratish**
```bash
#!/bin/bash

BACKUP_DIR="/backup"
SANA=$(date +%Y-%m-%d)

mkdir -p "$BACKUP_DIR/$SANA"

for fayl in *.txt *.pdf *.doc; do
    if [ -f "$fayl" ]; then
        cp "$fayl" "$BACKUP_DIR/$SANA/"
        echo "✓ $fayl nusxalandi"
    fi
done

echo "Backup tugadi: $BACKUP_DIR/$SANA"
```

### while - Shart to'g'ri ekan takrorla

`while` - shart `true` bo'lguncha davom etadi.

#### Sintaksis:

```bash
while [ shart ]; do
    # amallar
done
```

**Oddiy misol:**
```bash
#!/bin/bash

i=1

while [ $i -le 5 ]; do
    echo "Hisob: $i"
    ((i++))
done

# Natija:
# Hisob: 1
# Hisob: 2
# Hisob: 3
# Hisob: 4
# Hisob: 5
```

**Fayldan o'qish:**
```bash
#!/bin/bash

# Faylning har bir qatorini o'qish
while read qator; do
    echo "Qator: $qator"
done < fayl.txt
```

**Hayotiy misol: Parol so'rash (3 urinish)**
```bash
#!/bin/bash

PAROL="secret123"
urinish=0
max_urinish=3

while [ $urinish -lt $max_urinish ]; do
    read -sp "Parolni kiriting: " kiritilgan
    echo ""
    
    if [ "$kiritilgan" = "$PAROL" ]; then
        echo "✓ Kirish muvaffaqiyatli!"
        exit 0
    else
        ((urinish++))
        qolgan=$((max_urinish - urinish))
        if [ $qolgan -gt 0 ]; then
            echo "✗ Noto'g'ri! $qolgan ta urinish qoldi"
        fi
    fi
done

echo "✗ Kirish bloklandi!"
exit 1
```

**Cheksiz sikl:**
```bash
#!/bin/bash

while true; do
    echo "Bu cheksiz sikl. Ctrl+C bosing to'xtatish uchun"
    sleep 1
done
```

### until - Shart noto'g'ri ekan takrorla

`until` - `while` ning teskarisi. Shart `false` bo'lguncha ishlaydi.

#### Sintaksis:

```bash
until [ shart ]; do
    # amallar
done
```

**Misol:**
```bash
#!/bin/bash

i=1

until [ $i -gt 5 ]; do
    echo "Hisob: $i"
    ((i++))
done
```

**Hayotiy misol: Fayl kutish**
```bash
#!/bin/bash

FAYL="data.txt"

echo "⏳ $FAYL kutilmoqda..."

until [ -f "$FAYL" ]; do
    echo "Hali yo'q... (Ctrl+C - bekor qilish)"
    sleep 2
done

echo "✓ $FAYL topildi!"
```

**Server kutish:**
```bash
#!/bin/bash

HOST="example.com"
PORT=80

echo "⏳ $HOST:$PORT ga ulanish kutilmoqda..."

until nc -z "$HOST" "$PORT" 2>/dev/null; do
    echo "Server hali tayyor emas..."
    sleep 5
done

echo "✓ Server tayyor!"
```

### select - Menyu yaratish

`select` - foydalanuvchiga tanlov menyusini ko'rsatadi.

#### Sintaksis:

```bash
select o'zgaruvchi in variant1 variant2 variant3; do
    # tanlovga qarab amallar
    break  # Sikldan chiqish
done
```

**Oddiy misol:**
```bash
#!/bin/bash

echo "Sevimli mevasini tanlang:"

select meva in Olma Nok Uzum "O'rik" Chiqish; do
    case $meva in
        Olma|Nok|Uzum|"O'rik")
            echo "✓ Siz ${meva}ni tanladingiz"
            break
            ;;
        Chiqish)
            echo "Xayr!"
            break
            ;;
        *)
            echo "✗ Noto'g'ri tanlov!"
            ;;
    esac
done
```

**Natija:**
```
Sevimli mevasini tanlang:
1) Olma
2) Nok
3) Uzum
4) O'rik
5) Chiqish
#? 3
✓ Siz Uzmni tanladingiz
```

**Hayotiy misol: Fayl boshqaruv**
```bash
#!/bin/bash

PS3="Tanlovingiz: "  # Prompt matni

select amal in "Fayl yaratish" "Fayl o'chirish" "Fayllarni ko'rish" "Chiqish"; do
    case $REPLY in
        1)
            read -p "Fayl nomi: " nom
            touch "$nom"
            echo "✓ $nom yaratildi"
            ;;
        2)
            read -p "O'chiriladi fayl: " nom
            rm -i "$nom"
            ;;
        3)
            echo "Fayllar:"
            ls -lh
            ;;
        4)
            echo "Xayr!"
            break
            ;;
        *)
            echo "✗ Noto'g'ri tanlov!"
            ;;
    esac
    echo ""  # Bo'sh qator
done
```

### Sikllarni boshqarish

#### break - Sikldan chiqish

```bash
#!/bin/bash

for i in {1..10}; do
    if [ $i -eq 5 ]; then
        echo "5 ga yetdik, to'xtaymiz!"
        break
    fi
    echo "Son: $i"
done

# Natija:
# Son: 1
# Son: 2
# Son: 3
# Son: 4
# 5 ga yetdik, to'xtaymiz!
```

**Ichma-ich siklda:**
```bash
#!/bin/bash

for i in {1..3}; do
    for j in {1..3}; do
        if [ $j -eq 2 ]; then
            break  # Faqat ichki sikldan chiqadi
        fi
        echo "$i-$j"
    done
done
```

#### continue - Keyingi iteratsiyaga o'tish

```bash
#!/bin/bash

for i in {1..5}; do
    if [ $i -eq 3 ]; then
        continue  # 3 ni o'tkazib yuborish
    fi
    echo "Son: $i"
done

# Natija:
# Son: 1
# Son: 2
# Son: 4
# Son: 5
```

**Hayotiy misol: Faqat .txt fayllarni qayta ishlash**
```bash
#!/bin/bash

for fayl in *; do
    # Agar .txt bo'lmasa, o'tkazib yuborish
    if [[ ! $fayl ==

    *.txt ]]; then
        continue
    fi
    
    # Faqat .txt fayllar uchun
    echo "Qayta ishlanmoqda: $fayl"
    # Bu yerda faylni qayta ishlash kodi
done
```
### Amaliy loyihalar

#### Loyiha 1: Progress bar

```bash
#!/bin/bash

echo "Yuklanmoqda..."

for i in {1..100}; do
    # Progress bar chizish
    printf "\r["
    
    # To'ldirilgan qism
    for ((j=0; j<i/2; j++)); do
        printf "="
    done
    
    # Bo'sh qism
    for ((j=i/2; j<50; j++)); do
        printf " "
    done
    
    printf "] %d%%" $i
    sleep 0.05
done

echo ""
echo "✓ Tayyor!"
```

#### Loyiha 2: Fayl statistikasi

```bash
#!/bin/bash

echo "=== FAYL STATISTIKASI ==="

jami_fayllar=0
jami_kataloglar=0
jami_hajm=0

for element in *; do
    if [ -f "$element" ]; then
        ((jami_fayllar++))
        hajm=$(stat -f%z "$element" 2>/dev/null || stat -c%s "$element" 2>/dev/null)
        ((jami_hajm += hajm))
    elif [ -d "$element" ]; then
        ((jami_kataloglar++))
    fi
done

echo "Fayllar: $jami_fayllar"
echo "Kataloglar: $jami_kataloglar"
echo "Umumiy hajm: $(echo "scale=2; $jami_hajm/1024/1024" | bc) MB"
```

#### Loyiha 3: Backup tizimi

```bash
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
```

#### Loyiha 4: Tizim monitoring (davomiy)

```bash
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
```

#### Loyiha 5: Rasmlarni optimizatsiya qilish

```bash
#!/bin/bash
#sudo apt update
#sudo apt install imagemagick -y

echo "=== RASMLARNI OPTIMIZATSIYA ===="

if ! command -v convert &> /dev/null; then
    echo "✗ ImageMagick o'rnatilmagan!"
    echo "O'rnatish: sudo apt install imagemagick"
    exit 1
fi

read -p "Sifat (1-100, tavsiya 85): " sifat
sifat=${sifat:-85}

mkdir -p optimized

jami=0
muvaffaqiyatli=0

for rasm in *.jpg *.png *.jpeg; do
    if [ -f "$rasm" ]; then
        ((jami++))
        
        echo -n "[$jami] $rasm ... "
        
        asl_hajm=$(stat -f%z "$rasm" 2>/dev/null || stat -c%s "$rasm")
        
        if convert "$rasm" -quality $sifat "optimized/$rasm"; then
            yangi_hajm=$(stat -f%z "optimized/$rasm" 2>/dev/null || stat -c%s "optimized/$rasm")
            
            # Hajm farqi
            farq=$((asl_hajm - yangi_hajm))
            foiz=$((farq * 100 / asl_hajm))
            
            if [ $farq -gt 0 ]; then
                echo "✓ -${foiz}% ($(echo "scale=1; $farq/1024" | bc)KB)"
                ((muvaffaqiyatli++))
            else
                echo "○ O'zgarmadi"
            fi
        else
            echo "✗ Xato!"
        fi
    fi
done

if [ $jami -eq 0 ]; then
    echo "Rasmlar topilmadi!"
else
    echo ""
    echo "=== NATIJA ==="
    echo "Jami: $jami"
    echo "Optimizatsiya qilindi: $muvaffaqiyatli"
fi
```

#### Loyiha 6: Interaktiv kalkulator

```bash
#!/bin/bash

echo "=== KALKULATOR ==="
echo "Buyruqlar: +, -, *, /, ^, %, clear, exit"
echo ""

natija=0

while true; do
    echo "Hozirgi natija: $natija"
    echo ""
    
    # Amal tanlash
    PS3="Amal tanlang: "
    select amal in "Qo'shish (+)" "Ayirish (-)" "Ko'paytirish (*)" "Bo'lish (/)" "Daraja (^)" "Qoldiq (%)" "Tozalash" "Chiqish"; do
        case $REPLY in
            1) oper="+"; break ;;
            2) oper="-"; break ;;
            3) oper="*"; break ;;
            4) oper="/"; break ;;
            5) oper="^"; break ;;
            6) oper="%"; break ;;
            7)
                natija=0
                echo "✓ Tozalandi"
                break 2  # Tashqi siklga qaytish
                ;;
            8)
                echo "Xayr!"
                exit 0
                ;;
            *)
                echo "✗ Noto'g'ri tanlov!"
                continue
                ;;
        esac
    done
    
    read -p "Son kiriting: " son
    
    case $oper in
        "+")
            natija=$((natija + son))
            ;;
        "-")
            natija=$((natija - son))
            ;;
        "*")
            natija=$((natija * son))
            ;;
        "/")
            if [ $son -eq 0 ]; then
                echo "✗ 0 ga bo'lib bo'lmaydi!"
                continue
            fi
            natija=$(echo "scale=2; $natija / $son" | bc)
            ;;
        "^")
            natija=$((natija ** son))
            ;;
        "%")
            natija=$((natija % son))
            ;;
    esac
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━"
done
```

### Nested loops (Ichma-ich sikllar)

```bash
#!/bin/bash

echo "Ko'paytma jadvali:"
echo ""

for i in {1..10}; do
    for j in {1..10}; do
        natija=$((i * j))
        printf "%4d" $natija
    done
    echo ""
done
```

**Yulduzcha uchburchak:**
```bash
#!/bin/bash

read -p "Qatorlar soni: " n

for ((i=1; i<=n; i++)); do
    for ((j=1; j<=i; j++)); do
        echo -n "* "
    done
    echo ""
done

# Natija (n=5):
# * 
# * * 
# * * * 
# * * * * 
# * * * * *
```

### 📝 Vazifalar:

1. **Vazifa 1:** 1 dan 100 gacha bo'lgan sonlarning yig'indisini hisoblovchi for sikli yozing
2. **Vazifa 2:** Foydalanuvchidan raqam so'rab, uning faktorialini (5! = 5×4×3×2×1) hisoblovchi while sikli
3. **Vazifa 3:** Katalogdagi barcha .txt fayllarni sanab, har birining qator sonini chiqaruvchi skript
4. **Vazifa 4:** 1 dan 50 gacha bo'lgan juft sonlarni ekranga chiqaruvchi dastur (continue dan foydalaning)
5. **Vazifa 5:** Select bilan dastur yozing: Foydalanuvchi operatsiya tanlaydi va 2 ta son kiritadi, natija chiqadi