
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