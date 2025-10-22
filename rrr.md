

## 1️⃣2️⃣ PIPE VA FILTRLAR (grep, awk, sed, cut, sort, uniq)
**Global nomi:** Pipes and Filters  
**O'zbek nomi:** Pipe va filtrlar

### Pipe (|) nima?

Pipe - bu bir buyruqning natijasini boshqa buyruqqa uzatish. Konveyer lentasidek.

**Hayotiy misol:** Zavod konveyeri - har bir ishchi o'z ishini qiladi va keyingisiga uzatadi. Birinchisi kesadi, ikkinchisi bo'yaydi, uchinchisi qadoqlaydi.

```bash
# Oddiy pipe
ls | wc -l                # Fayllar sonini sanash

# Ko'p pipe
cat fayl.txt | grep "muhim" | sort | uniq
```

### grep - Qidirish filtri

`grep` - matndan kerakli qatorlarni topish.

**Global pattern:** grep = Global Regular Expression Print

#### Asosiy ishlatish:

```bash
# Oddiy qidirish
grep "qidiruv" fayl.txt

# Katta-kichik harfga e'tibor bermay
grep -i "qidiruv" fayl.txt

# Butun so'zni qidirish
grep -w "test" fayl.txt

# Qator raqami bilan
grep -n "xato" log.txt

# Invers (ushbu so'z BO'LMAGAN qatorlar)
grep -v "spam" email.txt

# Rekursiv (barcha fayllarda)
grep -r "TODO" /project/

# Faqat fayl nomlari
grep -l "error" *.log

# Faqat sonini ko'rsatish
grep -c "success" log.txt
```

**Hayotiy misollar:**

```bash
# IP manzillarni topish
grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' access.log

# Email topish
grep -E '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' users.txt

# Xatolarni filtrlash
grep -i "error\|warning\|critical" system.log

# Kontekst bilan (oldingi va keyingi qatorlar)
grep -C 3 "exception" app.log    # 3 ta qator oldin va keyin
grep -B 2 "error" app.log         # 2 ta qator oldin
grep -A 5 "error" app.log         # 5 ta qator keyin
```

**Pipe bilan:**
```bash
# Fayllar ichidan qidirish
ls -la | grep "\.txt$"

# Process topish
ps aux | grep "nginx"

# Active userlar
who | grep -v "^$"

# Log dan IP lar
cat access.log | grep "404" | awk '{print $1}' | sort | uniq
```

### awk - Matn qayta ishlash tili

`awk` - ustunlar bilan ishlash uchun kuchli vosita.

#### Asosiy tushunchalar:

- `$1, $2, $3` - ustunlar (bo'sh joy yoki tab bilan ajratilgan)
- `$0` - butun qator
- `NR` - qator raqami
- `NF` - ustunlar soni

```bash
# Birinchi ustunni chiqarish
awk '{print $1}' fayl.txt

# Bir nechta ustun
awk '{print $1, $3}' fayl.txt

# Maxsus format
awk '{print "Ism:", $1, "Yosh:", $2}' users.txt

# Hisob-kitoblar
awk '{sum += $1} END {print "Jami:", sum}' raqamlar.txt
```

**Hayotiy misollar:**

```bash
# Disk hajmini ko'rish (faqat foiz)
df -h | awk 'NR>1 {print $5, $6}'

# RAM ishlatilishi
free -m | awk 'NR==2 {printf "%.2f%%\n", $3/$2*100}'

# CSV dan ustun olish
awk -F',' '{print $2}' data.csv

# Log dan IP va vaqt
awk '{print $1, $4}' access.log

# Shartli chiqarish
awk '$3 > 100 {print $1, $3}' sales.txt    # 3-ustun 100 dan katta

# Bir nechta shart
awk '$3 > 50 && $4 == "active" {print $0}' users.txt
```

**Murakkab misollar:**

```bash
# Jami va o'rtacha
awk '{sum+=$1; count++} END {print "Jami:", sum, "O'rtacha:", sum/count}' numbers.txt

# Top 10 IP
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# CSV ni HTML jadvalga
awk -F',' 'BEGIN {print "<table>"} 
             {print "<tr><td>" $1 "</td><td>" $2 "</td></tr>"} 
             END {print "</table>"}' data.csv
```

### sed - Matn tahrirlovchi

`sed` - Stream EDitor, matnni qayta ishlash va o'zgartirish uchun.

#### Asosiy buyruqlar:

```bash
# Almashtirish (birinchi uchraganini)
sed 's/eski/yangi/' fayl.txt

# Barcha uchraganlarini almashtirish
sed 's/eski/yangi/g' fayl.txt

# Katta-kichik harfga e'tibor bermay
sed 's/eski/yangi/gi' fayl.txt

# Faylni o'zgartirish (-i)
sed -i 's/eski/yangi/g' fayl.txt

# Ma'lum qatorni o'chirish
sed '3d' fayl.txt                 # 3-qatorni o'chirish
sed '1,5d' fayl.txt               # 1-5 qatorlarni o'chirish
sed '/pattern/d' fayl.txt         # Pattern bo'lgan qatorlarni

# Qatorlarni chiqarish
sed -n '1,10p' fayl.txt           # Faqat 1-10 qatorlar
sed -n '/pattern/p' fayl.txt      # Faqat pattern bo'lgan qatorlar
```

**Hayotiy misollar:**

```bash
# IP manzilni almashtirish
sed 's/192.168.1.1/10.0.0.1/g' config.txt

# Izohlarni o'chirish
sed '/^#/d' skript.sh

# Bo'sh qatorlarni o'chirish
sed '/^$/d' fayl.txt

# Qator boshiga qo'shish
sed 's/^/PREFIX: /' fayl.txt

# Qator oxiriga qo'shish
sed 's/$/ - SUFFIX/' fayl.txt

# Ma'lum qatordan keyin qo'shish
sed '/pattern/a\Yangi qator' fayl.txt

# Ma'lum qatordan oldin qo'shish
sed '/pattern/i\Yangi qator' fayl.txt

# Qatorni almashtirish
sed '/pattern/c\Yangi matn' fayl.txt
```

**Murakkab misollar:**

```bash
# HTML teglarni o'chirish
sed 's/<[^>]*>//g' index.html

# Email maskirovka
sed 's/\([a-z]\)[a-z]*@/\1***@/g' emails.txt
# sardor@example.com → s***@example.com

# Raqamlarni format qilish
sed 's/\([0-9]\{3\}\)\([0-9]\{3\}\)\([0-9]\{4\}\)/\1-\2-\3/' phones.txt
# 9981234567 → 998-123-4567

# Bir nechta almashtirish
sed -e 's/foo/bar/g' -e 's/hello/salom/g' fayl.txt

# Config faylni yangilash
sed -i.backup 's/^port=.*/port=8080/' config.ini
```

### cut - Ustunlarni kesish

```bash
# Ma'lum ustunni olish (bo'sh joy bilan)
cut -d' ' -f1 fayl.txt            # Birinchi ustun

# Bir nechta ustun
cut -d',' -f1,3 data.csv          # 1 va 3-ustunlar

# Diapazon
cut -d':' -f1-3 /etc/passwd       # 1 dan 3 gacha

# Belgilar pozitsiyasi bo'yicha
cut -c1-10 fayl.txt               # Birinchi 10 ta belgi
```

**Hayotiy misollar:**

```bash
# Foydalanuvchi nomlari
cut -d':' -f1 /etc/passwd

# CSV dan email
cut -d',' -f3 users.csv

# Log dan vaqt
cut -d' ' -f4,5 access.log

# PATH ni ajratish
echo $PATH | tr ':' '\n'
```

### sort - Saralash

```bash
# Alifbo tartibida
sort fayl.txt

# Teskari tartibda
sort -r fayl.txt

# Raqamli tartibda
sort -n numbers.txt

# Ma'lum ustun bo'yicha
sort -k2 fayl.txt                 # 2-ustun bo'yicha
sort -t',' -k3 data.csv           # Vergul bilan, 3-ustun

# Unique + sort
sort -u fayl.txt                  # Dublikatlarni olib tashlash

# Katta-kichik harfga e'tibor bermay
sort -f fayl.txt

# Inson o'qiy oladigan raqamlar (1K, 1M)