
# **Bash Elektron Kitob — 0 dan Advanced gacha**

---

## **2. Terminal Basics and File System (Terminal asoslari va fayl tizimi)**

### Mavzu nima?

Linux fayl tizimi **daraxt shaklida** tuzilgan, root katalogi `/` dan boshlanadi. Fayllar va kataloglar bu daraxtning “barglari va novdalari”.

---

### Joriy katalogni ko‘rish

```bash
pwd
```

* `pwd` = Print Working Directory
* Hayotiy misol: Siz o‘zingizning xonangizda turibsiz va “men qayerdaman?” deb so‘rayapsiz – `pwd` shu ishni qiladi.

---

### Fayllarni ro‘yxatlash

```bash
ls        # Fayllar ro‘yxati
ls -l     # Batafsil ro‘yxat (ruxsatlar, egasi, hajmi)
ls -a     # Yashirin fayllar
```

**Hayotiy misol:**

* `ls` – shkafdagi kiyimlarni ko‘rsatadi
* `ls -l` – kiyimning turi, rangi, hajmi ko‘rinadi
* `ls -a` – yashirin kiyimlar ham ko‘rinadi

---

### Kataloglar bilan ishlash

```bash
cd /path    # Belgilangan katalogga o'tish
cd ~        # Uy katalogiga qaytish
cd ..       # Bir daraja yuqoriga
```

**Hayotiy misol:**

* `cd ..` – xonadan chiqib, oldingi xonaga o‘tish

---

## **3. Working with Files (Fayllar bilan ishlash: cat, less, head, tail, cp, mv, rm)**

### Mavzu nima?

Fayllar bilan ishlash – har qanday operatsion tizimning asosiy qismi. Siz fayl yaratishingiz, ichidagi ma’lumotni ko‘rishingiz, nusxalashingiz va o‘chirishingiz mumkin.

---

### Fayl mazmunini ko‘rish

```bash
cat file.txt       # Faylni bir vaqtning o'zida ko‘rsatadi
less file.txt      # Faylni sahifalab ko‘rsatadi
head -n 5 file.txt # Fayl boshidan 5 qator
tail -n 5 file.txt # Fayl oxiridan 5 qator
```

**Hayotiy misol:**

* `cat` – butun kitobni bir qarashda o‘qish
* `less` – sahifa-sahifa o‘qish
* `head` – kitobning kirish qismi
* `tail` – kitobning oxirgi qismi

---

### Faylni nusxalash, ko‘chirish, o‘chirish

```bash
cp file.txt backup.txt
mv file.txt newfile.txt
rm old_file.txt
```

**Hayotiy misol:**

* `cp` – qog‘oz nusxasini qilish
* `mv` – qog‘ozni boshqa joyga ko‘chirish
* `rm` – qog‘ozni tashlash

---

### Amaliy mashq

1. `example.txt` faylini yarating va 5 qator yozing
2. `head` va `tail` bilan faylning boshini va oxirini ko‘ring
3. Faylni `copy_example.txt` ga nusxalash
4. Asl faylni o‘chiring

**Output misol:**

```
$ head -n 2 example.txt
Line 1
Line 2
$ tail -n 2 example.txt
Line 4
Line 5
```

---

## **4. Permissions, Users and Groups (Ruxsatlar, foydalanuvchi va guruhlar)**

### Mavzu nima?

Linuxda har bir fayl va katalog uchun **kim o‘qishi, yozishi va bajarishi mumkinligi** aniqlanadi.

* **r** = Read (o‘qish)
* **w** = Write (yozish)
* **x** = Execute (bajarish)

```bash
ls -l file.txt
```

* Natija: `-rw-r--r-- 1 ilyas users 123 Oct 22 15:00 file.txt`
* `-rw-r--r--` – ruxsatlar
* `ilyas` – fayl egasi
* `users` – guruh

---

### Ruxsatlarni o‘zgartirish

```bash
chmod +x script.sh
chmod 644 file.txt
```

**Hayotiy misol:**

* `chmod +x` – faylni bajariladigan qilish, masalan, uyali telefonning ilovasini ishlatishga ruxsat berish

---

### Foydalanuvchi va guruh

```bash
whoami          # Joriy foydalanuvchi
groups          # Guruhlar ro'yxati
```

**Hayotiy misol:**

* `whoami` – xonadagi kim ekanligingizni so‘rash
* `groups` – siz qaysi guruhga mansub ekanligingizni ko‘rsatadi

---

## **5. Variables and Types (O‘zgaruvchilar va turlari)**

### Mavzu nima?

Bashda **o‘zgaruvchilar** ma’lumotlarni saqlash uchun ishlatiladi.

* **String (matn)** – harf yoki so‘zlar
* **Integer (butun son)** – raqamlar
* **Readonly (o‘zgarmas)** – bir marta berilgan qiymat o‘zgarmaydi

---

### Oddiy o‘zgaruvchi

```bash
name="Ilyas"
echo $name
```

* `$name` – o‘zgaruvchi qiymatini chiqaradi

**Hayotiy misol:**

* Siz xonadagi qutiga “kitob” deb yozasiz. Har safar “qutidagi narsani” so‘rasangiz, u kitobni ko‘rsatadi.

---

### Raqamli o‘zgaruvchi

```bash
a=5
b=7
sum=$((a+b))
echo $sum
```

**Hayotiy misol:**

* Sizda 5 olma va 7 nok bor, ularni qo‘shasiz va jami 12 meva borligini bilasiz

---

### Doimiy o‘zgaruvchi

```bash
readonly PI=3.14
echo $PI
```

* Bu qiymat o‘zgarmaydi


**Hayotiy misol:**

* PI doimiy matematik qiymat, uni o‘zgartirib bo‘lmaydi

---

Men xohlaysizmi, men shu uslubda **6–21 bo‘limlarni ham batafsil yozib, har bir terminni hayotiy misol bilan tushuntirib, kod va amaliy mashqlar bilan** davom ettiray?

Agar ha desangiz, men butun elektron kitobni shu tarzda to‘liq tayyorlab beraman.
