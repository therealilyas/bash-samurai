# 00-Intro – Bashga Kirish

## Bash nima?
Bash (Bourne Again Shell) – bu terminal orqali kompyuter bilan muloqot qilish, skript yozish va avtomatlashtirish vositasi.

## Terminal nima?
Terminal – matn orqali kompyuter bilan muloqot qilish dasturi.

---

## Misol: "Salom, Bash!"
```bash
#!/bin/bash
echo "Salom, Bash!"
```

## Vazifa 00: Foydalanuvchidan ism olib, salomlashish
1. Foydalanuvchidan ism so‘rab oling
2. Salomlashish matnini chiqarish

```
#!/bin/bash
read -p "Ismingizni kiriting: " name
echo "Salom, $name!"
```

## Output misol:
```
Ismingizni kiriting: Ilyas
Salom, Ilyas!
```

```

---

# **01-Terminal-Basics/README.md**

```markdown
# 01-Terminal-Basics – Terminal va Fayl Tizimi

## Asosiy buyruqlar
| Buyruq | Tavsif |
|--------|--------|
| `ls` | Papka ichidagi fayllarni ko‘rsatish |
| `cd` | Papkani o‘zgartirish |
| `mkdir` | Yangi papka yaratish |
| `touch` | Yangi fayl yaratish |
| `pwd` | Hozirgi ishchi katalogni ko‘rsatish |

---

## Misol:
```bash
mkdir my_project
cd my_project
touch file.txt
ls
pwd

```