## 9️⃣ FUNKTSIYALAR VA MODULLAR
**Global nomi:** Functions and Modules  
**O'zbek nomi:** Funktsiyalar va modullar

### Funktsiya nima?

Funktsiya - bu qayta-qayta ishlatiladigan kod bo'lagi. Bir marta yozasiz, keyin istalgan joyda chaqirasiz.

**Hayotiy misol:** Oshxonadagi retsept - bir marta yoziladi, keyin har safar ovqat tayyorlashda ishlatiladi. Har safar qaytadan yozish shart emas.

### Funktsiya e'lon qilish

#### Usul 1: Oddiy sintaksis
```bash
funktsiya_nomi() {
    # kod
}
```

#### Usul 2: function kalit so'zi bilan
```bash
function funktsiya_nomi {
    # kod
}
```

#### Usul 3: Ikkalasi birgalikda
```bash
function funktsiya_nomi() {
    # kod
}
```

**Oddiy misol:**
```bash
#!/bin/bash

# Funktsiya e'lon qilish
salomlash() {
    echo "Assalomu alaykum!"
}

# Funktsiyani chaqirish
salomlash
salomlash
salomlash

# Natija:
# Assalomu alaykum!
# Assalomu alaykum!
# Assalomu alaykum!
```

### Parametrlar (Arguments)

Funktsiyalarga ma'lumot yuborish mumkin:

```bash
#!/bin/bash

salom_ayt() {
    echo "Salom, $1!"
}

salom_ayt "Sardor"    # Salom, Sardor!
salom_ayt "Olim"      # Salom, Olim!
```

**Ko'p parametrlar:**
```bash
#!/bin/bash

toliq_ism() {
    echo "To'liq ism: $1 $2"
}

toliq_ism "Sardor" "Aliyev"
# To'liq ism: Sardor Aliyev
```

**Maxsus o'zgaruvchilar funktsiyada:**
- `$1, $2, $3...` - parametrlar
- `$#` - parametrlar soni
- `$@` - barcha parametrlar
- `$*` - barcha parametrlar (bitta satr)
- `$0` - skript nomi (funktsiya nomi emas!)

```bash
#!/bin/bash

malumot() {
    echo "Funktsiya nomi: ${FUNCNAME[0]}"
    echo "Parametrlar soni: $#"
    echo "Birinchi: $1"
    echo "Ikkinchi: $2"
    echo "Barcha: $@"
}

malumot "Sardor" "25" "Toshkent"

# Natija:
# Funktsiya nomi: malumot
# Parametrlar soni: 3
# Birinchi: Sardor
# Ikkinchi: 25
# Barcha: Sardor 25 Toshkent
```

### Return qiymati

Bash funktsiyalari faqat exit kod qaytaradi (0-255):

```bash
#!/bin/bash

tekshir() {
    if [ $1 -gt 10 ]; then
        return 0  # Muvaffaqiyat
    else
        return 1  # Xato
    fi
}

tekshir 15
if [ $? -eq 0 ]; then
    echo "10 dan katta"
else
    echo "10 dan kichik yoki teng"
fi
```

**Qiymat qaytarish (echo orqali):**
```bash
#!/bin/bash

qoshish() {
    natija=$(($1 + $2))
    echo $natija
}

yigindi=$(qoshish 10 20)
echo "Yig'indi: $yigindi"    # Yig'indi: 30
```

**Hayotiy misol: Hisob-kitob funktsiyalari**
```bash
#!/bin/bash

qoshish() {
    echo $(($1 + $2))
}

ayirish() {
    echo $(($1 - $2))
}

kopaytirish() {
    echo $(($1 * $2))
}

bolish() {
    if [ $2 -eq 0 ]; then
        echo "Xato: 0 ga bo'lib bo'lmaydi"
        return 1
    fi
    echo "scale=2; $1 / $2" | bc
}

# Ishlatish
echo "10 + 5 = $(qoshish 10 5)"
echo "10 - 5 = $(ayirish 10 5)"
echo "10 × 5 = $(kopaytirish 10 5)"
echo "10 ÷ 5 = $(bolish 10 5)"
```

### Lokal o'zgaruvchilar

```bash
#!/bin/bash

GLOBAL="Bu global"

funktsiya() {
    local LOKAL="Bu lokal"
    echo "Funktsiya ichida:"
    echo "  Global: $GLOBAL"
    echo "  Lokal: $LOKAL"
}

funktsiya

echo "Funktsiyadan tashqarida:"
echo "  Global: $GLOBAL"
echo "  Lokal: $LOKAL"    # Bo'sh

# Natija:
# Funktsiya ichida:
#   Global: Bu global
#   Lokal: Bu lokal
# Funktsiyadan tashqarida:
#   Global: Bu global
#   Lokal:
```

**Yaxshi amaliyot:** Funktsiya ichidagi o'zgaruvchilarni `local` bilan e'lon qiling!

```bash
#!/bin/bash

hisobla() {
    local son1=$1
    local son2=$2
    local natija=$((son1 + son2))
    echo $natija
}

javob=$(hisobla 5 10)
echo "Natija: $javob"
# son1, son2, natija tashqarida mavjud emas
```

### Rekursiv funktsiyalar

Funktsiya o'zini o'zi chaqirishi mumkin:

```bash
#!/bin/bash

# Faktorial: 5! = 5 × 4 × 3 × 2 × 1
faktorial() {
    local n=$1
    
    if [ $n -le 1 ]; then
        echo 1
    else
        local oldingi=$(faktorial $((n - 1)))
        echo $((n * oldingi))
    fi
}

echo "5! = $(faktorial 5)"    # 5! = 120
```

**Fibonacci qatori:**
```bash
#!/bin/bash

fibonacci() {
    local n=$1
    
    if [ $n -le 1 ]; then
        echo $n
    else
        local a=$(fibonacci $((n - 1)))
        local b=$(fibonacci $((n - 2)))
        echo $((a + b))
    fi
}

# Birinchi 10 ta Fibonacci soni
for i in {0..9}; do
    echo -n "$(fibonacci $i) "
done
echo ""
# 0 1 1 2 3 5 8 13 21 34
```

### Amaliy funktsiyalar

#### 1. Matn ranglari

```bash
#!/bin/bash

# Rang funktsiyalari
qizil() {
    echo -e "\033[31m$1\033[0m"
}

yashil() {
    echo -e "\033[32m$1\033[0m"
}

sari() {
    echo -e "\033[33m$1\033[0m"
}

ko'k() {
    echo -e "\033[34m$1\033[0m"
}

# Ishlatish
qizil "Bu qizil matn"
yashil "Bu yashil matn"
sari "Bu sariq matn"
ko'k "Bu ko'k matn"
```

#### 2. Xato xabarlari

```bash
#!/bin/bash

xato() {
    echo -e "\033[31m✗ XATO: $1\033[0m" >&2
    exit 1
}

ogohlantirish() {
    echo -e "\033[33m⚠ OGOHLANTIRISH: $1\033[0m" >&2
}

muvaffaqiyat() {
    echo -e "\033[32m✓ $1\033[0m"
}

malumot() {
    echo -e "\033[34mℹ $1\033[0m"
}

# Ishlatish
malumot "Dastur boshlandi"
ogohlantirish "Bu test rejimi"
muvaffaqiyat "Fayl yaratildi"
xato "Fayl topilmadi"
```

#### 3. Fayl mavjudligini tekshirish

```bash
#!/bin/bash

fayl_tekshir() {
    local fayl=$1
    
    if [ ! -f "$fayl" ]; then
        echo "✗ Xato: $fayl topilmadi!"
        return 1
    fi
    
    if [ ! -r "$fayl" ]; then
        echo "✗ Xato: $fayl o'qib bo'lmaydi!"
        return 1
    fi
    
    echo "✓ $fayl mavjud va o'qiladi"
    return 0
}

# Ishlatish
fayl_tekshir "test.txt" || exit 1
```

#### 4. Progress bar

```bash
#!/bin/bash

progress_bar() {
    local hozirgi=$1
    local jami=$2
    local kenglik=50
    
    local foiz=$((hozirgi * 100 / jami))
    local to'ldirilgan=$((hozirgi * kenglik / jami))
    
    printf "\r["
    printf "%${to'ldirilgan}s" | tr ' ' '='
    printf "%$((kenglik - to'ldirilgan))s" | tr ' ' ' '
    printf "] %3d%%" $foiz
}

# Ishlatish
jami=100
for i in $(seq 1 $jami); do
    progress_bar $i $jami
    sleep 0.05
done
echo ""
```

### Source - boshqa fayldan yuklash

Funktsiyalarni alohida faylga yozib, keyin istalgan joyda yuklash mumkin:

**library.sh:**
```bash
# Foydali funktsiyalar kutubxonasi

qizil() {
    echo -e "\033[31m$1\033[0m"
}

yashil() {
    echo -e "\033[32m$1\033[0m"
}

xato() {
    qizil "✗ XATO: $1" >&2
    exit 1
}

muvaffaqiyat() {
    yashil "✓ $1"
}
```

**main.sh:**
```bash
#!/bin/bash

# Kutubxonani yuklash
source library.sh
# yoki
. library.sh

# Endi funktsiyalar ishlatiladi
muvaffaqiyat "Dastur boshlandi"
xato "Nimadir noto'g'ri"
```

### Modul tizimi yaratish

**utils/colors.sh:**
```bash
# Rang funktsiyalari moduli

qizil() { echo -e "\033[31m$1\033[0m"; }
yashil() { echo -e "\033[32m$1\033[0m"; }
sari() { echo -e "\033[33m$1\033[0m"; }
ko'k() { echo -e "\033[34m$1\033[0m"; }
```

**utils/validation.sh:**
```bash
# Validatsiya moduli

email_tekshir() {
    local email=$1
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

raqam_tekshir() {
    local qiymat=$1
    if [[ $qiymat =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}
```

**main.sh:**
```bash
#!/bin/bash

# Barcha modullarni yuklash
for modul in utils/*.sh; do
    source "$modul"
done

# Ishlatish
yashil "Modullar yuklandi"

read -p "Email kiriting: " email
if email_tekshir "$email"; then
    muvaffaqiyat "Email to'g'ri"
else
    qizil "Email noto'g'ri"
fi
```

### Amaliy loyiha: Kutubxona boshqaruv tizimi

```bash
#!/bin/bash

# ===============================
# FUNKTSIYALAR
# ===============================

# Bosh menyu
bosh_menyu() {
    clear
    echo "╔═══════════════════════════════╗"
    echo "║   KUTUBXONA BOSHQARUV TIZIMI   ║"
    echo "╚═══════════════════════════════╝"
    echo ""
    echo "1. Kitob qo'shish"
    echo "2. Kitoblarni ko'rish"
    echo "3. Kitob qidirish"
    echo "4. Kitob o'chirish"
    echo "5. Statistika"
    echo "6. Chiqish"
    echo ""
}

# Kitob qo'shish
kitob_qosh() {
    echo ""
    echo "=== YANGI KITOB ==="
    read -p "Nomi: " nom
    read -p "Muallif: " muallif
    read -p "Yili: " yil
    read -p "Sahifalar: " sahifa
    
    echo "$nom|$muallif|$yil|$sahifa" >> kitoblar.db
    
    yashil "✓ Kitob qo'shildi"
    read -p "Davom etish uchun Enter..."
}

# Kitoblarni ko'rish
kitoblar_korish() {
    echo ""
    echo "=== KITOBLAR RO'YXATI ==="
    
    if [ ! -f kitoblar.db ] || [ ! -s kitoblar.db ]; then
        sari "Kitoblar yo'q"
    else
        echo ""
        printf "%-30s %-20s %-6s %-8s\n" "NOM" "MUALLIF" "YIL" "SAHIFA"
        echo "─────────────────────────────────────────────────────────────────"
        
        while IFS='|' read -r nom muallif yil sahifa; do
            printf "%-30s %-20s %-6s %-8s\n" "$nom" "$muallif" "$yil" "$sahifa"
        done < kitoblar.db
    fi
    
    echo ""
    read -p "Davom etish uchun Enter..."
}

# Kitob qidirish
kitob_qidir() {
    echo ""
    read -p "Qidiruv (nom yoki muallif): " qidiruv
    
    if [ ! -f kitoblar.db ]; then
        sari "Kitoblar yo'q"
    else
        echo ""
        echo "=== QIDIRUV NATIJALARI ==="
        
        topildi=0
        while IFS='|' read -r nom muallif yil sahifa; do
            if [[ $nom == *"$qidiruv"* ]] || [[ $muallif == *"$qidiruv"* ]]; then
                echo ""
                echo "Nomi: $nom"
                echo "Muallif: $muallif"
                echo "Yili: $yil"
                echo "Sahifalar: $sahifa"
                echo "───────────────────────"
                ((topildi++))
            fi
        done < kitoblar.db
        
        if [ $topildi -eq 0 ]; then
            sari "Hech narsa topilmadi"
        else
            yashil "Topildi: $topildi ta"
        fi
    fi
    
    echo ""
    read -p "Davom etish uchun Enter..."
}

# Kitob o'chirish
kitob_ochir() {
    echo ""
    read -p "O'chiriladigan kitob nomi: " nom
    
    if [ ! -f kitoblar.db ]; then
        sari "Kitoblar yo'q"
    else
        if grep -q "^$nom|" kitoblar.db; then
            grep -v "^$nom|" kitoblar.db > kitoblar.tmp
            mv kitoblar.tmp kitoblar.db
            yashil "✓ Kitob o'chirildi"
        else
            qizil "✗ Kitob topilmadi"
        fi
    fi
    
    echo ""
    read -p "Davom etish uchun Enter..."
}

# Statistika
statistika() {
    echo ""
    echo "=== STATISTIKA ==="
    
    if [ ! -f kitoblar.db ] || [ ! -s kitoblar.db ]; then
        sari "Kitoblar yo'q"
    else
        jami=$(wc -l < kitoblar.db)
        echo "Jami kitoblar: $jami"
        
        # Eng ko'p sahifali kitob
        eng_kop=$(sort -t'|' -k4 -nr kitoblar.db | head -1)
        nom=$(echo "$eng_kop" | cut -d'|' -f1)
        sahifa=$(echo "$eng_kop" | cut -d'|' -f4)
        echo "Eng ko'p sahifali: $nom ($sahifa sahifa)"
        
        # O'rtacha sahifa
        jami_sahifa=0
        while IFS='|' read -r _ _ _ sahifa; do
            ((jami_sahifa += sahifa))
        done < kitoblar.db
        ortacha=$((jami_sahifa / jami))
        echo "O'rtacha sahifalar: $ortacha"
    fi
    
    echo ""
    read -p "Davom etish uchun Enter..."
}

# Rang funktsiyalari
qizil() { echo -e "\033[31m$1\033[0m"; }
yashil() { echo -e "\033[32m$1\033[0m"; }
sari() { echo -e "\033[33m$1\033[0m"; }

# ===============================
# ASOSIY DASTUR
# ===============================

while true; do
    bosh_menyu
    read -p "Tanlovingiz: " tanlov
    
    case $tanlov in
        1) kitob_qosh ;;
        2) kitoblar_korish ;;
        3) kitob_qidir ;;
        4) kitob_ochir ;;
        5) statistika ;;
        6)
            yashil "Xayr!"
            exit 0
            ;;
        *)
            qizil "Noto'g'ri tanlov!"
            sleep 1
            ;;
    esac
done
```

### 📝 Vazifalar:

1. **Vazifa 1:** 3 ta funktsiya yozing: qo'shish, ayirish, ko'paytirish. Har biri 2 ta parametr qabul qilsin
2. **Vazifa 2:** Emailni tekshiruvchi funktsiya yozing (@ va . belgisi borligini tekshirsin)
3. **Vazifa 3:** Fayl hajmini MB, KB yoki GB da qaytaruvchi funktsiya yarating
4. **Vazifa 4:** Parolning kuchliligini tekshiruvchi funktsiya (uzunlik, raqam, harf bormi)
5. **Vazifa 5:** Oddiy CRUD tizimi yarating: foydalanuvchilarni qo'shish, ko'rish, o'chirish, yangilash

---