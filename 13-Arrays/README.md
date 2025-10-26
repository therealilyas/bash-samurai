## 1️⃣3️⃣ ARRAYLAR VA ASSOCIATIVE ARRAYLAR
**Global nomi:** Arrays and Associative Arrays  
**O'zbek nomi:** Massivlar va assotsiativ massivlar

### Array (Massiv) nima?

Massiv - bu bir o'zgaruvchi nomida ko'p qiymatlarni saqlash. Xuddi qutidagi nomerli yacheykalar.

**Hayotiy misol:** Kitob javoni - har bir kitob o'z raqamiga ega (1-kitob, 2-kitob, 3-kitob). Massiv ham shunday - elementlar indeks (0, 1, 2...) bilan saqlanadi.

### Oddiy Array (Indexed Array)

#### Array yaratish

```bash
# Usul 1: Bitta qatorda
mevalar=("olma" "nok" "uzum" "o'rik" "shaftoli")

# Usul 2: Alohida qo'shish
mevalar[0]="olma"
mevalar[1]="nok"
mevalar[2]="uzum"

# Usul 3: declare bilan
declare -a raqamlar=(1 2 3 4 5)

# Bo'sh array
bo'sh=()
```

#### Elementlarga murojaat

```bash
mevalar=("olma" "nok" "uzum" "o'rik")

# Bitta elementni olish
echo ${mevalar[0]}        # olma
echo ${mevalar[2]}        # uzum

# Oxirgi element
echo ${mevalar[-1]}       # o'rik

# Barcha elementlar
echo ${mevalar[@]}        # olma nok uzum o'rik
echo ${mevalar[*]}        # olma nok uzum o'rik

# Elementlar soni
echo ${#mevalar[@]}       # 4

# Ma'lum elementning uzunligi
echo ${#mevalar[0]}       # 4 (olma - 4 harf)
```

**[@] va [*] farqi:**
```bash
mevalar=("olma qizil" "nok yashil" "uzum")

# [@] - har bir element alohida
for meva in "${mevalar[@]}"; do
    echo "- $meva"
done
# - olma qizil
# - nok yashil
# - uzum

# [*] - hammasi bitta satr
for meva in "${mevalar[*]}"; do
    echo "- $meva"
done
# - olma qizil nok yashil uzum
```

#### Array elementlarini o'zgartirish

```bash
mevalar=("olma" "nok" "uzum")

# Elementni o'zgartirish
mevalar[1]="anor"
echo ${mevalar[@]}        # olma anor uzum

# Oxiriga qo'shish
mevalar+=("shaftoli")
echo ${mevalar[@]}        # olma anor uzum shaftoli

# Ma'lum joyga qo'shish
mevalar[10]="gilos"       # Bo'sh joylar avtomatik yaratiladi
echo ${#mevalar[@]}       # 5 (faqat to'ldirilgan elementlar)

# Elementni o'chirish
unset mevalar[2]
echo ${mevalar[@]}        # olma anor shaftoli gilos
echo ${#mevalar[@]}       # 4

# Butun arrayni o'chirish
unset mevalar
```

#### Array ustida operatsiyalar

```bash
# Kesish (slicing)
raqamlar=(0 1 2 3 4 5 6 7 8 9)

echo ${raqamlar[@]:2}      # 2 dan oxirigacha: 2 3 4 5 6 7 8 9
echo ${raqamlar[@]:2:4}    # 2 dan boshlab 4 ta: 2 3 4 5
echo ${raqamlar[@]: -3}    # Oxirgi 3 ta: 7 8 9

# Pattern matching
mevalar=("olma" "nok" "uzum" "o'rik" "olcha")

# "o" bilan boshlanuvchilar
for meva in ${mevalar[@]/o*/}; do
    echo $meva
done

# Almashtirish
echo ${mevalar[@]/ol/OL}   # OLma nok uzum o'rik OLcha

# Indekslarni olish
echo ${!mevalar[@]}        # 0 1 2 3 4
```

### Hayotiy misollar

#### 1. Foydalanuvchilar ro'yxati

```bash
#!/bin/bash

# Foydalanuvchilarni saqlash
users=("admin" "sardor" "olim" "komil" "jasur")

echo "=== FOYDALANUVCHILAR ==="
for i in "${!users[@]}"; do
    echo "$((i+1)). ${users[$i]}"
done

echo ""
read -p "Yangi foydalanuvchi: " yangi
users+=("$yangi")

echo ""
echo "Yangilangan ro'yxat:"
printf '%s\n' "${users[@]}"
```

#### 2. TODO list

```bash
#!/bin/bash

declare -a tasks=()

while true; do
    clear
    echo "=== TODO LIST ==="
    if [ ${#tasks[@]} -eq 0 ]; then
        echo "Vazifalar yo'q"
    else
        for i in "${!tasks[@]}"; do
            echo "$((i+1)). ${tasks[$i]}"
        done
    fi
    
    echo ""
    echo "1. Vazifa qo'shish"
    echo "2. Vazifa o'chirish"
    echo "3. Chiqish"
    echo ""
    
    read -p "Tanlov: " tanlov
    
    case $tanlov in
        1)
            read -p "Yangi vazifa: " vazifa
            tasks+=("$vazifa")
            ;;
        2)
            read -p "Vazifa raqami: " raqam
            unset tasks[$((raqam-1))]
            tasks=("${tasks[@]}")  # Indekslarni qayta tartibga solish
            ;;
        3)
            echo "Xayr!"
            exit 0
            ;;
    esac
done
```

#### 3. Fayllarni backup qilish

```bash
#!/bin/bash

# Backup qilinadigan fayllar
declare -a muhim_fayllar=(
    "$HOME/.bashrc"
    "$HOME/.vimrc"
    "$HOME/.gitconfig"
    "/etc/nginx/nginx.conf"
    "/etc/hosts"
)

BACKUP_DIR="$HOME/config_backup_$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

echo "=== CONFIG BACKUP ==="
muvaffaqiyatli=0
xato=0

for fayl in "${muhim_fayllar[@]}"; do
    if [ -f "$fayl" ]; then
        fayl_nomi=$(basename "$fayl")
        if cp "$fayl" "$BACKUP_DIR/$fayl_nomi" 2>/dev/null; then
            echo "✓ $fayl"
            ((muvaffaqiyatli++))
        else
            echo "✗ $fayl (ruxsat yo'q)"
            ((xato++))
        fi
    else
        echo "⊘ $fayl (topilmadi)"
        ((xato++))
    fi
done

echo ""
echo "Muvaffaqiyatli: $muvaffaqiyatli"
echo "Xato: $xato"
echo "Backup: $BACKUP_DIR"
```

### Associative Array (Kalit-Qiymat Massivi)

Associative array - bu indeks o'rniga matnli kalitlar ishlatadigan massiv. Xuddi lug'at.

**Hayotiy misol:** Telefon kontaktlari - ismga qarab raqamni topish. "Sardor" → "+998901234567"

#### Associative array yaratish

**⚠️ Muhim:** Bash 4.0+ versiyasida mavjud!

```bash
# declare -A bilan e'lon qilish SHART!
declare -A telefonlar

# Qo'shish
telefonlar["Sardor"]="+998901234567"
telefonlar["Olim"]="+998907654321"
telefonlar["Komil"]="+998909876543"

# Yoki bitta qatorda
declare -A ranglar=(
    ["qizil"]="#FF0000"
    ["yashil"]="#00FF00"
    ["ko'k"]="#0000FF"
)
```

#### Elementlarga murojaat

```bash
declare -A talaba=(
    ["ism"]="Sardor"
    ["yosh"]="25"
    ["shahar"]="Toshkent"
    ["fakultet"]="IT"
)

# Qiymatni olish
echo ${talaba["ism"]}           # Sardor
echo ${talaba["yosh"]}          # 25

# Barcha qiymatlar
echo ${talaba[@]}               # Sardor 25 Toshkent IT

# Barcha kalitlar
echo ${!talaba[@]}              # ism yosh shahar fakultet

# Elementlar soni
echo ${#talaba[@]}              # 4

# Kalit mavjudmi?
if [ -v talaba["email"] ]; then
    echo "Email mavjud"
else
    echo "Email yo'q"
fi
```

#### Associative array ustida operatsiyalar

```bash
declare -A mahsulotlar=(
    ["olma"]="5000"
    ["nok"]="7000"
    ["uzum"]="12000"
)

# Yangi qo'shish
mahsulotlar["anor"]="15000"

# O'zgartirish
mahsulotlar["olma"]="5500"

# O'chirish
unset mahsulotlar["nok"]

# Iteratsiya (kalitlar bo'yicha)
for kalit in "${!mahsulotlar[@]}"; do
    echo "$kalit: ${mahsulotlar[$kalit]} so'm"
done

# Iteratsiya (qiymatlar bo'yicha)
for qiymat in "${mahsulotlar[@]}"; do
    echo "Narx: $qiymat so'm"
done

# Kalit va qiymat birgalikda
for kalit in "${!mahsulotlar[@]}"; do
    qiymat=${mahsulotlar[$kalit]}
    echo "$kalit → $qiymat so'm"
done
```

### Hayotiy misollar (Associative Array)

#### 1. Kontakt boshqaruvi

```bash
#!/bin/bash

declare -A kontaktlar

while true; do
    clear
    echo "=== KONTAKTLAR ==="
    
    if [ ${#kontaktlar[@]} -eq 0 ]; then
        echo "Kontaktlar yo'q"
    else
        for ism in "${!kontaktlar[@]}"; do
            echo "📞 $ism: ${kontaktlar[$ism]}"
        done
    fi
    
    echo ""
    echo "1. Kontakt qo'shish"
    echo "2. Kontakt qidirish"
    echo "3. Kontakt o'chirish"
    echo "4. Chiqish"
    echo ""
    
    read -p "Tanlov: " tanlov
    
    case $tanlov in
        1)
            read -p "Ism: " ism
            read -p "Telefon: " telefon
            kontaktlar["$ism"]="$telefon"
            echo "✓ Qo'shildi"
            sleep 1
            ;;
        2)
            read -p "Ism: " ism
            if [ -v kontaktlar["$ism"] ]; then
                echo "📞 ${kontaktlar[$ism]}"
            else
                echo "✗ Topilmadi"
            fi
            read -p "Davom... "
            ;;
        3)
            read -p "Ism: " ism
            if [ -v kontaktlar["$ism"] ]; then
                unset kontaktlar["$ism"]
                echo "✓ O'chirildi"
            else
                echo "✗ Topilmadi"
            fi
            sleep 1
            ;;
        4)
            echo "Xayr!"
            exit 0
            ;;
    esac
done
```

#### 2. Sozlamalar boshqaruvi

```bash
#!/bin/bash

declare -A config=(
    ["port"]="8080"
    ["host"]="localhost"
    ["debug"]="false"
    ["max_connections"]="100"
    ["timeout"]="30"
)

sozlama_yuklash() {
    if [ -f "config.txt" ]; then
        while IFS='=' read -r kalit qiymat; do
            config["$kalit"]="$qiymat"
        done < "config.txt"
        echo "✓ Sozlamalar yuklandi"
    fi
}

sozlama_saqlash() {
    > "config.txt"
    for kalit in "${!config[@]}"; do
        echo "$kalit=${config[$kalit]}" >> "config.txt"
    done
    echo "✓ Sozlamalar saqlandi"
}

sozlamalarni_korish() {
    echo "=== SOZLAMALAR ==="
    for kalit in "${!config[@]}"; do
        printf "%-20s : %s\n" "$kalit" "${config[$kalit]}"
    done
}

sozlama_ozgartirish() {
    read -p "Sozlama nomi: " kalit
    if [ -v config["$kalit"] ]; then
        echo "Hozirgi qiymat: ${config[$kalit]}"
        read -p "Yangi qiymat: " qiymat
        config["$kalit"]="$qiymat"
        echo "✓ O'zgartirildi"
    else
        echo "✗ Sozlama topilmadi"
    fi
}

# Asosiy sikl
sozlama_yuklash

while true; do
    clear
    sozlamalarni_korish
    echo ""
    echo "1. Sozlamani o'zgartirish"
    echo "2. Saqlash"
    echo "3. Chiqish"
    echo ""
    
    read -p "Tanlov: " tanlov
    
    case $tanlov in
        1) sozlama_ozgartirish; sleep 2 ;;
        2) sozlama_saqlash; sleep 1 ;;
        3) echo "Xayr!"; exit 0 ;;
    esac
done
```

#### 3. Log statistikasi (IP counter)

```bash
#!/bin/bash

declare -A ip_hisoblagich

LOG_FAYL="${1:-access.log}"

echo "Log tahlil qilinmoqda: $LOG_FAYL"

# IP larni sanash
while read -r ip qolgan; do
    ((ip_hisoblagich[$ip]++))
done < <(awk '{print $1}' "$LOG_FAYL")

echo ""
echo "=== TOP 20 IP MANZILLAR ==="

# Arrayni qiymat bo'yicha saralash
for ip in "${!ip_hisoblagich[@]}"; do
    echo "${ip_hisoblagich[$ip]} $ip"
done | sort -rn | head -20 | awk '{printf "%15s : %5d ta so'\''rov\n", $2, $1}'

echo ""
echo "Jami noyob IP: ${#ip_hisoblagich[@]}"
```

#### 4. So'z chastotasi tahlili

```bash
#!/bin/bash

declare -A soz_soni

FAYL="${1:-matn.txt}"

echo "Matn tahlil qilinmoqda: $FAYL"

# Matnni so'zlarga ajratish va sanash
while read -r qator; do
    # Tinish belgilarini olib tashlash, kichik harfga
    qator=$(echo "$qator" | tr -d '[:punct:]' | tr '[:upper:]' '[:lower:]')
    
    for soz in $qator; do
        ((soz_soni[$soz]++))
    done
done < "$FAYL"

echo ""
echo "=== ENG KO'P ISHLATILADIGAN 30 SO'Z ==="

for soz in "${!soz_soni[@]}"; do
    echo "${soz_soni[$soz]} $soz"
done | sort -rn | head -30 | nl | awk '{printf "%3d. %-20s : %5d marta\n", $1, $3, $2}'

echo ""
echo "Jami noyob so'zlar: ${#soz_soni[@]}"
```

#### 5. Menu tizimi (nested associative arrays simulation)

```bash
#!/bin/bash

# Menyu ma'lumotlari
declare -A taomlar_narx taomlar_kategoriya

# Ichimliklar
taomlar_kategoriya["choy"]="ichimlik"
taomlar_narx["choy"]="5000"

taomlar_kategoriya["kofe"]="ichimlik"
taomlar_narx["kofe"]="10000"

taomlar_kategoriya["sharbat"]="ichimlik"
taomlar_narx["sharbat"]="15000"

# Ovqatlar
taomlar_kategoriya["osh"]="ovqat"
taomlar_narx["osh"]="25000"

taomlar_kategoriya["lag'mon"]="ovqat"
taomlar_narx["lag'mon"]="20000"

taomlar_kategoriya["manti"]="ovqat"
taomlar_narx["manti"]="18000"

# Shirinliklar
taomlar_kategoriya["tort"]="shirinlik"
taomlar_narx["tort"]="12000"

taomlar_kategoriya["muzqaymoq"]="shirinlik"
taomlar_narx["muzqaymoq"]="8000"

# Buyurtmalar
declare -A buyurtmalar

menyuni_korish() {
    echo "=== MENYU ==="
    echo ""
    
    echo "🍵 ICHIMLIKLAR:"
    for taom in "${!taomlar_kategoriya[@]}"; do
        if [ "${taomlar_kategoriya[$taom]}" = "ichimlik" ]; then
            printf "  %-15s - %'6d so'm\n" "$taom" "${taomlar_narx[$taom]}"
        fi
    done
    
    echo ""
    echo "🍛 OVQATLAR:"
    for taom in "${!taomlar_kategoriya[@]}"; do
        if [ "${taomlar_kategoriya[$taom]}" = "ovqat" ]; then
            printf "  %-15s - %'6d so'm\n" "$taom" "${taomlar_narx[$taom]}"
        fi
    done
    
    echo ""
    echo "🍰 SHIRINLIKLAR:"
    for taom in "${!taomlar_kategoriya[@]}"; do
        if [ "${taomlar_kategoriya[$taom]}" = "shirinlik" ]; then
            printf "  %-15s - %'6d so'm\n" "$taom" "${taomlar_narx[$taom]}"
        fi
    done
}

buyurtma_berish() {
    read -p "Taom nomi: " taom
    
    if [ ! -v taomlar_narx["$taom"] ]; then
        echo "✗ Bunday taom yo'q"
        return
    fi
    
    read -p "Miqdori: " miqdor
    
    if [[ ! $miqdor =~ ^[0-9]+$ ]]; then
        echo "✗ Noto'g'ri miqdor"
        return
    fi
    
    if [ -v buyurtmalar["$taom"] ]; then
        buyurtmalar["$taom"]=$((buyurtmalar[$taom] + miqdor))
    else
        buyurtmalar["$taom"]=$miqdor
    fi
    
    echo "✓ Qo'shildi: $taom × $miqdor"
}

buyurtmalarni_korish() {
    if [ ${#buyurtmalar[@]} -eq 0 ]; then
        echo "Buyurtmalar yo'q"
        return
    fi
    
    echo "=== SIZNING BUYURTMANGIZ ==="
    jami=0
    
    for taom in "${!buyurtmalar[@]}"; do
        miqdor=${buyurtmalar[$taom]}
        narx=${taomlar_narx[$taom]}
        summa=$((narx * miqdor))
        printf "%-15s × %2d = %'8d so'm\n" "$taom" "$miqdor" "$summa"
        ((jami += summa))
    done
    
    echo "────────────────────────────"
    printf "%-20s %'8d so'm\n" "JAMI:" "$jami"
}

# Asosiy sikl
while true; do
    clear
    menyuni_korish
    echo ""
    buyurtmalarni_korish
    echo ""
    echo "1. Buyurtma berish"
    echo "2. Buyurtmani tozalash"
    echo "3. To'lash va chiqish"
    echo ""
    
    read -p "Tanlov: " tanlov
    
    case $tanlov in
        1)
            buyurtma_berish
            sleep 2
            ;;
        2)
            buyurtmalar=()
            echo "✓ Tozalandi"
            sleep 1
            ;;
        3)
            clear
            buyurtmalarni_korish
            echo ""
            echo "Rahmat! Yoqimli ishtaha!"
            exit 0
            ;;
    esac
done
```

### Array funksiyalari

```bash
#!/bin/bash

# Array ga element qo'shish
array_qoshish() {
    local -n arr=$1
    arr+=("$2")
}

# Array dan element o'chirish (qiymat bo'yicha)
array_ochirish() {
    local -n arr=$1
    local qiymat=$2
    local yangi=()
    
    for element in "${arr[@]}"; do
        if [ "$element" != "$qiymat" ]; then
            yangi+=("$element")
        fi
    done
    
    arr=("${yangi[@]}")
}

# Array da qidirish
array_qidir() {
    local -n arr=$1
    local qiymat=$2
    
    for element in "${arr[@]}"; do
        if [ "$element" = "$qiymat" ]; then
            return 0
        fi
    done
    
    return 1
}

# Array ni saralash
array_saralash() {
    local -n arr=$1
    IFS=$'\n' arr=($(sort <<<"${arr[*]}"))
    unset IFS
}

# Array ni teskari tartibda
array_teskari() {
    local -n arr=$1
    local yangi=()
    
    for ((i=${#arr[@]}-1; i>=0; i--)); do
        yangi+=("${arr[$i]}")
    done
    
    arr=("${yangi[@]}")
}

# Test
mevalar=("olma" "nok" "uzum" "anor")

echo "Asl: ${mevalar[@]}"

array_qoshish mevalar "gilos"
echo "Qo'shildi: ${mevalar[@]}"

array_saralash mevalar
echo "Saralandi: ${mevalar[@]}"

array_teskari mevalar
echo "Teskari: ${mevalar[@]}"

if array_qidir mevalar "uzum"; then
    echo "✓ uzum topildi"
fi

array_ochirish mevalar "nok"
echo "O'chirildi: ${mevalar[@]}"
```

### 📝 Vazifalar:

1. **Vazifa 1:** Oddiy array dan dublikatlarni olib tashlovchi funksiya yozing
2. **Vazifa 2:** Associative array yordamida talabalar bazasi yarating (ism → baho)
3. **Vazifa 3:** Ikki arrayni qiyoshlash funksiyasi - qaysi elementlar faqat birinchisida, faqat ikkinchisida va ikkalasida ham bor?
4. **Vazifa 4:** Log fayldan IP manzillarni olib, ularning soni bo'yicha statistika (associative array)
5. **Vazifa 5:** Shopping cart tizimi: mahsulotlar, narxlar va buyurtmalar (3 ta associative array)

---