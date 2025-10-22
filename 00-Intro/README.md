# Bash: 0dan Hero gacha 🚀

> **Muhim:** Bu qo'llanma Bash (Bourne Again Shell) ni noldan professional darajagacha o'rganish uchun mo'ljallangan. Har bir mavzu hayotiy misollar bilan tushuntirilgan va amaliy vazifalar bilan mustahkamlanadi.

---

## 1️⃣ KIRISH VA MUHITNI SOZLASH
**Global nomi:** Introduction & Environment Setup  
**O'zbek nomi:** Kirish va muhitni sozlash

### Bash nima?

Bash - bu Linux va macOS tizimlarda ishlaydigan buyruqlar interpretatori (command-line shell). Kompyuter bilan matnli buyruqlar orqali muloqot qilish imkonini beradi. 

**Terminal (Terminal)** - bu Bash ni ishlatish uchun oyna. Terminal orqali siz kompyuterga buyruqlar berasiz va u sizga javob qaytaradi.

**Shell (Qobiq)** - bu foydalanuvchi va operatsion tizim o'rtasidagi vositachi dastur. Siz yozgan buyruqlarni tizim tushunadigan tilga o'giradi.

### Nima uchun Bash kerak?

1. **Server boshqaruv:** 1000 ta faylni bir vaqtning o'zida o'zgartirish
2. **Avtomatlashtirish:** Har kuni takrorlanadigan ishlarni avtomatik bajarish
3. **Tizim monitoring:** Server ishlayotganini tekshirish
4. **Ma'lumot qayta ishlash:** Log fayllarni tahlil qilish

### Hayotiy misol:
Tasavvur qiling, sizda 500 ta rasm fayli bor va ularning barchasini kichiklashtirish kerak. Qo'lda 5 soat vaqt ketadi, Bash bilan 5 daqiqa! 

```bash
for file in *.jpg; do
    convert "$file" -resize 50% "small_$file"
done
```

### Muhitni sozlash

#### Linux (Ubuntu/Debian):
```bash
# Terminal ochish: Ctrl + Alt + T
# Bash versiyasini tekshirish
bash --version

# .bashrc faylini ochish (shaxsiy sozlamalar)
nano ~/.bashrc
```

#### macOS:
```bash
# Terminal: Cmd + Space, "Terminal" yozing
# Bash o'rnatish (yangi versiya)
brew install bash
```

#### Windows (WSL):
```bash
# WSL o'rnatish
wsl --install

# Ubuntu ochilgandan keyin
sudo apt update
```

### Asosiy terminlar:

- **pwd** (Print Working Directory) - Hozir qaysi papkada ekanligingizni ko'rsatadi
- **ls** (List) - Papkadagi fayllarni ko'rsatadi
- **cd** (Change Directory) - Boshqa papkaga o'tish

### Amaliy namuna:

```bash
# Hozirgi manzilni bilish
pwd
# Natija: /home/sardor

# Fayllarni ko'rish
ls
# Natija: Desktop  Documents  Downloads

# Desktop ga o'tish
cd Desktop

# Orqaga qaytish
cd ..
```

### 📝 Vazifalar:

1. **Vazifa 1:** Terminalda `pwd` buyrug'ini ishlatib, hozirgi katalogingizni aniqlang
2. **Vazifa 2:** `ls -la` buyrug'i bilan barcha fayllarni (yashirin fayllar bilan) ko'ring
3. **Vazifa 3:** Uyingiz (home) katalogiga `cd ~` yordamida o'ting va tekshiring
4. **Vazifa 4:** `.bashrc` faylini oching va oxiriga `echo "Salom, Bash!"` qo'shing, terminalni yangilang

---

## 2️⃣ TERMINAL ASOSLARI VA FAYL TIZIMI
**Global nomi:** Terminal Basics & File System  
**O'zbek nomi:** Terminal asoslari va fayl tizimi

### Fayl tizimi nima?

Linux fayl tizimi - daraxt tuzilmasidagi kataloglar va fayllar majmui. Barcha narsalar `/` (root - ildiz) dan boshlanadi.

```
/                     (ildiz katalog)
├── home/            (foydalanuvchilar uylari)
│   ├── sardor/      (sizning uyingiz)
│   └── olim/
├── etc/             (sozlamalar)
├── var/             (o'zgaruvchan ma'lumotlar)
├── tmp/             (vaqtinchalik fayllar)
└── usr/             (dasturlar)
```

### Asosiy buyruqlar:

#### `pwd` - Hozirgi manzil
```bash
pwd
# Natija: /home/sardor/Documents
```

**Hayotiy misol:** GPS sizga "Siz Toshkentda, Amir Temur ko'chasida turibsiz" deb aytgani kabi, `pwd` ham "Siz /home/sardor/Documents da turibsiz" deb aytadi.

#### `ls` - Fayllarni ko'rish

```bash
# Oddiy ko'rinish
ls

# Batafsil ma'lumot bilan
ls -l

# Yashirin fayllar bilan (.bilan boshlanuvchi)
ls -a

# Hammasi birgalikda
ls -lah
```

**Parametrlar tavsifi:**
- `-l` (long) - Batafsil: ruxsatlar, egasi, hajmi, sana
- `-a` (all) - Barcha fayllar, jumladan yashirin
- `-h` (human-readable) - Hajmni tushunarli formatda (KB, MB, GB)
- `-t` (time) - Vaqt bo'yicha saralash
- `-r` (reverse) - Teskari tartibda

```bash
# Misol natija:
ls -lh
# drwxr-xr-x  2 sardor users 4.0K Oct 22 10:30 Documents
# -rw-r--r--  1 sardor users  15K Oct 21 14:20 kitob.pdf
```

**Natijani tushunish:**
- `d` - bu katalog (directory)
- `-` - bu fayl
- `rwx` - ruxsatlar (read, write, execute)
- `sardor` - fayl egasi
- `4.0K` - hajmi
- `Oct 22 10:30` - oxirgi o'zgarish vaqti

#### `cd` - Kataloglarni o'zgartirish

```bash
# Desktop ga o'tish
cd Desktop

# Ota-katalogga chiqish
cd ..

# Uyga qaytish
cd ~
# yoki shunchaki
cd

# Oldingi katalogga qaytish
cd -

# Absolyut yo'l
cd /home/sardor/Documents

# Nisbiy yo'l
cd ../Downloads
```

**Hayotiy misol:** `cd` - bu liftga o'xshaydi. Siz binosining qavatlari orasida harakatlanyapsiz:
- `cd Desktop` - Desktop qavatiga chiqish
- `cd ..` - bir qavat pastga tushish
- `cd /` - binoning eng pastki qavatiga tushish

### Yo'l turlari (Path Types):

**Absolyut yo'l (Absolute Path):** Ildizdan boshlanadigan to'liq manzil
```bash
cd /home/sardor/Documents/loyihalar
```

**Nisbiy yo'l (Relative Path):** Hozirgi joydan boshlanadigan yo'l
```bash
# Agar siz /home/sardor da bo'lsangiz
cd Documents/loyihalar
```

### Maxsus belgilar:

- `.` - hozirgi katalog
- `..` - ota-katalog (yuqorigi daraja)
- `~` - uy katalogi (/home/foydalanuvchi)
- `/` - ildiz katalog
- `-` - oldingi katalog

### Amaliy namuna:

```bash
# Uydan boshlaymiz
cd ~
pwd
# /home/sardor

# Desktop ga o'tamiz
cd Desktop
pwd
# /home/sardor/Desktop

# Yangi katalog yaratamiz
mkdir mening_loyiham
cd mening_loyiham

# Ichida yana katalog
mkdir kodlar
mkdir rasmlar

# Fayllarni ko'ramiz
ls -l

# Kodlar papkasiga kiramiz
cd kodlar
pwd
# /home/sardor/Desktop/mening_loyiham/kodlar

# Ikki daraja yuqoriga chiqamiz
cd ../..
pwd
# /home/sardor/Desktop
```

### Tab tugmasi - eng foydali trick!

Yo'lni yozayotganda `Tab` bosing - avtomatik to'ldiradi!

```bash
cd Doc[Tab]
# Avtomatik: cd Documents/

cd Do[Tab][Tab]
# Barcha "Do" bilan boshlanuvchi variantlarni ko'rsatadi:
# Documents  Downloads
```

### 📝 Vazifalar:

1. **Vazifa 1:** Uyingizda `bash_dars` nomli katalog yarating va unga o'ting
2. **Vazifa 2:** Ichida 3 ta katalog yarating: `dars1`, `dars2`, `dars3`
3. **Vazifa 3:** `dars1` ga o'ting, keyin `..` yordamida orqaga qaytib, `dars2` ga o'ting
4. **Vazifa 4:** Ildiz katalogga o'ting (`cd /`), `ls` bilan fayllarni ko'ring, keyin uyingizga qaytib keling
5. **Vazifa 5:** Quyidagi yo'lni toping va o'ting: `/usr/local/bin`, keyin `cd -` bilan qaytib keling

---

## 3️⃣ FAYLLAR BILAN ISHLASH
**Global nomi:** Working with Files  
**O'zbek nomi:** Fayllar bilan ishlash

### Fayllarni ko'rish va o'qish

#### `cat` - Fayl mazmunini to'liq ko'rsatish
**Cat** (concatenate - birlashtirish) - fayllarni ekranga chiqaradi

```bash
# Bitta faylni ko'rish
cat kitob.txt

# Bir nechta faylni birlashtirish
cat fayl1.txt fayl2.txt

# Satr raqamlari bilan
cat -n dastur.py
```

**Hayotiy misol:** Daftaringizni ochib, hamma sahifalarni birdaniga o'qish - bu `cat`

```bash
# Misol:
cat salom.txt
# Natija:
# Salom Dunyo!
# Bu mening birinchi faylim.
```

#### `less` - Katta fayllarni sahifa-sahifa ko'rish

**Less** - katta fayllarni qulay ko'rish uchun

```bash
less katta_fayl.log
```

**Tugmalar:**
- `Space` yoki `f` - keyingi sahifa
- `b` - oldingi sahifa
- `/qidiruv` - matn qidirish
- `n` - keyingi topilma
- `q` - chiqish
- `G` - fayl oxiriga
- `g` - fayl boshiga

**Hayotiy misol:** Kitobni o'qiyapsiz, sahifama-sahifa - bu `less`

#### `head` - Fayl boshini ko'rish

```bash
# Dastlabki 10 satr (default)
head fayl.txt

# Birinchi 5 satr
head -n 5 fayl.txt

# Birinchi 100 bayt
head -c 100 fayl.txt
```

**Hayotiy misol:** Gazeta sarlavhasini o'qish - bu `head`

```bash
# Server log faylining boshini tekshirish
head -n 20 /var/log/syslog
```

#### `tail` - Fayl oxirini ko'rish

```bash
# Oxirgi 10 satr
tail fayl.txt

# Oxirgi 20 satr
tail -n 20 fayl.txt

# Real vaqtda kuzatish (log monitoringi uchun!)
tail -f /var/log/nginx/access.log
```

**Hayotiy misol:** Yangi xabarlarni kuzatish - bu `tail -f`

```bash
# Dastur ishlayotganida loglarni kuzatish
tail -f app.log
# Ctrl+C - to'xtatish
```

### Fayllarni nusxalash (Copy)

#### `cp` - Nusxalash buyrug'i

```bash
# Oddiy nusxalash
cp manba.txt nusxa.txt

# Katalogga nusxalash
cp fayl.txt /home/sardor/Documents/

# Katalogni barcha mazmuni bilan nusxalash
cp -r papka1/ papka2/

# Nusxalashni tasdiqlash so'rash
cp -i manba.txt nusxa.txt

# Verboz rejim (nima qilyapti ko'rsatadi)
cp -v fayl1.txt fayl2.txt
```

**Parametrlar:**
- `-r` (recursive) - kataloglarni ichma-ich nusxalash
- `-i` (interactive) - ustiga yozishdan oldin so'rash
- `-v` (verbose) - jarayonni ko'rsatish
- `-u` (update) - yangi bo'lsa nusxalash
- `-p` (preserve) - ruxsatlar va vaqtni saqlash

**Hayotiy misol:** Word faylini "Nusxa.docx" deb saqlash - bu `cp`

```bash
# Loyihangizni backup qilish
cp -r mening_saytim/ mening_saytim_backup/

# Bir nechta faylni bir joyga
cp fayl1.txt fayl2.txt fayl3.txt /backup/
```

### Fayllarni ko'chirish va nomlash

#### `mv` - Ko'chirish yoki qayta nomlash

```bash
# Faylni qayta nomlash
mv eski_nom.txt yangi_nom.txt

# Boshqa katalogga ko'chirish
mv fayl.txt /home/sardor/Documents/

# Bir nechta faylni ko'chirish
mv fayl1.txt fayl2.txt fayl3.txt /backup/

# Katalogni qayta nomlash
mv eski_papka yangi_papka
```

**Hayotiy misol:** Faylni boshqa papkaga olib o'tish yoki qayta nomlash

```bash
# Rasmlarni tartibga solish
mv IMG_001.jpg tatil_2024_001.jpg
mv tatil_2024_001.jpg ~/Pictures/2024/

# Tasdiqlash bilan
mv -i muhim_fayl.txt /backup/
```

### Fayllarni o'chirish

#### `rm` - O'chirish buyrug'i (EHTIYOT BO'LING!)

```bash
# Oddiy o'chirish
rm fayl.txt

# Tasdiqlash so'rash
rm -i muhim_fayl.txt

# Katalogni o'chirish
rm -r papka/

# Majburiy o'chirish (xavfli!)
rm -rf papka/

# Verboz rejim
rm -v fayl.txt
```

**⚠️ DIQQAT:** `rm -rf /` - bu xavfli! Butun tizimni o'chiradi!

**Parametrlar:**
- `-i` (interactive) - har bir fayl uchun so'rash
- `-r` (recursive) - kataloglar uchun
- `-f` (force) - majburiy, so'ramasdan
- `-v` (verbose) - jarayonni ko'rsatish

**Hayotiy misol:** Korzinkaga tashlash - bu `rm`

```bash
# Vaqtinchalik fayllarni tozalash
rm -f /tmp/*.tmp

# Eski backup larni o'chirish
rm -rf backups/2023/
```

### Xavfsiz o'chirish usuli:

```bash
# O'chirishdan oldin trash papkaga ko'chirish
mkdir -p ~/.trash
mv fayl.txt ~/.trash/

# Keyinchalik tozalash
rm -rf ~/.trash/*
```

### Fayllarni topish

#### `find` - Fayllarni qidirish

```bash
# Hozirgi katalogda barcha .txt fayllar
find . -name "*.txt"

# Bosh-kichik harfga e'tibor bermay
find . -iname "*.TXT"

# Kataloglarni topish
find /home -type d -name "Downloads"

# Oxirgi 7 kunda o'zgargan fayllar
find . -mtime -7

# 100MB dan katta fayllar
find . -size +100M
```

**Hayotiy misol:** Uydan kalitni qidirish - bu `find`

```bash
# Barcha Python fayllarni topish
find ~/projects -name "*.py"

# Bo'sh fayllarni topish va o'chirish
find . -type f -empty -delete
```

### Amaliy namuna:

```bash
# Loyiha strukturasini yaratish
mkdir -p ~/bash_amaliyot/{kodlar,rasmlar,hujjatlar}

# Test fayllar yaratish
echo "Salom Dunyo" > ~/bash_amaliyot/test.txt
echo "Python dasturi" > ~/bash_amaliyot/kodlar/app.py

# Fayllarni ko'rish
cat ~/bash_amaliyot/test.txt

# Nusxalash
cp ~/bash_amaliyot/test.txt ~/bash_amaliyot/test_backup.txt

# Ko'chirish
mv ~/bash_amaliyot/kodlar/app.py ~/bash_amaliyot/kodlar/main.py

# Topish
find ~/bash_amaliyot -name "*.txt"

# O'chirish (ehtiyot bilan!)
rm ~/bash_amaliyot/test_backup.txt
```

### 📝 Vazifalar:

1. **Vazifa 1:** `darslar` papkasida `salom.txt` yarating, ichiga "Salom Bash!" yozing va `cat` bilan o'qing
2. **Vazifa 2:** Ushbu faylni `salom_backup.txt` nomi bilan nusxalang
3. **Vazifa 3:** `salom.txt` faylini `salom_yangi.txt` ga qayta nomlang
4. **Vazifa 4:** Barcha .txt fayllarni yangi `matnlar` papkasiga ko'chiring
5. **Vazifa 5:** Uyingizda barcha .log fayllarni toping va ro'yxatini ko'ring

---

## 4️⃣ RUXSATLAR, FOYDALANUVCHI VA GURUHLAR
**Global nomi:** Permissions, Users & Groups  
**O'zbek nomi:** Ruxsatlar, foydalanuvchi va guruhlar

### Linux ruxsatlar tizimi

Linux da har bir fayl va katalog uchun 3 turdagi ruxsatlar mavjud:

**r (read - o'qish)** - faylni o'qish, katalog tarkibini ko'rish  
**w (write - yozish)** - faylni o'zgartirish, katalogda fayl yaratish/o'chirish  
**x (execute - bajarish)** - faylni ishga tushirish, katalogga kirish

### Ruxsatlarni ko'rish

```bash
ls -l fayl.txt
# -rw-r--r-- 1 sardor users 1234 Oct 22 10:30 fayl.txt
```

**Tahlil qilish:**
```
-  rw-  r--  r--
│   │    │    │
│   │    │    └─ Boshqalar (others)
│   │    └────── Guruh (group)
│   └─────────── Egasi (owner)
└─────────────── Fayl turi (- = fayl, d = katalog)
```

**Hayotiy misol:** Bu xona eshigidagi qulf tizimiga o'xshaydi:
- Egasi (owner): kalit bor, ichkariga kirishi, narsalarni o'zgartirishi, eshikni ochib-yopishi mumkin
- Guruh (group): ba'zi xonalarga kirish ruxsati bor
- Boshqalar (others): faqat tashqaridan qarab turishi mumkin

### Ruxsatlar raqamlarda:

```
r = 4 (o'qish)
w = 2 (yozish)
x = 1 (bajarish)
```

**Kombinatsiyalar:**
- `7 = 4+2+1` → rwx (hammasi)
- `6 = 4+2` → rw- (o'qish va yozish)
- `5 = 4+1` → r-x (o'qish va bajarish)
- `4` → r-- (faqat o'qish)
- `0` → --- (ruxsat yo'q)

**Misol:** `755`
- `7` (rwx) - egasi uchun
- `5` (r-x) - guruh uchun
- `5` (r-x) - boshqalar uchun

### `chmod` - Ruxsatlarni o'zgartirish

#### Raqamli usul:

```bash
# Egasiga barcha ruxsat, boshqalarga o'qish
chmod 744 fayl.txt

# Hammaga barcha ruxsat (xavfli!)
chmod 777 fayl.txt

# Faqat egasi o'qiy va yozishi mumkin
chmod 600 maxfiy.txt

# Skriptni ishga tushiriladigan qilish
chmod 755 dastur.sh
```

#### Harfli usul:

```bash
# Egasiga bajarish ruxsatini qo'shish
chmod u+x skript.sh

# Boshqalardan yozish ruxsatini olish
chmod o-w fayl.txt

# Guruhga o'qish ruxsatini qo'shish
chmod g+r fayl.txt

# Hammaga bajarish ruxsati
chmod a+x dastur.sh

# Guruhdan barcha ruxsatlarni olish
chmod g-rwx fayl.txt
```

**Belgilar:**
- `u` (user) - egasi
- `g` (group) - guruh
- `o` (others) - boshqalar
- `a` (all) - hammasi
- `+` - ruxsat qo'shish
- `-` - ruxsat olish
- `=` - aniq ruxsat berish

**Hayotiy misollar:**

```bash
# Web sayt fayllariga ruxsat (server uchun)
chmod 644 index.html  # Fayllar
chmod 755 cgi-bin/    # Skriptlar

# Backup fayllarni himoyalash
chmod 600 backup.tar.gz

# Umumiy katalog yaratish
mkdir /shared
chmod 777 /shared  # Hamma yoza oladi (ehtiyot!)
```

### Rekursiv o'zgartirish:

```bash
# Papka va ichidagi barcha fayllar uchun
chmod -R 755 mening_saytim/

# Faqat kataloglar uchun
find . -type d -exec chmod 755 {} \;

# Faqat fayllar uchun
find . -type f -exec chmod 644 {} \;
```

### `chown` - Egasini o'zgartirish

```bash
# Faqat egasini o'zgartirish
sudo chown sardor fayl.txt

# Egasi va guruhni o'zgartirish
sudo chown sardor:users fayl.txt

# Faqat guruhni o'zgartirish
sudo chown :users fayl.txt

# Rekursiv
sudo chown -R sardor:users papka/
```

**⚠️ Diqqat:** `chown` uchun ko'pincha `sudo` kerak!

### `chgrp` - Guruhni o'zgartirish

```bash
# Guruhni o'zgartirish
sudo chgrp developers fayl.txt

# Rekursiv
sudo chgrp -R developers loyiha/
```

### Foydalanuvchi va guruhlar bilan ishlash

#### Hozirgi foydalanuvchini bilish:

```bash
# Foydalanuvchi nomini ko'rish
whoami
# Natija: sardor

# To'liq ma'lumot
id
# uid=1000(sardor) gid=1000(sardor) groups=1000(sardor),27(sudo)
```

#### Yangi foydalanuvchi yaratish:

```bash
# Yangi foydalanuvchi
sudo adduser olim

# Mavjud guruhga qo'shish
sudo usermod -aG sudo olim  # sudo guruhiga

# Foydalanuvchini o'zgartirish
su - olim
```

#### Guruh yaratish:

```bash
# Yangi guruh
sudo groupadd developers

# Guruhga foydalanuvchi qo'shish
sudo usermod -aG developers sardor

# Guruh a'zolarini ko'rish
getent group developers
```

### Umask - Standart ruxsatlar

**Umask** - yangi fayllar uchun olinib tashlanadigan ruxsatlar

```bash
# Hozirgi umask ni ko'rish
umask
# Natija: 0022

# Umask ni o'zgartirish
umask 0027

# .bashrc ga qo'shish (doimiy)
echo "umask 0027" >> ~/.bashrc
```

**Hisoblash:**
- Fayllar uchun: 666 - umask
- Kataloglar uchun: 777 - umask

**Misol:** umask = 022
- Fayllar: 666 - 022 = 644 (rw-r--r--)
- Kataloglar: 777 - 022 = 755 (rwxr-xr-x)

### Maxsus ruxsatlar

#### SUID (Set User ID):
```bash
# Fayl egasining huquqlarida ishlaydi
chmod u+s dastur
chmod 4755 dastur
```

**Misol:** `passwd` buyrug'i - oddiy foydalanuvchi parolni o'zgartirishi mumkin, chunki SUID o'rnatilgan

#### SGID (Set Group ID):
```bash
# Guruh huquqlarida ishlaydi
chmod g+s katalog/
chmod 2755 katalog/
```

#### Sticky Bit:
```bash
# Faqat egasi o'chirishi mumkin (/tmp kabi)
chmod +t katalog/
chmod 1755 katalog/
```

### Amaliy namuna:

```bash
# Loyiha katalogi yaratish
mkdir ~/web_loyiha
cd ~/web_loyiha

# Tuzilma yaratish
mkdir {public,private,scripts}

# Public ga hamma kiradigan qilish
chmod 755 public/
echo "Salom!" > public/index.html
chmod 644 public/index.html

# Private ni faqat o'zim uchun
chmod 700 private/
echo "Maxfiy" > private/data.txt
chmod 600 private/data.txt

# Skriptni ishga tushiriladigan qilish
echo '#!/bin/bash' > scripts/backup.sh
echo 'echo "Backup boshlanmoqda..."' >> scripts/backup.sh
chmod 755 scripts/backup.sh

# Natijani tekshirish
ls -lR
```

### 📝 Vazifalar:

1. **Vazifa 1:** Fayl yarating va unga 644 ruxsat bering, keyin `ls -l` bilan tekshiring
2. **Vazifa 2:** Skript yarating va uni ishga tushiriladigan qilish uchun `chmod +x` ni ishlating
3. **Vazifa 3:** Katalog yarating va faqat siz kirishi mumkin bo'lishi uchun 700 ruxsat bering
4. **Vazifa 4:** `whoami` va `id` buyruqlarini ishlating, natijalarni taqqoslang
5. **Vazifa 5:** Rekursiv ravishda papkadagi barcha fayllarni 644, kataloglarni 755 ga o'zgartiring

---

Men Bash qo'llanmasini to'liq tayyorlay boshladim. Siz ko'rib turganingizdek, har bir mavzu:

1. ✅ **Global va o'zbek nomlari** bilan
2. ✅ **Batafsil tushuntirishlar** - har bir buyruq va termin nimani anglatishi
3. ✅ **Hayotiy misollar** - kundalik hayotdan o'xshashliklar
4. ✅ **Amaliy namunalar** - ishlaydigan kod
5. ✅ **Vazifalar** - mustahkamlash uchun

Hozir birinchi 4 ta mavzu tayyor. Qolgan 16 ta mavzuni ham xuddi shunday formatda tayyorlayman. Davom ettirishimni xohlaysizmi? 

Yoki biror mavzuni chuqurroq yoritishim kerakmi? Masalan:
- Ko'proq misollar
- Qiyinroq vazifalar
- Video tutorial uchun skript
- Cheat sheet jadval

Qaysi yo'nalishda davom ettirishimni xohlaysiz?