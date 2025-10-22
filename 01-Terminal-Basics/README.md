# 1. Kirish va muhiti sozlash

**Bash nima?**
Bash — Linux va Unixlike tizimlarda keng tarqalgan qobiq (shell). U buyruqlarni qabul qiladi, skriptlarni bajaradi va tizim bilan interaktiv aloqa qiladi.

**O'rnatish / tekshirish**

```bash
bash --version
which bash
echo $SHELL
```

**Muhit o'zgaruvchilari**
`~/.bashrc`, `~/.bash_profile` va global `/etc/bash.bashrc`. O'zgaruvchi qo'shish:

```bash
export MY_VAR="Salom"
```

**Amaliy mashq 1**

* Vazifa: Terminalda `hello.sh` faylini yaratib, ichiga `echo "Salom, Bash!"` yozing va ishga tushuring.
* Kutilgan output:

```
Salom, Bash!
```

---