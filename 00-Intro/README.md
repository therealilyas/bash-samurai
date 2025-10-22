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