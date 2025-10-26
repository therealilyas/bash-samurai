

## 1️⃣4️⃣ REGEX VA GREP/EGREP
**Global nomi:** Regular Expressions and Pattern Matching  
**O'zbek nomi:** Muntazam ifodalar va pattern moslashtirish

### Regex (Regular Expression) nima?

Regex - bu matndan ma'lum patternlarni topish uchun maxsus til. Qidiruvning superkuchi!

**Hayotiy misol:** Qidiruv filtri - "998 bilan boshlanib, 9 ta raqam bo'lgan" telefon raqamlarini topish. Yoki "@gmail.com bilan tugaydigan" emaillarni topish.

### Asosiy Regex belgilari

#### 1. Literal belgilar - oddiy harflar

```bash
# "test" so'zini qidirish
echo "bu test matni" | grep "test"
# ✓ topildi

# Katta-kichik harf muhim
echo "Bu TEST matni" | grep "test"
# ✗ topilmadi

# -i flag bilan
echo "Bu TEST matni" | grep -i "test"
# ✓ topildi
```

#### 2. Metabelgilar (Special characters)

**. (nuqta)** - Istalgan BITTA belgi

```bash
echo "cat" | grep "c.t"       # ✓ (cat)
echo "cot" | grep "c.t"       # ✓ (cot)
echo "cut" | grep "c.t"       # ✓ (cut)
echo "cart" | grep "c.t"      # ✗ (2 ta belgi)

# Literal nuqtani qidirish
echo "file.txt" | grep "file\.txt"    # \ bilan escape
```

**^** - Qator boshi

```bash
echo "test matn" | grep "^test"       # ✓
echo "bu test" | grep "^test"         # ✗

# Faylda
grep "^#" skript.sh                   # Izohlar (# bilan boshlanuvchi)
grep "^function" skript.sh            # function bilan boshlanuvchi qatorlar
```

**$** - Qator oxiri

```bash
echo "test" | grep "test$"            # ✓
echo "test matn" | grep "test$"       # ✗

# Faylda
grep "done$" skript.sh                # done bilan tugaydigan qatorlar
grep "^\s*$" fayl.txt                 # Bo'sh qatorlar
```

***** - Oldingi element 0 yoki ko'p marta

```bash
echo "ct" | grep "co*t"               # ✓ (o yo'q)
echo "cot" | grep "co*t"              # ✓ (o bir marta)
echo "coot" | grep "co*t"             # ✓ (o ikki marta)
echo "cooot" | grep "co*t"            # ✓ (o uch marta)
```

**+** - Oldingi element 1 yoki ko'p marta (egrep yoki grep -E)

```bash
echo "ct" | grep -E "co+t"            # ✗ (o kamida 1 bo'lishi kerak)
echo "cot" | grep -E "co+t"           # ✓
echo "coot" | grep -E "co+t"          # ✓
```

**?** - Oldingi element 0 yoki 1 marta

```bash
echo "color" | grep -E "colou?r"      # ✓ (u yo'q)
echo "colour" | grep -E "colou?r"     # ✓ (u bor)
```

**[]** - Belgilar to'plami

```bash
# a, e, i, o, u dan biri
echo "cat" | grep "[aeiou]"           # ✓ (a bor)
echo "dog" | grep "[aeiou]"           # ✓ (o bor)
echo "try" | grep "[aeiou]"           # ✗

# Raqamlar
echo "file1" | grep "[0-9]"           # ✓
echo "file" | grep "[0-9]"            # ✗

# Diapazon
echo "b" | grep "[a-z]"               # ✓ (kichik harf)
echo "B" | grep "[A-Z]"               # ✓ (katta harf)
echo "5" | grep "[0-9]"               # ✓ (raqam)

# Inkor (^)
echo "5" | grep "[^0-9]"              # ✗ (raqam)
echo "a" | grep "[^0-9]"              # ✓ (raqam emas)
```

**|** - YO (OR)

```bash
echo "cat" | grep -E "cat|dog"        # ✓
echo "dog" | grep -E "cat|dog"        # ✓
echo "bird" | grep -E "cat|dog"       # ✗

# Ko'p variantlar
grep -E "error|warning|critical" log.txt
```

**()** - Guruhlash

```bash
# Takrorlanuvchi guruh
echo "ababab" | grep -E "(ab)+"       # ✓
echo "abab" | grep -E "(ab){2}"       # ✓ (2 marta takrorlangan)

# OR bilan
echo "doghouse" | grep -E "(cat|dog)house"    # ✓
```

**{n,m}** - Takrorlash soni

```bash
# Aniq n marta
echo "aaa" | grep -E "a{3}"           # ✓ (3 ta a)
echo "aa" | grep -E "a{3}"            # ✗ (2 ta a)

# n dan m gacha
echo "aaaa" | grep -E "a{2,4}"        # ✓# Kamida n marta
echo "aaaaa" | grep -E "a{3,}"        # ✓ (5 ta a, 3 dan ko'p)

# Hayotiy misollar
# Telefon raqam: 9 ta raqam
echo "998901234567" | grep -E "[0-9]{9,12}"    # ✓

# Parol: kamida 8 ta belgi
echo "secret123" | grep -E ".{8,}"             # ✓
```

### Belgilar klasslari (Character Classes)

```bash
# [:digit:]  - Raqamlar (0-9)
echo "abc123" | grep "[[:digit:]]"

# [:alpha:]  - Harflar (a-zA-Z)
echo "abc123" | grep "[[:alpha:]]"

# [:alnum:]  - Harflar va raqamlar
echo "abc123" | grep "[[:alnum:]]"

# [:space:]  - Bo'sh joylar (space, tab, newline)
echo "hello world" | grep "[[:space:]]"

# [:upper:]  - Katta harflar
echo "Hello" | grep "[[:upper:]]"

# [:lower:]  - Kichik harflar
echo "Hello" | grep "[[:lower:]]"

# [:punct:]  - Tinish belgilari
echo "Hello!" | grep "[[:punct:]]"
```

### Hayotiy pattern misollar

#### 1. Email validatsiya

```bash
# Oddiy pattern
email_pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"

echo "sardor@example.com" | grep -E "$email_pattern"     # ✓
echo "test.user@mail.co.uk" | grep -E "$email_pattern"   # ✓
echo "invalid@" | grep -E "$email_pattern"               # ✗

# Fayldan emaillarni topish
grep -Eo "$email_pattern" fayl.txt

# Funksiya
email_tekshir() {
    local email=$1
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Test
if email_tekshir "sardor@example.com"; then
    echo "✓ To'g'ri email"
else
    echo "✗ Noto'g'ri email"
fi
```

#### 2. Telefon raqam (O'zbekiston)

```bash
# Pattern: +998 XX XXX XX XX yoki 998XXXXXXXXX
telefon_pattern="^(\+?998)?[0-9]{9}$"

echo "+998901234567" | grep -E "$telefon_pattern"    # ✓
echo "998901234567" | grep -E "$telefon_pattern"     # ✓
echo "901234567" | grep -E "$telefon_pattern"        # ✓
echo "12345" | grep -E "$telefon_pattern"            # ✗

# Format qilish
telefon_format() {
    local telefon=$1
    # Faqat raqamlarni qoldirish
    telefon=$(echo "$telefon" | tr -cd '0-9')
    
    # Format: +998 XX XXX XX XX
    if [ ${#telefon} -eq 12 ]; then
        echo "+${telefon:0:3} ${telefon:3:2} ${telefon:5:3} ${telefon:8:2} ${telefon:10:2}"
    elif [ ${#telefon} -eq 9 ]; then
        echo "+998 ${telefon:0:2} ${telefon:2:3} ${telefon:5:2} ${telefon:7:2}"
    else
        echo "Noto'g'ri format"
        return 1
    fi
}

telefon_format "998901234567"
# +998 90 123 45 67
```

#### 3. IP manzil

```bash
# IPv4 pattern (oddiy)
ip_pattern="[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

echo "192.168.1.1" | grep -E "$ip_pattern"    # ✓
echo "10.0.0.1" | grep -E "$ip_pattern"       # ✓
echo "999.999.999.999" | grep -E "$ip_pattern"  # ✓ (lekin noto'g'ri IP)

# To'g'ri IPv4 (0-255 oralig'i)
ip_pattern_togri="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

ip_tekshir() {
    local ip=$1
    if [[ $ip =~ $ip_pattern_togri ]]; then
        echo "✓ To'g'ri IP"
        return 0
    else
        echo "✗ Noto'g'ri IP"
        return 1
    fi
}

ip_tekshir "192.168.1.1"      # ✓
ip_tekshir "999.999.999.999"  # ✗
```

#### 4. URL validatsiya

```bash
# URL pattern
url_pattern="^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$"

echo "https://example.com" | grep -E "$url_pattern"           # ✓
echo "http://test.co.uk/page" | grep -E "$url_pattern"        # ✓
echo "ftp://example.com" | grep -E "$url_pattern"             # ✗

# URL dan domen ajratish
url="https://www.example.com/path/to/page?id=123"
domen=$(echo "$url" | grep -oE "https?://[^/]+" | cut -d'/' -f3)
echo $domen  # www.example.com
```

#### 5. Parol kuchi tekshirish

```bash
parol_tekshir() {
    local parol=$1
    local kuch=0
    
    # Kamida 8 ta belgi
    if [ ${#parol} -ge 8 ]; then
        ((kuch++))
    fi
    
    # Katta harf bor
    if [[ $parol =~ [A-Z] ]]; then
        ((kuch++))
    fi
    
    # Kichik harf bor
    if [[ $parol =~ [a-z] ]]; then
        ((kuch++))
    fi
    
    # Raqam bor
    if [[ $parol =~ [0-9] ]]; then
        ((kuch++))
    fi
    
    # Maxsus belgi bor
    if [[ $parol =~ [^a-zA-Z0-9] ]]; then
        ((kuch++))
    fi
    
    case $kuch in
        0|1|2)
            echo "❌ Juda zaif parol!"
            return 1
            ;;
        3)
            echo "⚠️  Zaif parol"
            return 1
            ;;
        4)
            echo "✓ O'rtacha parol"
            return 0
            ;;
        5)
            echo "✓✓ Kuchli parol!"
            return 0
            ;;
    esac
}

# Test
parol_tekshir "password"           # Zaif
parol_tekshir "Password123"        # O'rtacha
parol_tekshir "P@ssw0rd123!"       # Kuchli
```

### grep, egrep, fgrep farqi

```bash
# grep - Asosiy regex
grep "pattern" fayl.txt

# grep -E (yoki egrep) - Kengaytirilgan regex
grep -E "pattern1|pattern2" fayl.txt
egrep "pattern1|pattern2" fayl.txt

# grep -F (yoki fgrep) - Fixed string (regex yo'q, tezroq)
fgrep "literal.string" fayl.txt  # . ni maxsus belgi sifatida ko'rmaydi
```

### grep amaliy misollar

#### 1. Log faylda xatolarni topish

```bash
#!/bin/bash

LOG="/var/log/syslog"

echo "=== XATOLAR TAHLILI ==="

# Barcha xatolar
echo "Jami xatolar:"
grep -ci "error\|exception\|failed\|critical" "$LOG"

echo ""
echo "Xato turlari:"
echo "  ERROR: $(grep -ci "error" "$LOG")"
echo "  EXCEPTION: $(grep -ci "exception" "$LOG")"
echo "  FAILED: $(grep -ci "failed" "$LOG")"
echo "  CRITICAL: $(grep -ci "critical" "$LOG")"

echo ""
echo "Oxirgi 10 ta xato:"
grep -i "error\|exception\|failed\|critical" "$LOG" | tail -10

echo ""
echo "Eng ko'p xato bergan IP lar:"
grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" "$LOG" | \
    sort | uniq -c | sort -rn | head -5
```

#### 2. Kod ichida TODO/FIXME topish

```bash
#!/bin/bash

echo "=== TODO VA FIXME QIDIRUV ==="

# Loyihada qidirish
find . -type f \( -name "*.sh" -o -name "*.py" -o -name "*.js" \) | \
while read fayl; do
    if grep -q "TODO\|FIXME" "$fayl"; then
        echo ""
        echo "📄 $fayl:"
        grep -n "TODO\|FIXME" "$fayl" | \
            sed 's/^/  /'
    fi
done

echo ""
echo "Statistika:"
echo "  TODO: $(grep -r "TODO" . --include="*.sh" --include="*.py" | wc -l)"
echo "  FIXME: $(grep -r "FIXME" . --include="*.sh" --include="*.py" | wc -l)"
```

#### 3. Ma'lumot extractor

```bash
#!/bin/bash

FAYL="$1"

if [ ! -f "$FAYL" ]; then
    echo "Fayl topilmadi: $FAYL"
    exit 1
fi

echo "=== MA'LUMOT EXTRACTOR ==="
echo "Fayl: $FAYL"
echo ""

# Emaillar
echo "📧 Emaillar:"
grep -Eoh "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "$FAYL" | \
    sort -u | sed 's/^/  /'

echo ""

# Telefon raqamlar (O'zbekiston formati)
echo "📞 Telefon raqamlar:"
grep -Eoh "(\+998|998)?[0-9]{9}" "$FAYL" | \
    sort -u | sed 's/^/  /'

echo ""

# IP manzillar
echo "🌐 IP manzillar:"
grep -Eoh "([0-9]{1,3}\.){3}[0-9]{1,3}" "$FAYL" | \
    sort -u | sed 's/^/  /'

echo ""

# URLlar
echo "🔗 URLlar:"
grep -Eoh "https?://[a-zA-Z0-9./?=_-]+" "$FAYL" | \
    sort -u | sed 's/^/  /'
```

#### 4. Log monitoring (real-time)

```bash
#!/bin/bash

LOG="${1:-/var/log/syslog}"
PATTERN="${2:-error|warning|critical}"

echo "=== REAL-TIME LOG MONITORING ==="
echo "Fayl: $LOG"
echo "Pattern: $PATTERN"
echo "Ctrl+C - to'xtatish"
echo ""

# Rangli chiqarish
tail -f "$LOG" | grep --line-buffered -iE "$PATTERN" | \
while read qator; do
    if echo "$qator" | grep -iq "error"; then
        echo -e "\033[31m[ERROR]\033[0m $qator"
    elif echo "$qator" | grep -iq "warning"; then
        echo -e "\033[33m[WARNING]\033[0m $qator"
    elif echo "$qator" | grep -iq "critical"; then
        echo -e "\033[35m[CRITICAL]\033[0m $qator"
    else
        echo "$qator"
    fi
done
```

### sed bilan regex

```bash
# Emaillarni maskirovka
sed -E 's/([a-zA-Z0-9])[a-zA-Z0-9._%+-]*@/\1***@/g' users.txt
# sardor@example.com → s***@example.com

# Telefon raqamlarni maskirovka
sed -E 's/([0-9]{3})[0-9]{6}([0-9]{3})/\1******\2/g' phones.txt
# 998901234567 → 998******567

# HTML teglarini o'chirish
sed -E 's/<[^>]+>//g' index.html

# URL dan domen ajratish
echo "https://www.example.com/page" | sed -E 's|https?://([^/]+).*|\1|'
# www.example.com

# Sanani formatlash (YYYY-MM-DD → DD.MM.YYYY)
echo "2025-10-23" | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})/\3.\2.\1/'
# 23.10.2025
```

### awk bilan regex

```bash
# Ma'lum patternli qatorlar
awk '/error|warning/' log.txt

# Pattern bo'lmagan qatorlar
awk '!/^#/' config.txt           # Izoh emas

# Regex bilan ustun tekshirish
awk '$3 ~ /^[0-9]+$/ {print $0}' data.txt    # 3-ustun raqam

# IP manzillarni filtrlash
awk '$1 ~ /^192\.168\./ {print $1}' access.log

# Email validatsiya
awk '$2 ~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ {print $2}' users.txt
```

### Amaliy loyiha: Universal validator

```bash
#!/bin/bash

# =====================================
# UNIVERSAL DATA VALIDATOR
# =====================================

declare -A patterns=(
    ["email"]="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    ["phone_uz"]='^(\+998|998)?[0-9]{9}$'
    ["ip"]="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    ["url"]='^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$'
    ["date_ymd"]='^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$'
    ["time_hms"]='^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$'
    ["credit_card"]='^[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}$'
    ["postal_code_uz"]='^[0-9]{6}$'
)

declare -A descriptions=(
    ["email"]="Email manzil"
    ["phone_uz"]="Telefon raqam (O'zbekiston)"
    ["ip"]="IPv4 manzil"
    ["url"]="Web manzil"
    ["date_ymd"]="Sana (YYYY-MM-DD)"
    ["time_hms"]="Vaqt (HH:MM:SS)"
    ["credit_card"]="Kredit karta raqami"
    ["postal_code_uz"]="Pochta indeksi"
)

tekshir() {
    local tur=$1
    local qiymat=$2
    
    if [ -z "${patterns[$tur]}" ]; then
        echo "✗ Noma'lum tur: $tur"
        return 1
    fi
    
    if [[ $qiymat =~ ${patterns[$tur]} ]]; then
        echo "✓ To'g'ri ${descriptions[$tur]}: $qiymat"
        return 0
    else
        echo "✗ Noto'g'ri ${descriptions[$tur]}: $qiymat"
        return 1
    fi
}

fayl_tekshir() {
    local fayl=$1
    local tur=$2
    
    if [ ! -f "$fayl" ]; then
        echo "Fayl topilmadi: $fayl"
        return 1
    fi
    
    echo "=== ${descriptions[$tur]} TEKSHIRUV ==="
    echo "Fayl: $fayl"
    echo ""
    
    local togri=0
    local notogri=0
    
    while read qiymat; do
        if [[ $qiymat =~ ${patterns[$tur]} ]]; then
            echo "✓ $qiymat"
            ((togri++))
        else
            echo "✗ $qiymat"
            ((notogri++))
        fi
    done < "$fayl"
    
    echo ""
    echo "Natija: To'g'ri=$togri, Noto'g'ri=$notogri"
}

extract() {
    local fayl=$1
    local tur=$2
    
    if [ ! -f "$fayl" ]; then
        echo "Fayl topilmadi: $fayl"
        return 1
    fi
    
    echo "=== ${descriptions[$tur]} EXTRACTION ==="
    
    case $tur in
        email)
            grep -Eoh "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "$fayl" | sort -u
            ;;
        phone_uz)
            grep -Eoh "(\+998|998)?[0-9]{9}" "$fayl" | sort -u
            ;;
        ip)
            grep -Eoh "([0-9]{1,3}\.){3}[0-9]{1,3}" "$fayl" | sort -u
            ;;
        url)
            grep -Eoh "https?://[a-zA-Z0-9./?=_-]+" "$fayl" | sort -u
            ;;
        *)
            echo "Extract qo'llab-quvvatlanmaydi: $tur"
            return 1
            ;;
    esac
}

# Interaktiv rejim
interaktiv() {
    while true; do
        clear
        echo "=== DATA VALIDATOR ==="
        echo ""
        echo "Mavjud turlar:"
        for tur in "${!descriptions[@]}"; do
            echo "  - $tur (${descriptions[$tur]})"
        done
        echo ""
        echo "1. Bitta qiymatni tekshirish"
        echo "2. Faylni tekshirish"
        echo "3. Ma'lumot ajratib olish"
        echo "4. Chiqish"
        echo ""
        
        read -p "Tanlov: " tanlov
        
        case $tanlov in
            1)
                read -p "Turi: " tur
                read -p "Qiymat: " qiymat
                tekshir "$tur" "$qiymat"
                read -p "Davom..."
                ;;
            2)
                read -p "Fayl: " fayl
                read -p "Turi: " tur
                fayl_tekshir "$fayl" "$tur"
                read -p "Davom..."
                ;;
            3)
                read -p "Fayl: " fayl
                read -p "Turi: " tur
                extract "$fayl" "$tur"
                read -p "Davom..."
                ;;
            4)
                echo "Xayr!"
                exit 0
                ;;
        esac
    done
}

# CLI rejim
if [ $# -eq 0 ]; then
    interaktiv
elif [ "$1" = "check" ]; then
    tekshir "$2" "$3"
elif [ "$1" = "file" ]; then
    fayl_tekshir "$2" "$3"
elif [ "$1" = "extract" ]; then
    extract "$2" "$3"
else
    echo "Foydalanish:"
    echo "  $0                          # Interaktiv rejim"
    echo "  $0 check <tur> <qiymat>     # Bitta tekshirish"
    echo "  $0 file <fayl> <tur>        # Fayl tekshirish"
    echo "  $0 extract <fayl> <tur>     # Ma'lumot ajratish"
fi
```

### 📝 Vazifalar:

1. **Vazifa 1:** Regex pattern yozing: Parol kamida 8 ta belgi, 1 ta katta harf, 1 ta raqam va 1 ta maxsus belgi bo'lishi kerak
2. **Vazifa 2:** Log fayldan barcha xatolarni (ERROR, EXCEPTION) topib, vaqt bo'yicha saralovchi skript
3. **Vazifa 3:** Matndan barcha URL larni ajratib oluvchi va domenlariga qarab guruhlovchi dastur
4. **Vazifa 4:** Credit card validator: 16 ta raqam, Luhn algoritmini tekshirish
5. **Vazifa 5:** CSV faylni validatsiya qiluvchi skript - har bir ustun uchun alohida regex pattern

---