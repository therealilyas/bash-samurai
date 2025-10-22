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