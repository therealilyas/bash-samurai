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