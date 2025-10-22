## 5️⃣ O'ZGARUVCHILAR VA TURLARI
**Global nomi:** Variables and Data Types  
**O'zbek nomi:** O'zgaruvchilar va ma'lumot turlari

### O'zgaruvchi nima?

O'zgaruvchi - bu ma'lumotni saqlaydigan konteyner (idish). Xuddi qutiga nom yozib, ichiga biror narsani solib qo'yganingiz kabi.

**Hayotiy misol:** Telefon kontaktlari ro'yxati - har bir nom (o'zgaruvchi) telefon raqamini (qiymat) saqlaydi.

### O'zgaruvchi e'lon qilish

```bash
# Oddiy o'zgaruvchi
ism="Sardor"
yosh=25
shahar="Toshkent"

# Bo'sh joy bo'lmasligi kerak!
# NOTO'G'RI: ism = "Sardor"
# TO'G'RI: ism="Sardor"
```

### O'zgaruvchini chaqirish

```bash
# $ belgisi bilan
echo $ism
# Natija: Sardor

# Xavfsizroq usul (qavslar bilan)
echo "${ism}"

# Matn ichida
echo "Mening ismim ${ism}, yoshim ${yosh}"
# Natija: Mening ismim Sardor, yoshim 25
```

**Nima uchun qavslar?**

```bash
fayl="hujjat"
echo "$fayl_nusxa"    # Bo'sh (fayl_nusxa o'zgaruvchisi yo'q)
echo "${fayl}_nusxa"  # hujjat_nusxa (to'g'ri)
```

### O'zgaruvchi nomlash qoidalari

✅ **TO'G'RI:**
```bash
ism="Ali"
ism123="Vali"
_maxsus="qiymat"
ISM="KATTA"  # Katta-kichik harflar farq qiladi
```

❌ **NOTO'G'RI:**
```bash
123ism="Ali"        # Raqam bilan boshlanmasligi kerak
ism-familiya="Ali"  # Defis ishlatilmaydi
ism familiya="Ali"  # Bo'sh joy bo'lmasligi kerak
```

### O'zgaruvchi turlari

#### 1. **Matnli o'zgaruvchilar (String)**

```bash
# Qo'shtirnoq ichida
salom="Assalomu alaykum"
# Yoki birtirnoq
salom='Assalomu alaykum'

# Farqi:
ism="Sardor"
# Qo'shtirnoqda - o'zgaruvchi ishlaydi
echo "Salom, $ism!"  # Salom, Sardor!

# Birtirnoqda - aynan matn
echo 'Salom, $ism!'  # Salom, $ism!
```

**Ko'p qatorli matn:**
```bash
xabar="Birinchi qator
Ikkinchi qator
Uchinchi qator"

echo "$xabar"
```

**Heredoc usuli:**
```bash
xabar=$(cat << EOF
Birinchi qator
Ikkinchi qator
Uchinchi qator
EOF
)

echo "$xabar"
```

#### 2. **Raqamli o'zgaruvchilar (Integer)**

```bash
yosh=25
narx=15000
soni=0

# Raqamlar bilan ishlash
echo $yosh
echo $narx
```

**Hayotiy misol:**
```bash
# Mahsulot narxi
mahsulot_narxi=50000
soni=3
jami=$((mahsulot_narxi * soni))
echo "Jami: ${jami} so'm"
# Natija: Jami: 150000 so'm
```

#### 3. **Mantiqiy qiymatlar (Boolean)**

Bash da `true` va `false` mavjud:

```bash
aktiv=true
yopiq=false

if $aktiv; then
    echo "Aktiv!"
fi
```

Yoki raqamlar bilan:
```bash
# 0 = true (muvaffaqiyat)
# 1 yoki boshqa = false (xato)
holat=0

if [ $holat -eq 0 ]; then
    echo "Muvaffaqiyatli!"
fi
```

### O'zgaruvchilar turlari (scope)

#### 1. **Lokal o'zgaruvchilar**

```bash
#!/bin/bash

funksiya() {
    local mahalliy="Bu faqat funksiya ichida"
    echo $mahalliy
}

funksiya
echo $mahalliy  # Bo'sh (funksiyadan tashqarida ko'rinmaydi)
```

#### 2. **Global o'zgaruvchilar**

```bash
#!/bin/bash

global="Hamma joyda ko'rinadi"

funksiya() {
    echo $global  # Ishlaydi
}

funksiya
echo $global  # Ishlaydi
```

#### 3. **Environment o'zgaruvchilar**

```bash
# Export qilish - barcha child processlarda ko'rinadi
export MENING_OZGARUVCHIM="Qiymat"

# Tizim o'zgaruvchilari
echo $HOME      # Uy katalogi
echo $USER      # Foydalanuvchi nomi
echo $PATH      # Dasturlar yo'llari
echo $PWD       # Hozirgi katalog
echo $SHELL     # Ishlatilayotgan shell
echo $LANG      # Til sozlamalari
```

**Environment o'zgaruvchilarni ko'rish:**
```bash
# Barchasi
env
# yoki
printenv

# Ma'lum birini
printenv HOME
```

**Doimiy qilish (.bashrc ga qo'shish):**
```bash
echo 'export MENING_DASTURIM="/opt/dastur"' >> ~/.bashrc
source ~/.bashrc
```

### O'zgaruvchilarni o'chirish

```bash
ism="Sardor"
echo $ism        # Sardor

unset ism
echo $ism        # Bo'sh
```

### Readonly o'zgaruvchilar

```bash
readonly PI=3.14159
echo $PI         # 3.14159

PI=3.14          # Xato! O'zgartirib bo'lmaydi
```

### Command substitution (buyruq natijasini saqlash)

```bash
# $(buyruq) usuli (tavsiya etiladi)
bugun=$(date +%Y-%m-%d)
echo $bugun      # 2025-10-22

# Backtick usuli (eski)
bugun=`date +%Y-%m-%d`

# Fayllar soni
fayllar_soni=$(ls | wc -l)
echo "Katalogda ${fayllar_soni} ta fayl bor"

# Hozirgi katalog
joriy=$(pwd)
echo "Siz $joriy da turibsiz"
```

### Default qiymatlar va tekshirish

```bash
# Agar o'zgaruvchi bo'sh bo'lsa, default qiymat
ism=${FOYDALANUVCHI:-"Mehmon"}
echo $ism

# Bo'sh bo'lsa, qiymat berish va saqlash
PORT=${PORT:=8080}
echo $PORT

# Bo'sh bo'lsa, xato berish
fayl=${1:?"Fayl nomi kiritilmadi!"}
```

**Hayotiy misol:**
```bash
#!/bin/bash
# Server portini sozlash

PORT=${PORT:-3000}  # Default 3000
echo "Server $PORT portida ishga tushmoqda..."
```

### O'zgaruvchini tekshirish

```bash
# Mavjudligini tekshirish
if [ -z "$ism" ]; then
    echo "O'zgaruvchi bo'sh"
fi

# Bo'sh emasligini tekshirish
if [ -n "$ism" ]; then
    echo "O'zgaruvchi to'ldirilgan"
fi

# Qiymatni solishtirish
if [ "$yosh" -eq 25 ]; then
    echo "Yosh 25 ga teng"
fi
```

### O'zgaruvchi uzunligi

```bash
matn="Salom Dunyo"
echo ${#matn}         # 11 (belgilar soni)

massiv=(bir ikki uch)
echo ${#massiv[@]}    # 3 (elementlar soni)
```

### Matnni kesish (substring)

```bash
matn="Salom Dunyo!"

# Birinchi 5 belgi
echo ${matn:0:5}      # Salom

# 6-pozitsiyadan boshlab
echo ${matn:6}        # Dunyo!

# Oxirgi 6 belgi
echo ${matn: -6}      # Dunyo!
```

### Matnni almashtirish

```bash
fayl="hujjat.txt"

# Birinchi uchraganini almashtirish
echo ${fayl/txt/pdf}       # hujjat.pdf

# Barcha uchraganlarini almashtirish
matn="aaa bbb aaa"
echo ${matn//aaa/xxx}      # xxx bbb xxx

# Boshidan o'chirish
url="https://example.com"
echo ${url#https://}       # example.com

# Oxiridan o'chirish
fayl="arxiv.tar.gz"
echo ${fayl%.gz}           # arxiv.tar
echo ${fayl%%.*}           # arxiv (barcha kengaytmalar)
```

**Hayotiy misol:**
```bash
# Fayl kengaytmasini o'zgartirish
for fayl in *.txt; do
    yangi="${fayl%.txt}.md"
    mv "$fayl" "$yangi"
    echo "$fayl → $yangi"
done
```

### Katta-kichik harflar

```bash
matn="Salom Dunyo"

# Katta harflarga
echo ${matn^^}            # SALOM DUNYO

# Kichik harflarga
echo ${matn,,}            # salom dunyo

# Birinchi harfni katta
echo ${matn^}             # Salom dunyo

# Har bir so'zning birinchisini katta
matn="salom dunyo"
echo ${matn^^[sd]}        # Salom Dunyo
```

### Amaliy namuna: Ma'lumot yig'ish skripti

```bash
#!/bin/bash

# Foydalanuvchidan ma'lumot so'rash
echo "=== Ro'yxatdan o'tish ==="

read -p "Ismingiz: " ism
read -p "Yoshingiz: " yosh
read -p "Shahringiz [Toshkent]: " shahar

# Default qiymat
shahar=${shahar:-"Toshkent"}

# Ma'lumotlarni saqlash
readonly SANA=$(date +%Y-%m-%d)
fayl="foydalanuvchi_${ism}_${SANA}.txt"

# Faylga yozish
cat > "$fayl" << EOF
Ism: $ism
Yosh: $yosh
Shahar: $shahar
Ro'yxatdan o'tgan: $SANA
EOF

echo "Ma'lumotlar $fayl ga saqlandi"
cat "$fayl"
```

### Maxsus o'zgaruvchilar (Special Variables)

```bash
#!/bin/bash

# $0 - skript nomi
echo "Skript: $0"

# $1, $2, ... - argumentlar
echo "Birinchi argument: $1"
echo "Ikkinchi argument: $2"

# $# - argumentlar soni
echo "Jami argumentlar: $#"

# $@ - barcha argumentlar (alohida)
echo "Barcha argumentlar: $@"

# $* - barcha argumentlar (bitta satr)
echo "Argumentlar satri: $*"

# $? - oxirgi buyruq natijasi (0 = muvaffaqiyat)
ls /mavjud_emas
echo "Xato kodi: $?"

# $$ - hozirgi process ID
echo "Process ID: $$"

# $! - oxirgi background process ID
sleep 10 &
echo "Background process: $!"
```

**Hayotiy misol:**
```bash
#!/bin/bash
# Fayl nusxalash skripti

if [ $# -ne 2 ]; then
    echo "Foydalanish: $0 <manba> <nusxa>"
    exit 1
fi

manba="$1"
nusxa="$2"

if [ ! -f "$manba" ]; then
    echo "Xato: $manba topilmadi!"
    exit 1
fi

cp "$manba" "$nusxa"

if [ $? -eq 0 ]; then
    echo "✓ Nusxalandi: $manba → $nusxa"
else
    echo "✗ Xato yuz berdi!"
    exit 1
fi
```

### 📝 Vazifalar:

1. **Vazifa 1:** Uchta o'zgaruvchi yarating (ism, yosh, shahar) va ularni echo bilan ekranga chiqaring
2. **Vazifa 2:** Bugungi sanani `$(date)` bilan oling va faylga yozing
3. **Vazifa 3:** Skript yozing: 2 ta raqam kiritilsin, ularning yig'indisini hisoblasin
4. **Vazifa 4:** PATH o'zgaruvchisini ekranga chiqaring va qancha yo'l borligini sanang
5. **Vazifa 5:** Fayl nomini olib, kengaytmasini almashtiruvchi skript yozing (txt → md)

---