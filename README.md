

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

---

## 7️⃣ SHART OPERATORLARI (if, case)
**Global nomi:** Conditional Statements  
**O'zbek nomi:** Shart operatorlari

### if - Agar shunday bo'lsa

`if` - bu qaror qabul qilish mexanizmi. "Agar shunday bo'lsa, buni qil" mantiqida ishlaydi.

**Hayotiy misol:** Agar yomg'ir yog'sa, soyabon oling. Aks holda, odatdagidek yuring.

#### Asosiy sintaksis:

```bash
if [ shart ]; then
    # shart to'g'ri bo'lsa bajariladigan kod
fi
```

**Oddiy misol:**
```bash
#!/bin/bash

yosh=20

if [ $yosh -ge 18 ]; then
    echo "Siz kattasiz"
fi
```

#### if-else - Aks holda

```bash
if [ shart ]; then
    # to'g'ri bo'lsa
else
    # noto'g'ri bo'lsa
fi
```

**Misol:**
```bash
#!/bin/bash

read -p "Yoshingiz: " yosh

if [ $yosh -ge 18 ]; then
    echo "✓ Siz ovoz berish huquqiga egasiz"
else
    echo "✗ Siz hali voyaga yetmagansiz"
fi
```

#### if-elif-else - Ko'p shartlar

```bash
if [ shart1 ]; then
    # shart1 to'g'ri
elif [ shart2 ]; then
    # shart2
if [ shart1 ]; then
    # shart1 to'g'ri
elif [ shart2 ]; then
    # shart2 to'g'ri
elif [ shart3 ]; then
    # shart3 to'g'ri
else
    # hech biri to'g'ri emas
fi
```

**Hayotiy misol: Baho tizimi**
```bash
#!/bin/bash

read -p "Balingiz (0-100): " bal

if [ $bal -ge 90 ]; then
    echo "A'lo (5)"
elif [ $bal -ge 70 ]; then
    echo "Yaxshi (4)"
elif [ $bal -ge 50 ]; then
    echo "Qoniqarli (3)"
else
    echo "Qoniqarsiz (2)"
fi
```

### Test operatorlari

Bash da shartlarni tekshirish uchun 3 xil yozuv bor:

```bash
# 1. test buyrug'i
test $a -eq $b

# 2. [ ] - bir kvadrat qavs (tavsiya etiladi)
[ $a -eq $b ]

# 3. [[ ]] - ikki kvadrat qavs (zamonaviy, kuchliroq)
[[ $a -eq $b ]]
```

**Farqi:**
- `[ ]` - POSIX standart, barcha shellda ishlaydi
- `[[ ]]` - Bash ning kengaytirilgan versiyasi, qulayroq

#### Raqamlarni taqqoslash:

```bash
a=10
b=20

[ $a -eq $b ]    # equal - teng
[ $a -ne $b ]    # not equal - teng emas
[ $a -lt $b ]    # less than - kichik
[ $a -le $b ]    # less or equal - kichik yoki teng
[ $a -gt $b ]    # greater than - katta
[ $a -ge $b ]    # greater or equal - katta yoki teng
```

**Misol:**
```bash
#!/bin/bash

read -p "Oy raqamini kiriting (1-12): " oy

if [ $oy -lt 1 ] || [ $oy -gt 12 ]; then
    echo "Xato: Oy 1 dan 12 gacha bo'lishi kerak!"
elif [ $oy -ge 3 ] && [ $oy -le 5 ]; then
    echo "Bahor"
elif [ $oy -ge 6 ] && [ $oy -le 8 ]; then
    echo "Yoz"
elif [ $oy -ge 9 ] && [ $oy -le 11 ]; then
    echo "Kuz"
else
    echo "Qish"
fi
```

#### Satrlarni taqqoslash:

```bash
str1="salom"
str2="xayr"

# [ ] bilan
[ "$str1" = "$str2" ]     # teng (= yoki ==)
[ "$str1" != "$str2" ]    # teng emas
[ -z "$str1" ]            # bo'sh
[ -n "$str1" ]            # bo'sh emas

# [[ ]] bilan (qulayroq)
[[ $str1 == $str2 ]]      # teng
[[ $str1 != $str2 ]]      # teng emas
[[ $str1 < $str2 ]]       # alfavit bo'yicha kichik
[[ $str1 > $str2 ]]       # alfavit bo'yicha katta
[[ -z $str1 ]]            # bo'sh
[[ -n $str1 ]]            # bo'sh emas
```

⚠️ **Muhim:** [ ] da qo'shtirnoq kerak, [[ ]] da shart emas!

**Xato:**
```bash
str=""
[ $str = "test" ]    # XATO! Bo'sh o'zgaruvchi
```

**To'g'ri:**
```bash
str=""
[ "$str" = "test" ]    # TO'G'RI
[[ $str = "test" ]]    # Yoki shunday (qo'shtirnoqsiz)
```

**Hayotiy misol: Parol tekshirish**
```bash
#!/bin/bash

PAROL="qwerty123"

read -sp "Parolni kiriting: " kiritilgan
echo ""

if [[ $kiritilgan == $PAROL ]]; then
    echo "✓ Kirish muvaffaqiyatli!"
else
    echo "✗ Noto'g'ri parol!"
fi
```

#### Pattern matching (namuna bilan solishtrish)

`[[ ]]` bilan wildcard ishlatish mumkin:

```bash
fayl="hujjat.txt"

# txt bilan tugashi
if [[ $fayl == *.txt ]]; then
    echo "Bu matn fayli"
fi

# test bilan boshlanishi
if [[ $fayl == test* ]]; then
    echo "Test fayli"
fi

# Ichida ma'lum so'z bormi
if [[ $fayl == *hujjat* ]]; then
    echo "Hujjat fayli topildi"
fi
```

**Hayotiy misol: Fayl turi aniqlash**
```bash
#!/bin/bash

read -p "Fayl nomini kiriting: " fayl

if [[ $fayl == *.jpg ]] || [[ $fayl == *.png ]]; then
    echo "📷 Bu rasm fayli"
elif [[ $fayl == *.mp4 ]] || [[ $fayl == *.avi ]]; then
    echo "🎬 Bu video fayli"
elif [[ $fayl == *.mp3 ]]; then
    echo "🎵 Bu audio fayli"
elif [[ $fayl == *.txt ]] || [[ $fayl == *.doc ]]; then
    echo "📄 Bu hujjat fayli"
else
    echo "❓ Noma'lum fayl turi"
fi
```

### Fayllarni tekshirish

```bash
# Fayl mavjudligi
[ -e fayl.txt ]      # exists - mavjud
[ -f fayl.txt ]      # regular file - oddiy fayl
[ -d katalog ]       # directory - katalog
[ -L simlink ]       # symbolic link - simvolik havola
[ -s fayl.txt ]      # size > 0 - hajmi 0 dan katta

# Ruxsatlar
[ -r fayl.txt ]      # readable - o'qish mumkin
[ -w fayl.txt ]      # writable - yozish mumkin
[ -x skript.sh ]     # executable - ishga tushirish mumkin

# Taqqoslash
[ fayl1 -nt fayl2 ]  # newer than - yangi
[ fayl1 -ot fayl2 ]  # older than - eski
```

**Hayotiy misol: Fayl mavjudligini tekshirish**
```bash
#!/bin/bash

read -p "Fayl nomini kiriting: " fayl

if [ ! -e "$fayl" ]; then
    echo "✗ Fayl topilmadi!"
    exit 1
fi

if [ -f "$fayl" ]; then
    echo "✓ Bu oddiy fayl"
    
    if [ -r "$fayl" ]; then
        echo "  - O'qish mumkin"
    fi
    
    if [ -w "$fayl" ]; then
        echo "  - Yozish mumkin"
    fi
    
    if [ -x "$fayl" ]; then
        echo "  - Ishga tushirish mumkin"
    fi
    
    if [ -s "$fayl" ]; then
        hajm=$(du -h "$fayl" | cut -f1)
        echo "  - Hajmi: $hajm"
    else
        echo "  - Bo'sh fayl"
    fi
    
elif [ -d "$fayl" ]; then
    echo "✓ Bu katalog"
fi
```

### Mantiqiy operatorlar

#### AND (va) - && yoki -a

```bash
# [[ ]] bilan (tavsiya)
if [[ $yosh -ge 18 && $yosh -le 65 ]]; then
    echo "Ishchi yoshda"
fi

# [ ] bilan
if [ $yosh -ge 18 ] && [ $yosh -le 65 ]; then
    echo "Ishchi yoshda"
fi

# Yoki shunday
if [ $yosh -ge 18 -a $yosh -le 65 ]; then
    echo "Ishchi yoshda"
fi
```

#### OR (yoki) - || yoki -o

```bash
# [[ ]] bilan
if [[ $fayl == *.txt || $fayl == *.md ]]; then
    echo "Matn fayli"
fi

# [ ] bilan
if [ $fayl = "test.txt" ] || [ $fayl = "demo.txt" ]; then
    echo "Test fayli"
fi

# Yoki shunday
if [ $fayl = "test.txt" -o $fayl = "demo.txt" ]; then
    echo "Test fayli"
fi
```

#### NOT (inkor) - ! 

```bash
# Bo'sh emasligini tekshirish
if [ -n "$matn" ]; then
    echo "To'ldirilgan"
fi

# Yoki NOT bilan
if [ ! -z "$matn" ]; then
    echo "To'ldirilgan"
fi

# Fayl mavjud emasligini tekshirish
if [ ! -f "fayl.txt" ]; then
    echo "Fayl yo'q"
fi
```

**Hayotiy misol: Login tizimi**
```bash
#!/bin/bash

read -p "Username: " user
read -sp "Password: " pass
echo ""

if [[ $user == "admin" && $pass == "secret123" ]]; then
    echo "✓ Admin sifatida kirdingiz"
elif [[ $user == "guest" || -z $pass ]]; then
    echo "✓ Mehmon sifatida kirdingiz"
elif [[ -z $user || -z $pass ]]; then
    echo "✗ Username va password kiritish shart!"
else
    echo "✗ Noto'g'ri ma'lumotlar!"
fi
```

### case - Ko'p variantli tanlov

`case` - bu bir o'zgaruvchini ko'p qiymatlar bilan solishtirish uchun qulay usul. `if-elif-elif-elif-else` dan osonroq.

**Hayotiy misol:** Menyudan tanlov - siz 1, 2, 3 yoki 4 ni bosishingiz mumkin.

#### Sintaksis:

```bash
case $o'zgaruvchi in
    variant1)
        # variant1 uchun kod
        ;;
    variant2)
        # variant2 uchun kod
        ;;
    *)
        # boshqa holatlarda
        ;;
esac
```

**Oddiy misol:**
```bash
#!/bin/bash

read -p "Sizning javobingiz (ha/yo'q): " javob

case $javob in
    ha|Ha|HA|yes|YES)
        echo "✓ Tasdiqlandi"
        ;;
    yo'q|Yo'q|YO'Q|no|NO)
        echo "✗ Bekor qilindi"
        ;;
    *)
        echo "❓ Tushunmadim. 'ha' yoki 'yo'q' deb yozing"
        ;;
esac
```

**Ko'p variantlar:** `|` belgisi bilan bir nechta variantni birlashtirish mumkin.

#### Hayotiy misol: Menyu tizimi

```bash
#!/bin/bash

echo "=== MENYU ==="
echo "1. Fayllar ro'yxati"
echo "2. Hozirgi katalog"
echo "3. Disk holati"
echo "4. Tizim ma'lumoti"
echo "5. Chiqish"
echo "=============="

read -p "Tanlovingiz (1-5): " tanlov

case $tanlov in
    1)
        echo "Fayllar:"
        ls -lh
        ;;
    2)
        echo "Hozirgi katalog:"
        pwd
        ;;
    3)
        echo "Disk holati:"
        df -h
        ;;
    4)
        echo "Tizim:"
        uname -a
        ;;
    5)
        echo "Xayr!"
        exit 0
        ;;
    *)
        echo "Noto'g'ri tanlov! 1-5 oralig'ida kiriting."
        exit 1
        ;;
esac
```

#### Pattern matching case da

`case` da wildcard ishlashadi:

```bash
#!/bin/bash

read -p "Fayl nomini kiriting: " fayl

case $fayl in
    *.txt)
        echo "📄 Matn fayli"
        ;;
    *.jpg|*.png|*.gif)
        echo "🖼️  Rasm fayli"
        ;;
    *.mp3|*.wav)
        echo "🎵 Audio fayl"
        ;;
    *.sh)
        echo "⚙️  Bash skripti"
        ;;
    *.zip|*.tar|*.gz)
        echo "📦 Arxiv fayli"
        ;;
    test*)
        echo "🧪 Test fayli"
        ;;
    *[0-9]*)
        echo "🔢 Nomi raqam o'z ichiga oladi"
        ;;
    *)
        echo "❓ Noma'lum turi"
        ;;
esac
```

#### Hayotiy loyiha: Fayl boshqaruv tizimi

```bash
#!/bin/bash

echo "=== FAYL BOSHQARUVI ==="
echo "1. Fayl yaratish"
echo "2. Fayl o'chirish"
echo "3. Fayl nusxalash"
echo "4. Fayl ko'chirish"
echo "5. Fayl ko'rish"
echo "6. Chiqish"
echo "======================="

read -p "Tanlov: " tanlov

case $tanlov in
    1)
        read -p "Fayl nomi: " nom
        touch "$nom"
        echo "✓ $nom yaratildi"
        ;;
    2)
        read -p "O'chiriladigan fayl: " nom
        if [ -f "$nom" ]; then
            rm -i "$nom"
            echo "✓ O'chirildi"
        else
            echo "✗ Fayl topilmadi"
        fi
        ;;
    3)
        read -p "Manba fayl: " manba
        read -p "Nusxa nomi: " nusxa
        if [ -f "$manba" ]; then
            cp "$manba" "$nusxa"
            echo "✓ Nusxalandi: $manba → $nusxa"
        else
            echo "✗ Manba topilmadi"
        fi
        ;;
    4)
        read -p "Ko'chiriladigan fayl: " manba
        read -p "Yangi joy: " manzil
        if [ -f "$manba" ]; then
            mv "$manba" "$manzil"
            echo "✓ Ko'chirildi: $manba → $manzil"
        else
            echo "✗ Fayl topilmadi"
        fi
        ;;
    5)
        read -p "Ko'riladigan fayl: " nom
        if [ -f "$nom" ]; then
            echo "--- $nom ---"
            cat "$nom"
        else
            echo "✗ Fayl topilmadi"
        fi
        ;;
    6)
        echo "Xayr!"
        exit 0
        ;;
    *)
        echo "✗ Noto'g'ri tanlov!"
        exit 1
        ;;
esac
```

### Qisqa if (ternary operator o'rniga)

Bash da ternary operator yo'q, lekin shunday yozish mumkin:

```bash
# Oddiy if
if [ $a -gt $b ]; then
    echo "A katta"
else
    echo "B katta"
fi

# Qisqa usul
[ $a -gt $b ] && echo "A katta" || echo "B katta"
```

**⚠️ Ehtiyot:** Bu usul har doim ham to'g'ri ishlamasligi mumkin!

**Xavfsiz variant:**
```bash
natija=$([ $a -gt $b ] && echo "A katta" || echo "B katta")
echo $natija
```

### Amaliy loyiha: Server monitoring

```bash
#!/bin/bash

echo "=== SERVER MONITORING ==="

# CPU yuklanishi
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
cpu_int=${cpu%.*}

if [ $cpu_int -lt 50 ]; then
    echo "✓ CPU: ${cpu}% - Normal"
elif [ $cpu_int -lt 80 ]; then
    echo "⚠ CPU: ${cpu}% - Yuqori"
else
    echo "✗ CPU: ${cpu}% - Kritik!"
fi

# RAM
ram=$(free | grep Mem | awk '{print int($3/$2 * 100)}')

if [ $ram -lt 70 ]; then
    echo "✓ RAM: ${ram}% - Normal"
elif [ $ram -lt 90 ]; then
    echo "⚠ RAM: ${ram}% - Yuqori"
else
    echo "✗ RAM: ${ram}% - Kritik!"
fi

# Disk
disk=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)

if [ $disk -lt 80 ]; then
    echo "✓ Disk: ${disk}% - Normal"
elif [ $disk -lt 95 ]; then
    echo "⚠ Disk: ${disk}% - To'lib borayapti"
else
    echo "✗ Disk: ${disk}% - To'ldi!"
fi

# Xulosa
if [ $cpu_int -ge 80 ] || [ $ram -ge 90 ] || [ $disk -ge 95 ]; then
    echo ""
    echo "⚠️  DIQQAT: Tizimda muammo!"
else
    echo ""
    echo "✅ Hammasi yaxshi"
fi
```

### 📝 Vazifalar:

1. **Vazifa 1:** Foydalanuvchidan son so'rang va juft yoki toq ekanligini aniqlang
2. **Vazifa 2:** 3 ta sondan eng kattasini topuvchi skript yozing
3. **Vazifa 3:** Fayl mavjudligini, o'qish/yozish ruxsatini tekshiruvchi dastur
4. **Vazifa 4:** Case bilan hafta kunlarini kiritsa, ish kuni/dam olish kunini aniqlovchi skript
5. **Vazifa 5:** Login tizimi: username va password so'rasin, 3 marta noto'g'ri kiritsa bloklsin

---

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