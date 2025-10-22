# Bash: 0 dan Hero gacha — Toʻliq Qoʻllanma (Oʻzbekcha)

**Kirib kelish**  

Bu qo'llanma sizni Bash (Bourne Again Shell) bilan 0 dan boshlab professional darajagacha olib chiqadi. Har bob tartibli, misollar bilan, amaliy vazifalar va `.sh` fayllari bilan berilgan. Oxirida tezkor `cheat sheet` va umumiy buyruqlar jadvali mavjud.

---

## Shell tarixi qisqacha

| Shell       | Yili | Tavsifi                          |
|------------|------|---------------------------------|
| sh (Bourne Shell) | 1977 | Unix tizimlari uchun birinchi standart shell |
| csh (C Shell)    | 1978 | C-sintaksisiga yaqinlashgan shell |
| ksh (Korn Shell) | 1980 | sh ustiga qulayliklar qo‘shilgan |
| bash (Bourne Again Shell) | 1989 | GNU loyihasi, sh + ksh imkoniyatlari |

---

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

