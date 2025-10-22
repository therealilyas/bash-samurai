
## 6️⃣ ARIFMETIK VA SATR AMALLAR
**Global nomi:** Arithmetic and String Operations  
**O'zbek nomi:** Arifmetik va satr amallar

### Arifmetik amallar

Bash da raqamlar bilan ishlash uchun bir nechta usullar mavjud.

#### 1. **$(( )) - Arithmetic Expansion**

Eng qulay va tez usul:

```bash
# Asosiy amallar
a=10
b=3

qoshish=$((a + b))         # 13
ayirish=$((a - b))         # 7
kopaytirish=$((a * b))     # 30
bolish=$((a / b))          # 3 (butun son)
qoldiq=$((a % b))          # 1 (10 ni 3 ga bo'lganda qoldiq)
daraja=$((a ** 2))         # 100 (10 ning kvadrati)

echo "Qo'shish: $qoshish"
echo "Ayirish: $ayirish"
echo "Ko'paytirish: $kopaytirish"
echo "Bo'lish: $bolish"
echo "Qoldiq: $qoldiq"
echo "Daraja: $daraja"
```

**Hayotiy misol: To'lov kalkulyatori**
```bash
#!/bin/bash

mahsulot_narxi=25000
soni=5
chegirma=10  # foiz

# Umumiy summa
umumiy=$((mahsulot_narxi * soni))

# Chegirma miqdori
chegirma_summa=$((umumiy * chegirma / 100))

# Yakuniy to'lov
tolov=$((umumiy - chegirma_summa))

echo "Mahsulot: ${mahsulot_narxi} so'm × ${soni}"
echo "Umumiy: ${umumiy} so'm"
echo "Chegirma (${chegirma}%): -${chegirma_summa} so'm"
echo "To'lov: ${tolov} so'm"
```

#### 2. **let - Arifmetik tayinlash**

```bash
let a=5+3        # a=8
let "a = 5 + 3"  # a=8 (bo'sh joy bilan)

let a++          # a ni 1 ga oshirish
let a--          # a ni 1 ga kamaytirish
let a+=5         # a ga 5 qo'shish
let a-=3         # a dan 3 ayirish
let a*=2         # a ni 2 ga ko'paytirish
let a/=2         # a ni 2 ga bo'lish

# Misol
son=10
let son++
echo $son        # 11
```

**Hayotiy misol: Hisoblagich**
```bash
#!/bin/bash

hisoblagich=0

for i in {1..10}; do
    let hisoblagich++
    echo "Hisob: $hisoblagich"
done
```

#### 3. **expr - Tashqi dastur**

Eski usul, zaif:

```bash
a=10
b=3

qoshish=$(expr $a + $b)         # 13
kopaytirish=$(expr $a \* $b)    # 30 (* ni escape qilish kerak)

echo $qoshish
```

⚠️ **expr** sekin ishlaydi, $(( )) afzalroq!

#### 4. **bc - Kalkulator (o'nlik sonlar uchun)**

Bash faqat butun sonlar bilan ishlaydi. O'nlik sonlar uchun `bc` kerak:

```bash
# Oddiy hisob-kitob
echo "10.5 + 3.7" | bc          # 14.2

# Aniqlikni belgilash
echo "scale=2; 10 / 3" | bc     # 3.33
echo "scale=4; 22 / 7" | bc     # 3.1428

# Murakkab amallar
natija=$(echo "scale=2; (10 + 5) * 3.5 / 2" | bc)
echo $natija                     # 26.25
```

**Hayotiy misol: Valyuta konvertori**
```bash
#!/bin/bash

sum=1000000
kurs=12500.50

dollar=$(echo "scale=2; $sum / $kurs" | bc)
echo "${sum} so'm = \$${dollar}"
# Natija: 1000000 so'm = $80.00
```

### Taqqoslash operatorlari

#### Raqamlar uchun:

```bash
a=10
b=20

# Tenglik
[ $a -eq $b ]    # equal (teng)
[ $a -ne $b ]    # not equal (teng emas)

# Katta-kichiklik
[ $a -gt $b ]    # greater than (katta)
[ $a -ge $b ]    # greater or equal (katta yoki teng)
[ $a -lt $b ]    # less than (kichik)
[ $a -le $b ]    # less or equal (kichik yoki teng)

# Misollar
if [ $a -lt $b ]; then
    echo "$a < $b"
fi
```

**Hayotiy misol: Yosh tekshirish**
```bash
#!/bin/bash

read -p "Yoshingiz: " yosh

if [ $yosh -lt 18 ]; then
    echo "Voyaga yetmagan"
elif [ $yosh -ge 18 ] && [ $yosh -lt 65 ]; then
    echo "Kattalar"
else
    echo "Pensioner"
fi
```

### Satr (String) amallar

#### Satrlarni birlashtirish

```bash
# Oddiy birlashtirish
ism="Sardor"
familiya="Aliyev"
toliq="$ism $familiya"
echo $toliq                    # Sardor Aliyev

# Ketma-ket yozish
fayl="hujjat"
kengaytma=".txt"
toliq_nom="${fayl}${kengaytma}"
echo $toliq_nom                # hujjat.txt

# += operatori
matn="Salom"
matn+=" Dunyo"
matn+="!"
echo $matn                     # Salom Dunyo!
```

**Hayotiy misol: URL yaratish**
```bash
#!/bin/bash

protokol="https"
domen="example.com"
yo'l="/api/users"
parametr="?id=123"

url="${protokol}://${domen}${yo'l}${parametr}"
echo $url
# https://example.com/api/users?id=123
```

#### Satr uzunligi

```bash
matn="Assalomu alaykum"
uzunlik=${#matn}
echo "Uzunlik: $uzunlik belgi"    # 17 belgi

# Bo'sh satrni tekshirish
if [ ${#matn} -eq 0 ]; then
    echo "Satr bo'sh"
fi
```

#### Satrni tekshirish

```bash
matn="Salom Dunyo"

# Bo'sh emasligini tekshirish
[ -n "$matn" ]    # true agar to'ldirilgan bo'lsa

# Bo'shligini tekshirish
[ -z "$matn" ]    # true agar bo'sh bo'lsa

# Teng ekanligini tekshirish
[ "$matn" = "Salom Dunyo" ]      # =
[ "$matn" == "Salom Dunyo" ]     # == (xuddi shu)
[ "$matn" != "Salom" ]           # teng emas

# Misol
if [ -n "$matn" ]; then
    echo "Satr to'ldirilgan"
fi
```

#### Satrni qidirish

```bash
matn="Bu Bash darsligi"

# Ichida borligini tekshirish
if [[ $matn == *"Bash"* ]]; then
    echo "Bash so'zi topildi"
fi

# Boshlanishini tekshirish
if [[ $matn == Bu* ]]; then
    echo "Bu bilan boshlanadi"
fi

# Tugashini tekshirish
if [[ $matn == *darsligi ]]; then
    echo "darsligi bilan tugaydi"
fi
```

**Hayotiy misol: Email validatsiya**
```bash
#!/bin/bash

read -p "Email: " email

if [[ $email == *@*.* ]]; then
    echo "✓ Email to'g'ri formatda"
else
    echo "✗ Noto'g'ri email!"
fi
```

#### Satrni kesish

```bash
matn="Assalomu alaykum"

# Pozitsiya bo'yicha
echo ${matn:0:8}       # Assalomu (0 dan 8 ta belgi)
echo ${matn:9}         # alaykum (9 dan oxirigacha)
echo ${matn: -7}       # alaykum (oxirgi 7 ta)

# Pattern bo'yicha
fayl="papka/ichki/hujjat.txt"

# Eng qisqa moslikni o'chirish (oldidan)
echo ${fayl#*/}        # ichki/hujjat.txt

# Eng uzun moslikni o'chirish (oldidan)
echo ${fayl##*/}       # hujjat.txt

# Eng qisqa moslikni o'chirish (orqadan)
echo ${fayl%/*}        # papka/ichki

# Eng uzun moslikni o'chirish (orqadan)
echo ${fayl%%/*}       # papka
```

**Hayotiy misol: Fayl nomi va kengaytma**
```bash
#!/bin/bash

fayl_yo'li="/home/user/Documents/maqola.pdf"

# Faqat fayl nomi
fayl_nomi="${fayl_yo'li##*/}"
echo "Fayl: $fayl_nomi"            # maqola.pdf

# Kengaytmasiz
asosiy="${fayl_nomi%.*}"
echo "Asosiy: $asosiy"              # maqola

# Faqat kengaytma
kengaytma="${fayl_nomi##*.}"
echo "Kengaytma: $kengaytma"        # pdf

# Katalog yo'li
katalog="${fayl_yo'li%/*}"
echo "Katalog: $katalog"            # /home/user/Documents
```

#### Satrni almashtirish

```bash
matn="Salom Dunyo, Dunyo go'zal"

# Birinchi uchraganini almashtirish
echo ${matn/Dunyo/Olam}
# Salom Olam, Dunyo go'zal

# Barcha uchraganlarini almashtirish
echo ${matn//Dunyo/Olam}
# Salom Olam, Olam go'zal

# Boshidan almashtirish
fayl="test.txt.txt"
echo ${fayl/#test/yangi}
# yangi.txt.txt

# Oxiridan almashtirish
echo ${fayl/%txt/md}
# test.txt.md
```

**Hayotiy misol: Log tozalash**
```bash
#!/bin/bash

log="[ERROR] 2025-10-22 Server stopped"

# ERROR ni WARNING ga o'zgartirish
yangi_log="${log/ERROR/WARNING}"
echo $yangi_log
# [WARNING] 2025-10-22 Server stopped

# Sanani o'chirish
tozalangan="${log//[0-9]/}"
echo $tozalangan
# [ERROR] -- Server stopped
```

#### Katta-kichik harflar

```bash
matn="Salom Dunyo"

# Hammasi katta
echo ${matn^^}             # SALOM DUNYO

# Hammasi kichik
echo ${matn,,}             # salom dunyo

# Birinchi harf katta
echo ${matn^}              # Salom dunyo

# Birinchi harf kichik
echo ${matn,}              # salom Dunyo

# Ma'lum harflarni o'zgartirish
echo ${matn^^[sd]}         # Salom Dunyo → Salom Dunyo
```

**Hayotiy misol: Username generatori**
```bash
#!/bin/bash

read -p "Ismingiz: " ism
read -p "Familiyangiz: " familiya

# Kichik harflarga
username="${ism,,}.${familiya,,}"
echo "Username: $username"
# Sardor Aliyev → sardor.aliyev
```

### Amaliy loyiha: Oddiy kalkulator

```bash
#!/bin/bash

echo "=== KALKULATOR ==="
echo "1. Qo'shish"
echo "2. Ayirish"
echo "3. Ko'paytirish"
echo "4. Bo'lish"
echo "5. Daraja"
echo "=================="

read -p "Tanlov (1-5): " tanlov
read -p "Birinchi son: " son1
read -p "Ikkinchi son: " son2

case $tanlov in
    1)
        natija=$((son1 + son2))
        amal="+"
        ;;
    2)
        natija=$((son1 - son2))
        amal="-"
        ;;
    3)
        natija=$((son1 * son2))
        amal="×"
        ;;
    4)
        if [ $son2 -eq 0 ]; then
            echo "Xato: 0 ga bo'lib bo'lmaydi!"
            exit 1
        fi
        natija=$(echo "scale=2; $son1 / $son2" | bc)
        amal="÷"
        ;;
    5)
        natija=$((son1 ** son2))
        amal="^"
        ;;
    *)
        echo "Noto'g'ri tanlov!"
        exit 1
        ;;
esac

echo ""
echo "Natija: $son1 $amal $son2 = $natija"
```

### 📝 Vazifalar:

1. **Vazifa 1:** 2 ta sonni qo'shib, ayirib, ko'paytirib, bo'ladigan skript yozing
2. **Vazifa 2:** Doira maydonini hisoblovchi dastur (S = π × r²)
3. **Vazifa 3:** Berilgan satrda nechta belgi borligini hisoblovchi skript
4. **Vazifa 4:** Fayl nomidan kengaytmani ajratib, yangisini qo'shadigan dastur
5. **Vazifa 5:** Matnda ma'lum so'zni sanab, boshqa so'z bilan almashtiradigan skript
