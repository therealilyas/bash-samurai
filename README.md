
## 1. Kirish va muhiti sozlash

**Bash nima?**  
Bash — Linux va Unix tizimlarida keng tarqalgan qobiq (shell). U buyruqlarni qabul qiladi, skriptlarni bajaradi va tizim bilan interaktiv aloqa qiladi.

**Muhit o'zgaruvchilari va fayllar:**

- `~/.bashrc` — interaktiv terminal ishga tushganda  
- `~/.bash_profile` — login shell ishga tushganda  
- `/etc/bash.bashrc` — global sozlamalar  

```bash
export MY_VAR="Salom"
echo $MY_VAR
````

**Misol (index_example.sh):**

```bash
#!/usr/bin/env bash
echo "Salom, Bash!"
```

**Vazifa (hello.sh):**
Terminalda `hello.sh` faylini yaratib, ichiga `echo "Salom, Bash!"` yozing va ishga tushuring.

**Kutilgan output:**

```
Salom, Bash!
```

---

## 2. Terminal asoslari va fayl tizimi

**Asosiy buyruqlar:**

| Buyruq | Ma'no                      |
| ------ | -------------------------- |
| pwd    | Joriy katalogni ko'rsatadi |
| ls     | Katalog ichini ro'yxatlash |
| cd     | Katalogni o'zgartirish     |
| mkdir  | Yangi katalog yaratish     |
| rmdir  | Bo'sh katalogni o'chirish  |

**Misol (index_ls.sh):**

```bash
#!/usr/bin/env bash
mkdir -p project/src project/bin
ls project
```

**Vazifa:** `project` katalogi ichida `src` va `bin` yarating.

**Kutilgan output:**

```
bin  src
```

**Vizual tushuntirish (ASCII diagram):**

```
project/
├── src/
└── bin/
```

---

## 3. Fayllar bilan ishlash

**Asosiy buyruqlar:** `cat`, `less`, `head`, `tail`, `cp`, `mv`, `rm`

```bash
cat file.txt
less file.txt
head -n 10 file.txt
tail -n 5 file.txt
cp source dest
mv oldname newname
rm file.txt
rm -r folder
```

**Misol (index_files.sh):**

```bash
#!/usr/bin/env bash
echo -e "1\n2\n3\n4\n5" > notes.txt
head -n 2 notes.txt
tail -n 2 notes.txt
```

**Vazifa (notes_task.sh):**
`notes.txt` fayl yarating, unga 5 qatordan iborat matn yozing va `head` hamda `tail` bilan chiqaring.

**Kutilgan output:**

```
1
2
4
5
```

---

## 4. Ruxsatlar, foydalanuvchi va guruhlar

**ls -l natija tushuntirish:**

```
-rwxr-xr-- 1 user group 4096 Oct 1 12:00 file.sh
```

* `rwx` — egasi huquqlari
* `r-x` — guruh
* `r--` — boshqa

**chmod, chown**

```bash
chmod +x script.sh    # ishlatish huquqi qo'shish
chmod 644 file.txt     # egasi uchun read/write, guruh va boshqalar uchun read
chown user:group file
```

**Misol (index_perm.sh):**

```bash
#!/usr/bin/env bash
echo "Salom!" > script.sh
chmod u+x script.sh
./script.sh
```

**Vazifa (perm_task.sh):**
`script.sh` ga ishlatish huquqi bering va ishga tushuring.

**Kutilgan output:**

```
Salom!
```

---

## 5. O'zgaruvchilar va turlari

**Oddiy o'zgaruvchilar va read:**

```bash
NAME="Ilyas"
AGE=20
echo "Mening ismim $NAME, yoshim $AGE"

read -p "Ismingiz: " USERNAME
echo "Salom $USERNAME"
```

**Misol (index_vars.sh):**

```bash
#!/usr/bin/env bash
NAME="Ilyas"
AGE=20
echo "Mening ismim $NAME, yoshim $AGE"
```

**Vazifa (vars_task.sh):**
Foydalanuvchidan ikkita raqam qabul qilib, ularni yig'indisini chiqaring.

**Kutilgan output:**

```
Birinchi raqam: 2
Ikkinchi raqam: 3
Yig'indi: 5
```

---

## 6. Arifmetik va satr amallar

**Arifmetik:**

```bash
a=5
b=3
sum=$((a + b))
let c=a*b
```

**Satrlar:**

```bash
s1="Hello"
s2="World"
echo "$s1 $s2"
len=${#s1}
sub=${s1:1:3} # ichki kesim
```

**Misol (index_calc.sh):**

```bash
#!/usr/bin/env bash
a=10
b=5
sum=$((a + b))
echo "Yig'indi: $sum"
```

**Vazifa (string_task.sh):**
Berilgan satrni teskari (reverse) qilib chiqaruvchi skript yozing.

**Kutilgan output:**

```
Input: salam
Output: malas
```

---

## 7. Shart operatorlari (`if`, `case`)

**if:**

```bash
if [ "$a" -gt "$b" ]; then
  echo "a katta"
elif [ "$a" -eq "$b" ]; then
  echo "teng"
else
  echo "b katta"
fi
```

**case:**

```bash
case "$1" in
  start) echo "Boshlash" ;;
  stop) echo "To'xtatish" ;;
  *) echo "Noma'lum" ;;
esac
```

**Misol (index_if_case.sh):**

```bash
#!/usr/bin/env bash
a=5
b=3
if [ "$a" -gt "$b" ]; then
  echo "a katta"
else
  echo "b katta"
fi
```

**Vazifa (menu_task.sh):**
Interaktiv menyu yozing (`case` bilan) — 1: Hello, 2: Time, 3: Exit.

**Kutilgan output:** mos buyruq natijasi.

---

## 8. Sikllar (`for`, `while`, `until`) va `select`

**for:**

```bash
for i in 1 2 3; do
  echo "Element: $i"
done
```

**while:**

```bash
count=1
while [ $count -le 5 ]; do
  echo $count
  ((count++))
done
```

**select (menu):**

```bash
select opt in Apple Banana Exit; do
  case $opt in
    Apple) echo "Siz Apple ni tanladingiz" ;;
    Banana) echo "Banana" ;;
    Exit) break ;;
  esac
done
```

**Misol (index_loops.sh):**

```bash
#!/usr/bin/env bash
for i in 1 2 3; do
  echo "Element: $i"
done
```

**Vazifa (count_words.sh):**
Katalog ichidagi `.txt` fayllarni aylanib, har birining qatordagi so'zlar sonini hisoblovchi skript yozing.

**Kutilgan output:**

```
file1.txt: 42 words
file2.txt: 10 words
```

---

## 9. Funktsiyalar va modullar

**Funktsiya:**

```bash
greet() {
  echo "Salom, $1"
}
greet "Ilyas"
```

**Modullar:** boshqa skriptni `source` qilish

```bash
source lib.sh
# yoki
. lib.sh
```

**Misol (index_func.sh):**

```bash
#!/usr/bin/env bash
greet() {
  echo "Salom, $1"
}
greet "Ilyas"
```

**Vazifa (math_task.sh):**
`math.sh` yarating, unda `add`, `sub`, `mul` funksiyalari bo'lsin va asosiy skriptdan ulardan foydalaning.

**Kutilgan output:**

```
Add(2,3)=5
Sub(5,2)=3
```

---

## 10. Globbing, subshell va tizimli buyruqlar

**Globbing:**

* `*` — hamma narsani moslashtiradi
* `?` — bitta belgini
* `[a-z]` — diapazon

**Subshell:**

```bash
files=$(ls -1)
count=$(ls | wc -l)
```

**Misol (index_glob.sh):**

```bash
#!/usr/bin/env bash
echo "Katalogdagi fayllar soni: $(ls | wc -l)"
```

**Vazifa (latest_file.sh):**
Katalogdagi so'nggi modifikatsiya qilingan faylni toping.

**Kutilgan output:**

```
Latest: notes.txt (2025-10-22 10:00)
```

---

## 11. Fayl kiritish/chiqarish va redirektsiya

```bash
command > out.txt    # yozadi (overwrite)
command >> out.txt   # qo'shadi (append)
command 2> err.txt   # stderr ni faylga yo'naltiradi
command &> all.txt   # stdout va stderr
cat file | grep txt
```

**Misol (index_redirect.sh):**

```bash
#!/usr/bin/env bash
echo "Hello" > out.txt
echo "Error" 2> err.txt
```

**Vazifa (ping_task.sh):**
`ping -c 3 8.8.8.8` ni `ping_output.txt` ga yozing va xatomni `ping_error.txt` ga yo'naltiring.

**Kutilgan output:** `ping_output.txt` ichida 3 ta ping qatori.

---

## 12. Pipe va filtrlar (`grep`, `awk`, `sed`, `cut`, `sort`, `uniq`)

```bash
grep "pattern" file.txt
grep -i "pattern"
cut -d":" -f1 /etc/passwd
awk -F":" '{print $1" ->" $3}' /etc/passwd
sed -n '1,5p' file
sed -i 's/old/new/g' file.txt
```

**Misol (index_pipe.sh):**

```bash
#!/usr/bin/env bash
cut -d":" -f1 /etc/passwd > users_list.txt
wc -l users_list.txt > users_count.txt
```

**Vazifa (users_task.sh):**
`/etc/passwd` dan foydalanuvchi nomlarini ajratib `users_list.txt` ga yozing va umumiy sonini `users_count.txt` ga yozing.

**Kutilgan output:** masalan `34`

---

## 13. Arraylar va associative arraylar

```bash
arr=(one two three)
echo "${arr[1]}" # two
len=${#arr[@]}

declare -A dict
dict[ism]="Ilyas"
echo ${dict[ism]}
```

**Misol (index_array.sh):**

```bash
#!/usr/bin/env bash
arr=(one two three)
echo "Ikkinchi element: ${arr[1]}"
```

**Vazifa (assoc_task.sh):**
`users.txt` dan har bir foydalanuvchi uchun uid va username juftligini associative array ga yuklang va chiqarib bering.

**Kutilgan output:**

```
root -> 0
user -> 1000
```

---

## 14. Regex va `grep` / `egrep`

```bash
egrep '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$' emails.txt
```

**Vazifa (emails_task.sh):**
`emails.txt` fayldan faqat haqiqiy ko'rinishdagi email manzillarni ajrating.

**Kutilgan output:** to'g'ri formatdagi email qatorlari.

---

## 15. Script yozish va debugging

**Shebang va debug:**

```bash
#!/usr/bin/env bash
set -x  # buyrug'larni chop etadi
set -e  # xato bo'lsa chiqadi
trap 'echo "Xato: $?"' ERR
```

**Vazifa (debug_task.sh):**
Xatolikni ko'rsatadigan va tuzatadigan skript yozing.

**Kutilgan output:**

```
Xato: 1
```

---

## 16. Cron va timers

**Crontab misol:**

```cron
30 2 * * * /home/user/backup.sh
```

**Vazifa (backup_task.sh):**
`backup.sh` yozing, u `tar` bilan `/home/user/data` ni zaxiralasin va natijani `/home/user/backups` ga yozsin.

**Kutilgan output:**

```
backups/backup-YYYYMMDD.tar.gz
```

---

## 17. Tarmoqqa oid buyruqlar

```bash
ssh user@host
scp file user@host:/path/
rsync -avz src/ user@host:/dest/
curl -I https://example.com
wget https://file.zip
```

**Vazifa (scp_task.sh):**
Mahalliy `test.txt` faylni uzoq serverga yuboring yoki `rsync` bilan simulyatsiya qiling.

**Kutilgan output:** fayl uzatilganligi haqida xabar.

---

## 18. Paket boshqar


uv

**Debian / Ubuntu:**

```bash
sudo apt update
sudo apt install vim
sudo apt remove nano
```

**RHEL / CentOS:**

```bash
sudo yum install git
sudo dnf update
```

**Vazifa:**
O'zingizning distro uchun kerakli paketni o'rnating va tekshiring.

**Kutilgan output:** paket muvaffaqiyatli o'rnatildi.

---

## 19. Bash Cheat Sheet

| Buyruq                 | Tavsifi                                          |
| ---------------------- | ------------------------------------------------ |
| echo                   | Konsolga chiqarish                               |
| read                   | Foydalanuvchi kiritadi                           |
| cd                     | Katalogni o'zgartirish                           |
| pwd                    | Joriy katalog                                    |
| ls                     | Fayl va kataloglarni ko'rsatish                  |
| mkdir/rmdir            | Katalog yaratish/o'chirish                       |
| cp/mv/rm               | Fayl nusxa ko'chirish / o'zgartirish / o'chirish |
| chmod                  | Fayl huquqlarini o'zgartirish                    |
| chown                  | Egasi va guruhni o'zgartirish                    |
| for/while/until/select | Sikllar                                          |
| if/case                | Shart operatorlari                               |
| function               | Funktsiya e'lon qilish                           |
| source                 | Skriptni ulash                                   |
| > / >> / 2> / &>       | Redirektsiya                                     |
| grep/awk/sed/cut       | Tekstni filtrlash va qayta ishlash               |
| declare -A             | Associative array                                |

---

**Endi sizda 0 dan Hero gacha to‘liq Bash qo‘llanma mavjud!**

```

---

Agar xohlasangiz, men **shu README.md faylini GitHub repo’ga push qilishga tayyor `.git` buyruqlari bilan** ham tayyorlab bera olaman, shunda siz shunchaki nusxa ko‘chirib push qilishingiz mumkin.  

Sizga shuni ham tayyorlab beray?
```
