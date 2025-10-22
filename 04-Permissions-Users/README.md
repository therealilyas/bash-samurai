

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