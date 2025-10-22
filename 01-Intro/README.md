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