
---


# 4. Ruxsatlar, foydalanuvchi va guruhlar

**ls -l natija tushuntirish**
`-rwxr-xr-- 1 user group 4096 Oct 1 12:00 file.sh`

* `rwx` — egasi huquqlari; `r-x` — guruh; `r--` — boshqa.

**chmod, chown**

```bash
chmod +x script.sh    # ishlatish huquqi qo'shish
chmod 644 file.txt     # egasi uchun read/write, guruh va boshqalar uchun read
chown user:group file
```

**Amaliy mashq 4**

* Vazifa: `script.sh` ga `chmod u+x` bering va uni `./script.sh` bilan ishlating.
* Kutilgan output: script ichidagi `echo` natijasi.

---

# 5. O'zgaruvchilar va turlari

**Oddiy o'zgaruvchilar**

```bash
NAME="Ilyas"
AGE=20
echo "Mening ismim $NAME, yoshim $AGE"
```

Qoidalar: o'zgaruvchi nomi faqat harflar, raqamlar va `_` bo'lishi mumkin, raqam bilan boshlanmaydi.

**Read va parametrlash**

```bash
read -p "Ismingiz: " USERNAME
echo "Salom $USERNAME"
```

**Amaliy mashq 5**

* Vazifa: foydalanuvchidan ikkita raqam qabul qilib, ularni yig'indisini chiqaring.
* Kutilgan output misol:

```
Birinchi raqam: 2
Ikkinchi raqam: 3
Yig'indi: 5
```

---

# 6. Arifmetik va satr amallar

**Arifmetik**

```bash
# Bazaviy
a=5
b=3
sum=$((a + b))
# yoki let
let c=a*b
```

**Satrlar**

```bash
s1="Hello"
s2="World"
echo "$s1 $s2"
len=${#s1}
sub=${s1:1:3} # ichki kesim
```

**Amaliy mashq 6**

* Vazifa: berilgan satrni teskari (reverse) qilib chiqaruvchi skript yozing.
* Kutilgan output:

```
Input: salam
Output: malas
```

---

# 7. Shart operatorlari (`if`, `case`)

**if**

```bash
if [ "$a" -gt "$b" ]; then
  echo "a katta"
elif [ "$a" -eq "$b" ]; then
  echo "teng"
else
  echo "b katta"
fi
```

E'tibor: `[ ]` ichida bo'sh joylar muhim.

**case**

```bash
case "$1" in
  start) echo "Boshlash" ;;
  stop) echo "To'xtatish" ;;
  *) echo "Noma'lum" ;;
esac
```

**Amaliy mashq 7**

* Vazifa: interaktiv menyu yozing (`case` bilan) — 1: Hello, 2: Time, 3: Exit.
* Kutilgan output — mos buyruq natijasi.

---

# 8. Sikllar (`for`, `while`, `until`) va `select`

**for**

```bash
for i in 1 2 3; do
  echo "Element: $i"
done
```

**while**

```bash
count=1
while [ $count -le 5 ]; do
  echo $count
  ((count++))
done
```

**select** (menu uchun)

```bash
select opt in Apple Banana Exit; do
  case $opt in
    Apple) echo "Siz Apple ni tanladingiz" ;;
    Banana) echo "Banana" ;;
    Exit) break ;;
  esac
done
```

**Amaliy mashq 8**

* Vazifa: katalog ichidagi .txt fayllarni aylanib, har birining qatordagi so'zlar sonini hisoblovchi skript.
* Kutilgan output misol:

```
file1.txt: 42 words
file2.txt: 10 words
```

---

# 9. Funktsiyalar va modullar

**Funktsiya yozish**

```bash
greet() {
  echo "Salom, $1"
}

greet "Ilyas"
```

Return qiymat `exit` kod sifatida `return` yoki `echo` bilan olinadi.

**Modullar** — boshqa skriptni `source` qilish

```bash
source lib.sh
# yoki
. lib.sh
```

**Amaliy mashq 9**

* Vazifa: math.sh yarating, unda `add`, `sub`, `mul` funksiyalari bo'lsin va asosiy skriptdan ulardan foydalaning.
* Kutilgan output:

```
Add(2,3)=5
Sub(5,2)=3
```

---

# 10. Globbing, subshell va tizimli buyruqlar

**Globbing**

* `*` — hamma narsani moslashtiradi
* `?` — bitta belgini
* `[a-z]` — diapazon

**Subshell**

```bash
files=$(ls -1)
count=$(ls | wc -l)
```

Subshell ichidagi o'zgaruvchilar asosiy shellga ta'sir qilmaydi.

**Amaliy mashq 10**

* Vazifa: katalogdagi so'nggi modifikatsiya qilingan faylni toping.
* Kutilgan output misol:

```
Latest: notes.txt (2025-10-22 10:00)
```

---

# 11. Fayl kiritish/chiqarish va redirektsiya

**> >> 2> &> |**

```bash
command > out.txt    # yozadi (overwrite)
command >> out.txt   # qo'shadi (append)
command 2> err.txt   # stderr ni faylga yo'naltiradi
command &> all.txt   # stdout va stderr
cat file | grep txt
```

**Amaliy mashq 11**

* Vazifa: `ping -c 3 8.8.8.8` ni `ping_output.txt` ga yozing va xatomni `ping_error.txt` ga yo'naltiring.
* Kutilgan output: `ping_output.txt` ichida 3 ta ping qatori.

---

# 12. Pipe va filtrlar (grep, awk, sed, cut, sort, uniq)

**grep**

```bash
grep "pattern" file.txt
grep -i "pattern"   # case-insensitive
```

**cut**

```bash
cut -d":" -f1 /etc/passwd
```

**awk**

```bash
awk -F":" '{print $1" ->" $3}' /etc/passwd
```

**sed**

```bash
sed -n '1,5p' file
sed -i 's/old/new/g' file.txt  # faylni o'zgartirish
```

**Amaliy mashq 12**

* Vazifa: `/etc/passwd` dan foydalanuvchi nomlarini ajratib `users_list.txt` ga yozing va umumiy sonini `users_count.txt` ga (faqat raqam bilan).
* Kutilgan output (`users_count.txt`): masalan `34`

---

# 13. Arraylar va associative arraylar

**Indexed array**

```bash
arr=(one two three)
echo "${arr[1]}" # two
len=${#arr[@]}
```

**Associative array (bash 4+)**

```bash
declare -A dict
dict[ism]="Ilyas"
echo ${dict[ism]}
```

**Amaliy mashq 13**

* Vazifa: `users.txt` dan har bir foydalanuvchi uchun uid va username juftligini associative array ga yuklang va chiqarib bering.
* Kutilgan output misol:

```
root -> 0
user -> 1000
```

---

# 14. Regex va `grep` / `egrep`

**Oddiy regex misol**

```bash
egrep '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$' emails.txt
```

**Amaliy mashq 14**

* Vazifa: `emails.txt` fayldan faqat haqiqiy ko'rinishdagi email manzillarni ajrating.
* Kutilgan output: to'g'ri formatdagi email qatorlari.

---

# 15. Script yozish va debugging

**shebang**

```bash
#!/usr/bin/env bash
```

**Debug**

```bash
set -x  # buyrug'larni chop etadi
set -e  # xato bo'lsa chiqadi
trap 'echo "Xato: $?"' ERR
```

**Amaliy mashq 15**

* Vazifa: xatolikni ko'rsatadigan va tuzatadigan skript yozing (masalan fayl yo'q bo'lsa xato beradi va trap ishlaydi).
* Kutilgan output: `Xato: 1` kabi trap xabari.

---

# 16. Cron va timers

**crontab misol**

```cron
# har kuni soat 2:30 da ishga tushadi
30 2 * * * /home/user/backup.sh
```

**Amaliy mashq 16**

* Vazifa: `backup.sh` yozing, u `tar` bilan `/home/user/data` ni zaxiralasin va natijani `/home/user/backups` ga yozsin.
* Kutilgan output: `backups/backup-YYYYMMDD.tar.gz`

---

# 17. Tarmoqqa oid buyruqlar

**ssh, scp, rsync, curl, wget**

```bash
ssh user@host
scp file user@host:/path/
rsync -avz src/ user@host:/dest/
curl -I https://example.com
wget https://file.zip
```

**Amaliy mashq 17**

* Vazifa: mahalliy `test.txt` faylni uzoq serverga (misol uchun `user@host`) yuboring (agar serveringiz bo'lsa) yoki `rsync` bilan simulyatsiya qiling.
* Kutilgan output: `test.txt` uzatilganligi haqida xabar.

---

# 18. Paket boshqaruv va avtomatizatsiya

**apt, yum, pacman misollar**

```bash
sudo apt update && sudo apt install -y curl
```

**Skript orqali o'rnatish**

```bash
#!/usr/bin/env bash
set -e
sudo apt update
sudo apt install -y git curl
```

**Amaliy mashq 18**

* Vazifa: dastlabki muhitni o'rnatuvchi skript yozing (`devsetup.sh`) — git, curl, figlet va kerakli paketlar.
* Kutilgan output: o'rnatish muvaffaqiyatli tugadi xabari.

---

# 19. Best practices va xavfsizlik

* Har doim `set -e` va `set -u` dan foydalaning ishlab chiqish skriptlarida.
* Kiritilgan qiymatlarni tekshiring (`validate input`).
* Hech qachon parollarni oddiy matn faylga yozmang.
* Skriptlarni minimal huquq bilan ishga tushiring.

---

# 20. Loyihalar: Amaliy mashqlar

**Mini-proyekt 1 — Simple Backup Tool**

* `backup.sh`: katalogni zaxiralash, eski zaxiralarni 30 kundan eski bo'lsa o'chirish, log yozish.

**Mini-proyekt 2 — User Manager**

* `user_manager.sh`: `add|del|list` funksiyalari, `/etc/passwd` o'qish (yo'riqnoma bilan, sudo kerak bo'lishi mumkin).

**Mini-proyekt 3 — Log Monitor**

* `logwatch.sh`: biron bir log faylni kuzatib, muayyan `ERROR` so'zi topilsa email yuborish (smtp client yoki `sendmail` ishlatiladi).

Har bir loyihatda `README` va `--help` (usage) bo'lsin.

---

# 21. Cheat sheetlar va tez-tez ishlatiladigan buyruqlar

## Tez buyruqlar jadvali

| Vazifa                 | Buyruq yoki pattern                      |                          |
| ---------------------- | ---------------------------------------- | ------------------------ |
| Fayl ko'rsatish        | `cat file` `less file`                   |                          |
| Filtrlash              | `grep 'pattern' file`                    |                          |
| Foydalanuvchi ro'yxati | `cut -d: -f1 /etc/passwd`                |                          |
| Fayl ruxsat            | `chmod 755 file` `chown user:group file` |                          |
| Qidiruv                | `find /path -name '*.sh'`                |                          |
| Jarayon                | `ps aux                                  | grep process` `kill PID` |

## Quick Bash Syntax

* `$(cmd)` — command substitution
* `` `cmd` `` — eski usul
* `[[ ... ]]` — string/regex comparison (bash-specific)
* `"$@"` — barcha argumentlar (saf saqlangan)
* `$#` — argumentlar soni

## Tez-tez ishlatiladigan `grep` va `awk` misollari

* `grep -R "TODO" .` — butun loyiha bo'ylab qidirish
* `awk '{print $1,$3}' file` — ustunlarni chiqarish

---

# Qo'shimcha materiallar va tavsiyalar

* Rasman Bash qo'llanmasi (`man bash`) ni o'qish.
* Har bir mavzuda kichik vazifalarni bajaring va GitHub ga joylang.
* Skriptlaringizni `shellcheck` bilan tekshiring.

---

Agar xohlasangiz, men har bob bo'yicha alohida dars-reja (masalan 30 kunlik roadmap), batafsil video/script mashqlar yoki siz uchun moslashtirilgan kunlik reja tuzib bera olaman. Qaysi formatda davom etishni xohlaysiz? (masalan: 30 kunlik, loyihalar bilan, yoki video + amaliy mashqlar)
