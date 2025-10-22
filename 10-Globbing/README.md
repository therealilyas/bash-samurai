## 🔟 TO'LDIRISH (GLOBBING), TIZIMLI BUYRUQLAR VA SUBSHELL
**Global nomi:** Globbing, System Commands & Subshells  
**O'zbek nomi:** To'ldirish, tizimli buyruqlar va subshell

### Globbing (Wildcard Patterns)

Globbing - fayllarni naqsh (pattern) bo'yicha tanlash usuli.

**Hayotiy misol:** Do'konda "Barcha qizil ko'ylaklar" deb so'rash - aniq nomini bilmasangiz ham, xususiyati bo'yicha topasiz.

#### Asosiy belgilar:

```bash
# * - istalgan belgilar (0 yoki ko'p)
ls *.txt              # Barcha .txt fayllar
ls file*              # file bilan boshlanuvchi
ls *report*           # Ichida report so'zi bor

# ? - bitta belgi
ls file?.txt          # file1.txt, filea.txt
ls ???.txt            # Aniq 3 harfli nomlar

# [] - belgilar to'plami
ls file[123].txt      # file1.txt, file2.txt, file3.txt
ls [a-z]*.txt         # Kichik harf bilan boshlanuvchi
ls [A-Z]*.txt         # Katta harf bilan boshlanuvchi
ls file[!0-9].txt     # Raqam bilan boshlanMAYDIGAN

# {} - variantlar
ls {file1,file2}.txt  # file1.txt va file2.txt
ls file{1..5}.txt     # file1.txt dan file5.txt gacha
mv file.{txt,bak}     # file.txt ni file.bak ga
```

**Amaliy misollar:**

```bash
# Barcha Python fayllarni ko'rish
ls *.py

# 2024 yil fayllarini topish
ls *2024*.txt

# Rasmlarni nusxalash
cp *.{jpg,png,gif} /backup/

# Test fayllarini o'chirish
rm test*.txt

# 3 harfli nomlarda
ls ???.sh

# A yoki B bilan boshlanuvchi
ls [AB]*.txt
```

#### Globbing sozlamalari:

```bash
# Katta-kichik harfga e'tibor bermaslik
shopt -s nocaseglob
ls *.TXT              # .txt va .TXT ni topadi

# Yashirin fayllarni ham qo'shish
shopt -s dotglob
ls *                  # .bashrc ham ko'rinadi

# O'chirish
shopt -u nocaseglob
shopt -u dotglob
```

**Hayotiy loyiha: Fayl tashkilotchisi**

```bash
#!/bin/bash

echo "=== FAYLLARNI TARTIBGA SOLISH ==="

# Rasmlar
if ls *.{jpg,png,gif,jpeg} 2>/dev/null; then
    mkdir -p Rasmlar
    mv *.{jpg,png,gif,jpeg} Rasmlar/ 2>/dev/null
    echo "✓ Rasmlar → Rasmlar/"
fi

# Hujjatlar
if ls *.{pdf,doc,docx,txt} 2>/dev/null; then
    mkdir -p Hujjatlar
    mv *.{pdf,doc,docx,txt} Hujjatlar/ 2>/dev/null
    echo "✓ Hujjatlar → Hujjatlar/"
fi

# Videolar
if ls *.{mp4,avi,mkv,mov} 2>/dev/null; then
    mkdir -p Videolar
    mv *.{mp4,avi,mkv,mov} Videolar/ 2>/dev/null
    echo "✓ Videolar → Videolar/"
fi

# Arxivlar
if ls *.{zip,tar,gz,rar} 2>/dev/null; then
    mkdir -p Arxivlar
    mv *.{zip,tar,gz,rar} Arxivlar/ 2>/dev/null
    echo "✓ Arxivlar → Arxivlar/"
fi

echo "Tayyor!"
```

### Tizimli buyruqlar

#### `command` - Buyruqni ishlatish

```bash
# Alias o'rniga asl buyruqni ishlatish
alias ls='ls --color=auto'
command ls           # Alizsiz ls

# Buyruq mavjudligini tekshirish
if command -v git &> /dev/null; then
    echo "Git o'rnatilgan"
else
    echo "Git yo'q"
fi
```

#### `which` va `type` - Buyruq joyini topish

```bash
# Buyruq qayerda
which bash           # /bin/bash
which python3        # /usr/bin/python3

# Buyruq turi
type ls              # ls is aliased to 'ls --color=auto'
type cd              # cd is a shell builtin
type python          # python is /usr/bin/python

# Hamma joylarini ko'rish
type -a python
```

#### `exec` - Joriy shellni almashtirish

```bash
# Yangi dastur bilan almashish
exec bash            # Yangi bash ochiladi

# Faylga yo'naltirish
exec > output.log    # Barcha echo lar faylga yoziladi
exec 2> error.log    # Barcha xatolar
```

**Ehtiyot:** `exec` joriy shellni tugatadi!

#### `eval` - Satrni buyruq sifatida bajarish

```bash
buyruq="ls -l"
eval $buyruq         # ls -l ni bajaradi

# O'zgaruvchi nomini dinamik yaratish
for i in {1..3}; do
    eval "o'zgaruvchi_$i=Qiymat$i"
done

echo $o'zgaruvchi_1  # Qiymat1
echo $o'zgaruvchi_2  # Qiymat2
```

**⚠️ Xavfsizlik:** `eval` xavfli! Foydalanuvchi kiritmasini eval qilmang!

### Subshell

Subshell - bu yangi shell jarayoni, asosiy shelldan alohida.

#### Subshell yaratish:

```bash
# () - qavslar subshell yaratadi
(cd /tmp; ls)        # /tmp ga o'tadi, ls ni bajaradi
pwd                  # Hali eski joydasiz!

# Oddiy buyruq
cd /tmp; ls
pwd                  # Endi /tmp dasiz
```

**Hayotiy misol:** Vaqtincha boshqa joyga borish kerak, lekin hozirgi joyni saqlab qolish.

#### Subshell va o'zgaruvchilar:

```bash
#!/bin/bash

o'zgaruvchi="Tashqarida"

(
    o'zgaruvchi="Ichkarida"
    echo "Subshell: $o'zgaruvchi"    # Ichkarida
)

echo "Asosiy: $o'zgaruvchi"          # Tashqarida
```

Subshell ichidagi o'zgarishlar tashqariga ta'sir qilmaydi!

#### Subshell foydasi:

```bash
# 1. Vaqtinchalik sozlamalar
(
    set -e  # Faqat subshell uchun
    xavfli_buyruq
)

# 2. Parallel ishlatish
{
    (sleep 2; echo "Birinchi") &
    (sleep 1; echo "Ikkinchi") &
    (sleep 3; echo "Uchinchi") &
    wait
}

# Natija:
# Ikkinchi
# Birinchi
# Uchinchi

# 3. Murakkab output
natija=$(
    echo "Qator 1"
    echo "Qator 2"
    echo "Qator 3"
)
echo "$natija"
```

### Command substitution

Buyruq natijasini o'zgaruvchiga saqlash:

```bash
# $() - zamonaviy usul (tavsiya)
hozir=$(date +%H:%M)
fayllar=$(ls | wc -l)

# `` - eski usul
hozir=`date +%H:%M`
```

**Ichma-ich:**
```bash
# $() oson o'qiladi
foydalanuvchilar=$(cat /etc/passwd | grep $(whoami))

# `` bilan qiyin
foydalanuvchilar=`cat /etc/passwd | grep \`whoami\``
```

**Amaliy misollar:**

```bash
# 1. Sana bilan fayl nomlash
backup_fayl="backup_$(date +%Y%m%d).tar.gz"

# 2. Dinamik menyular
tanlov=$(cat << EOF
1. Fayl yaratish
2. Fayl o'chirish  
3. Chiqish
EOF
)

# 3. Tizim ma'lumotlari
echo "CPU: $(nproc) yadro"
echo "RAM: $(free -h | awk 'NR==2 {print $2}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $4}') bo'sh"
```

### Process substitution

Buyruq natijasini fayl kabi ishlatish:

```bash
# <() - buyruq natijasi fayl sifatida
diff <(ls dir1) <(ls dir2)

# Misol: Ikkita ro'yxatni solishtirish
comm <(sort fayl1.txt) <(sort fayl2.txt)

# Parallel o'qish
while read qator1 && read qator2 <&3; do
    echo "$qator1 | $qator2"
done < fayl1.txt 3< fayl2.txt
```

**Hayotiy misol: Loglarni taqqoslash**

```bash
#!/bin/bash

# Bugungi va kechagi loglarni taqqoslash
BUGUN=$(date +%Y-%m-%d)
KECHA=$(date -d "yesterday" +%Y-%m-%d)

diff <(grep ERROR log_$KECHA.txt | cut -d' ' -f5) \
     <(grep ERROR log_$BUGUN.txt | cut -d' ' -f5)

echo "Yangi xatolar ko'rsatildi"
```

### Background va job control

```bash
# & - background da ishlatish
sleep 10 &           # Orqa fonda 10 soniya kutadi
long_command &

# jobs - orqa fon jarayonlarini ko'rish
jobs

# fg - oldingi o'tkazish
fg                   # Oxirgi jobni oldinga
fg %1                # 1-jobni oldinga

# bg - background da davom ettirish
bg %1

# Ctrl+Z - to'xtatish
# Ctrl+C - to'xtatish va tugatish

# wait - barcha backgroundlarni kutish
sleep 5 &
sleep 3 &
wait
echo "Hammasi tugadi"
```

**Parallel qayta ishlash:**

```bash
#!/bin/bash

echo "=== PARALLEL QAYTA ISHLASH ==="

# Har bir fayl uchun alohida process
for fayl in *.txt; do
    (
        # Murakkab qayta ishlash
        echo "Boshlanmoqda: $fayl"
        sleep 2  # Ishlov berish simulyatsiyasi
        echo "Tugadi: $fayl"
    ) &
done

# Hammasi tugashini kutish
wait

echo "Barcha fayllar qayta ishlandi!"
```

### Amaliy loyiha: Parallel backup tizimi

```bash
#!/bin/bash

BACKUP_DIR="/backup/$(date +%Y-%m-%d)"
LOG_FAYL="backup.log"

mkdir -p "$BACKUP_DIR"

backup_katalog() {
    local manba=$1
    local nomi=$(basename "$manba")
    
    echo "[$(date +%H:%M:%S)] Boshlanmoqda: $nomi" | tee -a "$LOG_FAYL"
    
    tar -czf "$BACKUP_DIR/${nomi}.tar.gz" "$manba" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "[$(date +%H:%M:%S)] ✓ Tugadi: $nomi" | tee -a "$LOG_FAYL"
    else
        echo "[$(date +%H:%M:%S)] ✗ Xato: $nomi" | tee -a "$LOG_FAYL"
    fi
}

echo "=== BACKUP BOSHLANDI ===" | tee "$LOG_FAYL"
echo "Vaqt: $(date)" | tee -a "$LOG_FAYL"
echo "" | tee -a "$LOG_FAYL"

# Parallel backup
KATALOGLAR=(
    "$HOME/Documents"
    "$HOME/Pictures"
    "$HOME/Projects"
    "$HOME/Videos"
)

for katalog in "${KATALOGLAR[@]}"; do
    if [ -d "$katalog" ]; then
        backup_katalog "$katalog" &
    fi
done

# Hammasi tugashini kutish
wait

echo "" | tee -a "$LOG_FAYL"
echo "=== BACKUP TUGADI ===" | tee -a "$LOG_FAYL"

# Statistika
jami=$(ls -1 "$BACKUP_DIR" | wc -l)
hajm=$(du -sh "$BACKUP_DIR" | cut -f1)

echo "Fayllar: $jami" | tee -a "$LOG_FAYL"
echo "Hajm: $hajm" | tee -a "$LOG_FAYL"
```

### 📝 Vazifalar:

1. **Vazifa 1:** Barcha .txt fayllarni topib, har birining qator sonini hisoblovchi skript (globbing)
2. **Vazifa 2:** Subshell dan foydalanib, 3 ta katalogning har birida alohida amallarni bajaring
3. **Vazifa 3:** Command substitution bilan tizim ma'lumotlarini to'plab, HTML hisobot yarating
4. **Vazifa 4:** Bir nechta faylni parallel ravishda arxivlovchi dastur yozing
5. **Vazifa 5:** Foydalanuvchidan katalog so'rang, ichidagi fayllarni turi bo'yicha guruhlang (rasmlar, hujjatlar, video)

---