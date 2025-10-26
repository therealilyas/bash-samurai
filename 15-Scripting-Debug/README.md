## 1️⃣5️⃣ SCRIPT YOZISH VA DEBUG USULLARI
**Global nomi:** Script Writing and Debugging  
**O'zbek nomi:** Skript yozish va xatolarni topish

### Skript strukturasi

#### 1. Shebang (#!)

Skriptning birinchi qatori - qaysi interpretatordan foydalanishni ko'rsatadi.

```bash
#!/bin/bash
# Bash skript

#!/bin/sh
# POSIX shell skript

#!/usr/bin/env bash
# Bash ni PATH dan topish (portativ)

#!/usr/bin/python3
# Python skript
```

**Hayotiy misol:** Pochtachi uchun manzil - bu xatni kimga yetkazish kerakligini ko'rsatadi.

#### 2. To'liq skript strukturasi

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

# Xavfsizlik sozlamalari
set -euo pipefail
# set -x  # Debug uchun

# Ranglar
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Global o'zgaruvchilar
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly LOG_FILE="/var/log/${SCRIPT_NAME%.sh}.log"

# Funktsiyalar
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2 | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

cleanup() {
    log_info "Tozalash..."
    # Vaqtinchalik fayllarni o'chirish
}

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
    
    # Bu yerda asosiy kod
    
    log_info "Skript tugadi"
}

# Foydalanish yo'riqnomasi
usage() {
    cat << EOF
Foydalanish: $SCRIPT_NAME [OPTIONS]

OPTIONS:
    -h, --help          Yordam
    -v, --version       Versiya
    -d, --debug         Debug rejimi
    
EXAMPLES:
    $SCRIPT_NAME
    $SCRIPT_NAME --debug
    
EOF
    exit 0
}

# Argumentlarni qayta ishlash
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -v|--version)
            echo "Version 1.0.0"
            exit 0
            ;;
        -d|--debug)
            set -x
            shift
            ;;
        *)
            log_error "Noma'lum argument: $1"
            usage
            ;;
    esac
done

# Skriptni ishga tushirish
main "$@"
```

### set buyruqlari - Xavfsizlik

```bash
# set -e
# Har qanday buyruq xato bersa, skript to'xtaydi
set -e

# set -u
# E'lon qilinmagan o'zgaruvchi ishlatilsa, xato
set -u

# set -o pipefail
# Pipe da biror buyruq xato bersa, butun pipe xato
set -o pipefail

# set -x
# Har bir buyruqni bajarishdan oldin ekranga chiqaradi (debug)
set -x

# Hammasi birgalikda
set -euxo pipefail

# O'chirish
set +e
set +x
```

**Misollar:**

```bash
#!/bin/bash
set -e

# Agar fayl topilmasa, skript to'xtaydi
cat mavjud_emas.txt

# Bu qator ishlamaydi (yuqoridagi xato berdi)
echo "Davom"

# ---

#!/bin/bash
set -u

# Xato: o'zgaruvchi e'lon qilinmagan
echo $MAVJUD_EMAS

# ---

#!/bin/bash
set -o pipefail

# Pipe da xato
cat mavjud_emas.txt | grep "test"
echo "Exit code: $?"  # 0 emas (set -o pipefail bo'lmaganda 0 bo'lar edi)
```

### Debug usullari

#### 1. set -x (Xtrace)

```bash
#!/bin/bash

echo "Oddiy chiqarish"

set -x  # Debug yoqish
ls -la
cat test.txt
set +x  # Debug o'chirish

echo "Yana oddiy"

# Natija:
# Oddiy chiqarish
# + ls -la
# (ls natijalari)
# + cat test.txt
# (cat natijalari)
# Yana oddiy
```

#### 2. PS4 o'zgaruvchisi - Debug formatini sozlash

```bash
#!/bin/bash

# Standart: + buyruq
# Yaxshilangan: qator raqami, funksiya, vaqt
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

set -x
echo "Test"
my_function() {
    echo "Funksiya ichida"
}
my_function
set +x

# Natija:
# +(script.sh:8): echo Test
# +(script.sh:12): my_function()
# +(script.sh:10): my_function(): echo 'Funksiya ichida'
```

#### 3. Conditional debug

```bash
#!/bin/bash

DEBUG=${DEBUG:-0}

debug() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "[DEBUG] $*" >&2
    fi
}

debug "Bu debug xabar"
echo "Oddiy xabar"

# Ishlatish:
# DEBUG=1 ./script.sh  # Debug xabarlar ko'rinadi
# ./script.sh          # Faqat oddiy xabarlar
```

#### 4. Logger funksiyasi

```bash
#!/bin/bash

# Log daraja
declare -A LOG_LEVELS=(
    [DEBUG]=0
    [INFO]=1
    [WARNING]=2
    [ERROR]=3
)

CURRENT_LOG_LEVEL=${LOG_LEVEL:-INFO}

log() {
    local level=$1
    shift
    local message="$*"
    
    if [ ${LOG_LEVELS[$level]:-0} -ge ${LOG_LEVELS[$CURRENT_LOG_LEVEL]:-1} ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
    fi
}

log DEBUG "Bu debug xabar"
log INFO "Bu info xabar"
log WARNING "Bu warning xabar"
log ERROR "Bu error xabar"

# Ishlatish:
# LOG_LEVEL=DEBUG ./script.sh  # Barcha xabarlar
# LOG_LEVEL=ERROR ./script.sh  # Faqat ERROR
```

### Xatolarni boshqarish

#### 1. Exit kodlar

```bash
# 0 = Muvaffaqiyat
# 1-255 = Xato

exit 0    # Muvaffaqiyat
exit 1    # Umumiy xato
exit 2    # Noto'g'ri argumentlar
exit 127  # Buyruq topilmadi
exit 130  # Ctrl+C bilan to'xtatilgan

# Oxirgi buyruqning exit kodi
echo "Test"
echo $?  # 0

cat mavjud_emas.txt
echo $?  # 1 (xato)
```

#### 2. Trap - Signal tutish

```bash
#!/bin/bash

cleanup() {
    echo "Tozalash..."
    rm -f /tmp/temp_*
}

# Skript tugashida cleanup ni chaqirish
trap cleanup EXIT

# Ctrl+C (SIGINT)
trap 'echo "Interrupt!"; exit 130' INT

# Xato (ERR)
trap 'echo "Xato $LINENO qatorda"; exit 1' ERR

# Test
echo "Ishlayapman..."
sleep 5
```

**Signallar:**
- `EXIT` - Skript tugashida
- `INT` - Ctrl+C
- `TERM` - kill buyrug'i
- `ERR` - Xato
- `DEBUG` - Har bir buyruqdan keyin
- `RETURN` - Funksiya qaytganida

#### 3. Try-Catch simulation

```bash
#!/bin/bash

try() {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        return $status
    fi
}

catch() {
    return 0
}

# Ishlatish
if try ls /mavjud_emas; then
    echo "Muvaffaqiyatli"
else
    echo "Xato yuz berdi, lekin davom etamiz"
fi
```

### Argument parsing (kompleks)

```bash
#!/bin/bash

# Default qiymatlar
VERBOSE=0
DRY_RUN=0
OUTPUT_FILE=""
INPUT_FILES=()

usage() {
    cat << EOF
Foydalanish: $0 [OPTIONS] FILE1 [FILE2...]

OPTIONS:
    -v, --verbose           Batafsil chiqarish
    -d, --dry-run          Test rejimi (hech narsa o'zgarmaydi)
    -o, --output FILE      Natija fayli
    -h, --help             Yordam
    
EXAMPLES:
    $0 input.txt
    $0 -v -o output.txt input1.txt input2.txt
    $0 --dry-run --verbose file.txt
EOF
    exit 0
}

# Argumentlarni parse qilish
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=1
            shift
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Noma'lum option: $1" >&2
            usage
            ;;
        *)
            # Fayl argumentlari
            INPUT_FILES+=("$1")
            shift
            ;;
    esac
done

# Tekshirish
if [ ${#INPUT_FILES[@]} -eq 0 ]; then
    echo "Xato: Kamida bitta fayl kerak" >&2
    usage
fi

# Debug
if [ $VERBOSE -eq 1 ]; then
    echo "Verbose: yoqilgan"
    echo "Dry run: $DRY_RUN"
    echo "Output: $OUTPUT_FILE"
    echo "Input files: ${INPUT_FILES[*]}"
fi

# Asosiy mantiq
for file in "${INPUT_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Xato: Fayl topilmadi: $file" >&2
        continue
    fi
    
    echo "Qayta ishlanmoqda: $file"
    
    if [ $DRY_RUN -eq 0 ]; then
        # Asl ishlov
        :
    else
        echo "[DRY RUN] $file qayta ishlanardi"
    fi
done
```

### getopts - Built-in argument parser

```bash
#!/bin/bash

while getopts "vo:h" opt; do
    case $opt in
        v)
            VERBOSE=1
            ;;
        o)
            OUTPUT="$OPTARG"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Noto'g'ri option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG argument talab qiladi" >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

# Qolgan argumentlar
echo "Qolgan: $*"
```

### Best Practices

#### 1. Shellcheck - Static analyzer

```bash
# Shellcheck o'rnatish
sudo apt install shellcheck

# Skriptni tekshirish
shellcheck script.sh

# Muammo misollari:
# ✗ Qo'shtirnoqsiz o'zgaruvchi
echo $file  # Xato
echo "$file"  # To'g'ri

# ✗ [ ] da && ishlatish
[ $a -eq 1 && $b -eq 2 ]  # Xato
[ $a -eq 1 ] && [ $b -eq 2 ]  # To'g'ri

# ✗ $(( )) ichida $
echo $(($a + 1))  # Ortiqcha
echo $((a + 1))  # To'g'ri
```

#### 2. Funktsiyalar

```bash
#!/bin/bash

# Yaxshi funksiya
fayl_mavjud() {
    local fayl=$1
    
    if [ ! -f "$fayl" ]; then
        echo "Xato: Fayl topilmadi: $fayl" >&2
        return 1
    fi
    
    return 0
}

# Ishlatish
if fayl_mavjud "test.txt"; then
    echo "Fayl mavjud"
else
    echo "Fayl yo'q"
    exit 1
fi
```

#### 3. Input validatsiya

```bash
#!/bin/bash

raqam_mi() {
    [[ $1 =~ ^[0-9]+$ ]]
}

email_mi() {
    [[ $1 =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

bo'sh_emas() {
    [ -n "$1" ]
}

# Ishlatish
read -p "Yoshingiz: " yosh

if ! raqam_mi "$yosh"; then
    echo "Xato: Raqam kiriting" >&2
    exit 1
fi

if [ $yosh -lt 0 ] || [ $yosh -gt 150 ]; then
    echo "Xato: Noto'g'ri yosh" >&2
    exit 1
fi
```

### Amaliy loyiha: Skript generator

```bash
#!/bin/bash

#############################################
# Bash Script Generator
# Yangi skriptlar uchun shablon yaratadi
#############################################

readonly TEMPLATE_DIR="$HOME/.bash_templates"
mkdir -p "$TEMPLATE_DIR"

generate_basic() {
    local script_name=$1
    local description=$2
    
    cat > "$script_name" << 'EOF'
#!/bin/bash

#############################################
# Script Name: SCRIPT_NAME
# Description: DESCRIPTION
# Author: AUTHOR
# Date: DATE
# Version: 1.0.0
#############################################

set -euo pipefail

# Ranglar
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Logging
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Cleanup
cleanup() {
    log_info "Tozalash..."
}

trap cleanup EXIT

# Main function
main() {
    log_info "Skript boshlandi"
    
    # Sizning kodingiz bu yerda
    
    log_info "Skript tugadi"
}

# Foydalanish
usage() {
    cat << USAGE
Foydalanish: $0 [OPTIONS]

OPTIONS:
    -h, --help      Yordam
    -v, --verbose   Batafsil
    
USAGE
    exit 0
}

# Argumentlar
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -v|--verbose)
            set -x
            shift
            ;;
        *)
            log_error "Noma'lum argument: $1"
            usage
            ;;
    esac
done

main "$@"
EOF

    # Placeholderlarni almashtirish
    sed -i "s/SCRIPT_NAME/$script_name/" "$script_name"
    sed -i "s/DESCRIPTION/$description/" "$script_name"
    sed -i "s/AUTHOR/$(git config user.name 2>/dev/null || echo "$USER")/" "$script_name"
    sed -i "s/DATE/$(date +%Y-%m-%d)/" "$script_name"
    
    chmod +x "$script_name"
    
    echo "✓ Skript yaratildi: $script_name"
}

generate_advanced() {
    local script_name=$1
    
    cat > "$script_name" << 'EOF'
#!/bin/bash

set -euo pipefail

# Debug
DEBUG=${DEBUG:-0}
debug() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Logging
readonly LOG_FILE="/tmp/${0##*/}.log"
log() {
    local level=$1
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}

# Xatolarni boshqarish
error_handler() {
    log ERROR "Xato $1-qatorda"
    cleanup
    exit 1
}

trap 'error_handler $LINENO' ERR
trap cleanup EXIT INT TERM

cleanup() {
    debug "Tozalash..."
}

# Argument parsing
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                ;;
            -d|--debug)
                DEBUG=1
                set -x
                shift
                ;;
            *)
                log ERROR "Noma'lum: $1"
                usage
                ;;
        esac
    done
}

usage() {
    cat << EOF
Foydalanish: $0 [OPTIONS]

OPTIONS:
    -h, --help    Yordam
    -d, --debug   Debug rejimi
EOF
    exit 0
}

main() {
    parse_args "$@"
    
    log INFO "Boshlandi"
    
    # Kod
    
    log INFO "Tugadi"
}

main "$@"
EOF

    chmod +x "$script_name"
    echo "✓ Advanced skript yaratildi: $script_name"
}

# CLI
case ${1:-} in
    basic)
        shift
        generate_basic "$@"
        ;;
    advanced)
        shift
        generate_advanced "$@"
        ;;
    *)
        echo "Foydalanish:"
        echo "  $0 basic SCRIPT_NAME 'Description'"
        echo "  $0 advanced SCRIPT_NAME"
        exit 1
        ;;
esac
```

### 📝 Vazifalar:

1. **Vazifa 1:** set -e, set -u, set -o pipefail ishlatgan holda xavfsiz skript yozing
2. **Vazifa 2:** Trap dan foydalanib, vaqtinchalik fayllarni tozalaydigan skript
3. **Vazifa 3:** Kompleks argument parsing: -v, --verbose, -o output.txt, --config file.conf
4. **Vazifa 4:** Log funksiyasi: DEBUG, INFO, WARNING, ERROR darajalari bilan
5. **Vazifa 5:** Try-catch simulatsiyasi bilan xatolarni handle qiladigan skript

