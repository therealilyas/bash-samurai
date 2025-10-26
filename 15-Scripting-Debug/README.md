# 1️⃣5️⃣ SCRIPT YOZISH VA DEBUG USULLARI

**Global nomi:** Script Writing and Debugging
**O'zbek nomi:** Skript yozish va xatolarni topish

---

## Skript strukturasi

### 1. Shebang (#!)

Skriptning birinchi qatori qaysi interpretatordan foydalanilishini bildiradi:

```bash
#!/bin/bash        # Bash skript
#!/bin/sh          # POSIX shell skript
#!/usr/bin/env bash # Bash ni PATH orqali topish (portativ)
#!/usr/bin/python3  # Python skript
```

**Hayotiy misol:** Pochtachi uchun manzil — xatni kimga yetkazish kerakligini ko‘rsatadi.

---

### 2. To‘liq skript struktura misoli

```bash
#!/bin/bash

#############################################
# Script Name: my_script.sh
# Description: Bu skript nimani qiladi
# Author: Sardor Aliyev
# Email: sardor@example.com
# Date: 2025-10-23
# Version: 1.0.0
#############################################

set -euo pipefail  # Xavfsizlik
# set -x           # Debug uchun

# Ranglar
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Global o'zgaruvchilar
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly LOG_FILE="/var/log/${SCRIPT_NAME%.sh}.log"

# Logging
log_info() { echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2 | tee -a "$LOG_FILE"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"; }

# Cleanup
cleanup() {
    log_info "Tozalash..."
    # Vaqtinchalik fayllarni o'chirish
}

# Xato handler
error_handler() {
    local line=$1
    log_error "Xato $line-qatorda"
    cleanup
    exit 1
}

# Signal handlerlar
trap cleanup EXIT
trap 'error_handler $LINENO' ERR

# Asosiy funksiya
main() {
    log_info "Skript boshlandi"
    # Asosiy kod bu yerda
    log_info "Skript tugadi"
}

# Foydalanish
usage() {
    cat << EOF
Foydalanish: $SCRIPT_NAME [OPTIONS]

OPTIONS:
    -h, --help       Yordam
    -v, --version    Versiya
    -d, --debug      Debug rejimi

EXAMPLES:
    $SCRIPT_NAME
    $SCRIPT_NAME --debug
EOF
    exit 0
}

# Argumentlarni parse qilish
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) usage ;;
        -v|--version) echo "Version 1.0.0"; exit 0 ;;
        -d|--debug) set -x; shift ;;
        *) log_error "Noma'lum argument: $1"; usage ;;
    esac
done

# Skriptni ishga tushirish
main "$@"
```

---

## `set` buyruqlari — Xavfsizlik

```bash
set -e      # Har qanday buyruq xato bersa, skript to'xtaydi
set -u      # E'lon qilinmagan o'zgaruvchi ishlatilsa xato
set -o pipefail  # Pipe da biror buyruq xato bersa, pipe xato
set -x      # Har bir buyruqni bajarishdan oldin ko‘rsatadi (debug)
```

**Misollar:**

```bash
set -e
cat mavjud_emas.txt  # Fayl topilmasa, skript to‘xtaydi
echo "Bu qator ishlamaydi"

set -u
echo $MAVJUD_EMAS   # E'lon qilinmagan o'zgaruvchi

set -o pipefail
cat mavjud_emas.txt | grep "test"
```

---

## Debug usullari

### 1. `set -x` (Xtrace)

```bash
set -x
ls -la
cat test.txt
set +x
```

### 2. `PS4` — Debug formatini sozlash

```bash
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x
```

### 3. Conditional debug

```bash
DEBUG=${DEBUG:-0}
debug() { [[ $DEBUG -eq 1 ]] && echo "[DEBUG] $*" >&2; }
```

### 4. Logger funksiyasi

```bash
declare -A LOG_LEVELS=([DEBUG]=0 [INFO]=1 [WARNING]=2 [ERROR]=3)
CURRENT_LOG_LEVEL=${LOG_LEVEL:-INFO}

log() {
    local level=$1; shift
    [[ ${LOG_LEVELS[$level]} -ge ${LOG_LEVELS[$CURRENT_LOG_LEVEL]} ]] && echo "[$level] $*"
}
```

---

## Xatolarni boshqarish

### 1. Exit kodlar

```bash
exit 0    # Muvaffaqiyat
exit 1    # Umumiy xato
exit 2    # Noto'g'ri argumentlar
exit 127  # Buyruq topilmadi
exit 130  # Ctrl+C bilan to'xtatilgan
```

### 2. Trap — Signal tutish

```bash
trap cleanup EXIT
trap 'echo "Interrupt!"; exit 130' INT
trap 'echo "Xato $LINENO qatorda"; exit 1' ERR
```

### 3. Try-catch simulation

```bash
try() { "$@"; local s=$?; [ $s -ne 0 ] && return $s; }
catch() { return 0; }

if try ls /mavjud_emas; then
    echo "Muvaffaqiyatli"
else
    echo "Xato yuz berdi, lekin davom etamiz"
fi
```

---

## Argument parsing

```bash
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose) VERBOSE=1; shift ;;
        -d|--dry-run) DRY_RUN=1; shift ;;
        -o|--output) OUTPUT_FILE="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) INPUT_FILES+=("$1"); shift ;;
    esac
done
```

---

## Best Practices

* **Shellcheck** bilan static analiz:

```bash
sudo apt install shellcheck
shellcheck script.sh
```

* **Funktsiyalar**: har doim `local` o‘zgaruvchilar ishlating
* **Input validatsiya**: raqam, email, bo‘sh_emas funksiyalari

---

## Amaliy loyiha: Skript generator

```bash
# Yangi skriptlar uchun shablon yaratadi
generate_basic SCRIPT_NAME "Description"
generate_advanced SCRIPT_NAME
```

---

## 📝 Vazifalar

1. `set -e`, `set -u`, `set -o pipefail` bilan xavfsiz skript yozish
2. Trap orqali vaqtinchalik fayllarni tozalash
3. Kompleks argument parsing: `-v, --verbose, -o output.txt, --config file.conf`
4. Log funksiyasi: `DEBUG, INFO, WARNING, ERROR` darajalari bilan
5. Try-catch simulatsiyasi bilan xatolarni handle qiladigan skript

---
