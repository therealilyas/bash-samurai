## 1️⃣9️⃣ BEST PRACTICES VA XAVFSIZLIK
**Global nomi:** Best Practices and Security  
**O'zbek nomi:** Eng yaxshi amaliyotlar va xavfsizlik

### Shell Script Best Practices

#### 1. Shebang va interpreter

```bash
#!/bin/bash
# ✓ To'g'ri - Bash

#!/bin/sh
# ✓ To'g'ri - POSIX shell (portativ)

#!/usr/bin/env bash
# ✓ Eng yaxshi - Bash ni PATH dan topadi

#!/bin/bash -e
# ✓ Xato bo'lsa to'xtaydi
```

#### 2. Set flags - Xavfsizlik

```bash
#!/bin/bash

# RECOMMENDED: Har doim ishlating!
set -euo pipefail

# set -e: Xato bo'lsa to'xtash
# set -u: Undefined o'zgaruvchi xato
# set -o pipefail: Pipe da xato bo'lsa, butun pipe xato
# set -x: Debug (ixtiyoriy)
```

**Misol:**

```bash
#!/bin/bash
set -euo pipefail

# Bu xato beradi va skript to'xtaydi
cat mavjud_emas.txt

# Bu qator ishlamaydi
echo "Davom"
```

#### 3. O'zgaruvchilar - Qo'shtirnoq va readonly

```bash
#!/bin/bash

# ✗ NOTO'G'RI
file=$1
cat $file  # Bo'sh joylar bilan muammo

# ✓ TO'G'RI
file="$1"
cat "$file"

# ✓ Readonly (o'zgartirib bo'lmaydigan)
readonly CONFIG_FILE="/etc/app.conf"
readonly VERSION="1.0.0"

# ✓ Local o'zgaruvchilar funktsiyalarda
my_function() {
    local temp_var="value"
    echo "$temp_var"
}
```

#### 4. Funksiya nomlari va tuzilma

```bash
#!/bin/bash

# ✓ TO'G'RI: Tushunarli nomlar
check_file_exists() {
    local file="$1"
    [ -f "$file" ]
}

create_backup() {
    local source="$1"
    local dest="$2"
    cp -r "$source" "$dest"
}

# ✗ NOTO'G'RI: Noma'lum nomlar
func1() {
    # ...
}

f() {
    # ...
}
```

#### 5. Xatolarni boshqarish

```bash
#!/bin/bash
set -euo pipefail

# Logging funktsiyalari
log_error() {
    echo "[ERROR] $*" >&2
}

log_info() {
    echo "[INFO] $*"
}

# Cleanup
cleanup() {
    log_info "Tozalash..."
    rm -f /tmp/temp_*
}

trap cleanup EXIT

# Xato handler
error_handler() {
    log_error "Xato $1-qatorda"
    exit 1
}

trap 'error_handler $LINENO' ERR

# Asosiy kod
main() {
    log_info "Boshlandi"
    
    # Fayl mavjudligini tekshirish
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "Config fayl topilmadi: $CONFIG_FILE"
        exit 1
    fi
    
    log_info "Tugadi"
}

main "$@"
```

#### 6. Input validation

```bash
#!/bin/bash

# Email validatsiya
validate_email() {
    local email="$1"
    if [[ ! $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "Noto'g'ri email format" >&2
        return 1
    fi
}

# Raqam validatsiya
validate_number() {
    local num="$1"
    if [[ ! $num =~ ^[0-9]+$ ]]; then
        echo "Raqam emas" >&2
        return 1
    fi
}

# File existence
validate_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "Fayl topilmadi: $file" >&2
        return 1
    fi
    
    if [ ! -r "$file" ]; then
        echo "Fayl o'qib bo'lmaydi: $file" >&2
        return 1
    fi
}

# Ishlatish
read -p "Email: " email
validate_email "$email" || exit 1
```

#### 7. Command existence check

```bash
#!/bin/bash

# Buyruq mavjudligini tekshirish
require_command() {
    if ! command -v "$1" &>/dev/null; then
        echo "Xato: $1 topilmadi" >&2
        echo "O'rnatish: $2" >&2
        exit 1
    fi
}

# Kerakli buyruqlar
require_command "jq" "sudo apt install jq"
require_command "curl" "sudo apt install curl"
require_command "git" "sudo apt install git"
```

#### 8. Argument parsing (robust)

```bash
#!/bin/bash

# Default qiymatlar
VERBOSE=0
DRY_RUN=0
OUTPUT=""

usage() {
    cat << EOF
Usage: $0 [OPTIONS] FILE

OPTIONS:
    -v, --verbose       Verbose output
    -d, --dry-run       Dry run mode
    -o, --output FILE   Output file
    -h, --help          Show help
    
EXAMPLES:
    $0 input.txt
    $0 -v -o output.txt input.txt
    $0 --dry-run file.txt
EOF
    exit 0
}

# Parse arguments
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
            OUTPUT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage
            ;;
        *)
            INPUT_FILE="$1"
            shift
            ;;
    esac
done

# Validation
if [ -z "${INPUT_FILE:-}" ]; then
    echo "Error: Input file required" >&2
    usage
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File not found: $INPUT_FILE" >&2
    exit 1
fi
```

#### 9. Shellcheck - Static analyzer

```bash
# Shellcheck o'rnatish
sudo apt install shellcheck

# Skriptni tekshirish
shellcheck script.sh

# Muammolilar:
# SC2086: Qo'shtirnoqsiz o'zgaruvchi
# SC2046: Qo'shtirnoqsiz command substitution
# SC2006: Eski backtick sintaksisi
# SC2155: Declare va assignment birgalikda
```

**Keng tarqalgan xatolar va to'g'rilash:**

```bash
# ✗ Xato: Qo'shtirnoqsiz o'zgaruvchi
file=$1
cat $file

# ✓ To'g'ri
file="$1"
cat "$file"

# ✗ Xato: Eski sintaksis
output=`ls -l`

# ✓ To'g'ri
output=$(ls -l)

# ✗ Xato: [ ] ichida &&
[ $a -eq 1 && $b -eq 2 ]

# ✓ To'g'ri
[ $a -eq 1 ] && [ $b -eq 2 ]
# yoki
[[ $a -eq 1 && $b -eq 2 ]]

# ✗ Xato: $(( )) ichida $
result=$(($var + 1))

# ✓ To'g'ri
result=$((var + 1))
```

### Xavfsizlik (Security)

#### 1. User input - Hech qachon ishonmang!

```bash
#!/bin/bash

# ✗ XAVFLI: SQL injection
read -p "Username: " username
mysql -e "SELECT * FROM users WHERE name='$username'"
# Agar username = "'; DROP TABLE users; --"

# ✓ XAVFSIZ: Prepared statements yoki validatsiya
validate_username() {
    local user="$1"
    # Faqat harflar, raqamlar, pastki chiziq
    if [[ ! $user =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Noto'g'ri username" >&2
        return 1
    fi
}

read -p "Username: " username
validate_username "$username" || exit 1
```

#### 2. Command injection

```bash
#!/bin/bash

# ✗ XAVFLI: Command injection
read -p "Filename: " file
cat $file
# Agar file = "; rm -rf /"

# ✓ XAVFSIZ: Validatsiya
validate_filename() {
    local file="$1"
    
    # Path traversal tekshirish
    if [[ $file =~ \.\. ]]; then
        echo "Path traversal aniqlandi" >&2
        return 1
    fi
    
    # Faqat ruxsat etilgan belgilar
    if [[ ! $file =~ ^[a-zA-Z0-9._-]+$ ]]; then
        echo "Noto'g'ri fayl nomi" >&2
        return 1
    fi
    
    # Fayl mavjudligi
    if [ ! -f "$file" ]; then
        echo "Fayl topilmadi" >&2
        return 1
    fi
}

read -p "Filename: " file
validate_filename "$file" || exit 1
cat "$file"
```

#### 3. Parollar va credentials

```bash
#!/bin/bash

# ✗ XAVFLI: Parolni skriptda
DB_PASSWORD="secret123"

# ✓ YAXSHI: Environment variable
DB_PASSWORD="${DB_PASSWORD:-}"
if [ -z "$DB_PASSWORD" ]; then
    echo "DB_PASSWORD environment variable kerak" >&2
    exit 1
fi

# ✓ ENG YAXSHI: Secure vault (Vault, 1Password, LastPass)
DB_PASSWORD=$(vault kv get -field=password secret/database)

# Parolni o'qish (yashirin)
read -sp "Password: " password
echo ""

# Parolni log ga yozmaslik
set +x  # Debug o'chirish
DB_PASSWORD="secret"
# ...database operations...
set -x  # Debug yoqish
```

#### 4. File permissions

```bash
#!/bin/bash

# Config fayl yaratish (faqat owner o'qiy oladi)
CONFIG="/etc/myapp/config"
touch "$CONFIG"
chmod 600 "$CONFIG"  # rw-------

# Log fayl (owner yoza oladi, group o'qiy oladi)
LOG="/var/log/myapp.log"
touch "$LOG"
chmod 640 "$LOG"  # rw-r-----

# Executable skript
SCRIPT="/usr/local/bin/myscript.sh"
chmod 755 "$SCRIPT"  # rwxr-xr-x

# Sensitive data directory
mkdir -p /var/lib/myapp
chmod 700 /var/lib/myapp  # rwx------
```

#### 5. Temporary files - Xavfsiz yaratish

```bash
#!/bin/bash

# ✗ XAVFLI: Predictable temp file
TEMP_FILE="/tmp/myapp.tmp"
echo "data" > "$TEMP_FILE"
# Race condition, hijacking mumkin

# ✓ XAVFSIZ: mktemp
TEMP_FILE=$(mktemp)
echo "data" > "$TEMP_FILE"
# Cleanup
trap "rm -f $TEMP_FILE" EXIT

# ✓ Temp directory
TEMP_DIR=$(mktemp -d)
# ...
trap "rm -rf $TEMP_DIR" EXIT

# ✓ Template bilan
TEMP_FILE=$(mktemp /tmp/myapp.XXXXXX)
```

#### 6. Eval - Hech qachon ishlatmang!

```bash
#!/bin/bash

# ✗ XAVFLI: eval
cmd="ls -la"
eval $cmd
# Agar cmd = "ls -la; rm -rf /"

# ✓ XAVFSIZ: To'g'ridan-to'g'ri chaqirish
ls -la

# Agar dinamik buyruq kerak bo'lsa, array ishlating
commands=("ls" "-la")
"${commands[@]}"
```

#### 7. Logging - Sensitive data

```bash
#!/bin/bash

# Log function
log() {
    local level=$1
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" >> /var/log/myapp.log
}

# ✗ XAVFLI: Parolni log qilish
password="secret123"
log INFO "Login with password: $password"

# ✓ XAVFSIZ: Parolni censor qilish
log INFO "Login with password: [REDACTED]"

# ✓ Sensitive data ni mask qilish
mask_sensitive() {
    local data="$1"
    local visible=4
    local length=${#data}
    
    if [ $length -le $visible ]; then
        echo "***"
    else
        echo "${data:0:$visible}$(printf '%*s' $((length - visible)) '' | tr ' ' '*')"
    fi
}

password="secret123"
log INFO "Login with password: $(mask_sensitive "$password")"
# Output: secr*******
```

### Code Style va Convention

#### 1. Naming conventions

```bash
#!/bin/bash

# Constants - UPPER_CASE
readonly MAX_RETRIES=3
readonly CONFIG_FILE="/etc/app.conf"
readonly API_URL="https://api.example.com"

# Variables - lower_case
user_name="sardor"
file_path="/tmp/data.txt"
counter=0

# Functions - lower_case with underscores
check_file_exists() {
    # ...
}

get_user_info() {
    # ...
}

# Private functions - _leading_underscore
_internal_helper() {
    # ...
}
```

#### 2. Comments va documentation

```bash
#!/bin/bash

#############################################
# Script Name: backup.sh
# Description: Automated backup system
# Author: Sardor Aliyev
# Date: 2025-10-24
# Version: 1.0.0
# Usage: ./backup.sh [OPTIONS]
#############################################

# Funktsiya dokumentatsiyasi
#######################################
# Faylni backup qiladi
# Arguments:
#   $1 - Source file path
#   $2 - Destination directory
# Returns:
#   0 - Success
#   1 - Error
#######################################
backup_file() {
    local source="$1"
    local dest="$2"
    
    # Validatsiya
    if [ ! -f "$source" ]; then
        echo "Source file not found" >&2
        return 1
    fi
    
    # Backup
    cp "$source" "$dest/"
    return 0
}

# TODO: Add compression support
# FIXME: Handle symlinks properly
# NOTE: This requires write permission
```

#### 3. Error messages

```bash
#!/bin/bash

# ✓ Yaxshi error messages
log_error() {
    echo "ERROR: $*" >&2
    echo "  Script: ${BASH_SOURCE[0]}" >&2
    echo "  Line: ${BASH_LINENO[0]}" >&2
    echo "  Function: ${FUNCNAME[1]:-main}" >&2
}

# Misol
process_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        log_error "Please check the file path and permissions"
        return 1
    fi
    
    # ...
}
```

### Performance optimization

#### 1. Subshell larni kamaytirish

```bash
# ✗ Sekin: Ko'p subshell
count=0
for i in {1..1000}; do
    count=$(($count + 1))
done

# ✓ Tez: Subshellsiz
count=0
for i in {1..1000}; do
    ((count++))
done
```

#### 2. Built-in commands ishlatish

```bash
# ✗ Sekin: External command
if [ $(echo "$string" | wc -c) -gt 10 ]; then
    echo "Long"
fi

# ✓ Tez: Built-in
if [ ${#string} -gt 10 ]; then
    echo "Long"
fi
```

#### 3. Pipeline optimization

```bash
# ✗ Sekin: Ko'p pipe
cat file.txt | grep "pattern" | sort | uniq

# ✓ Tez: Kamroq
grep "pattern" file.txt | sort -u

# ✗ Sekin: cat abuse
cat file.txt | grep "pattern"

# ✓ Tez: Direct input
grep "pattern" file.txt
```

### Amaliy shablon: Production-ready script

```bash
#!/usr/bin/env bash

#############################################
# Production Script Template
# Barcha best practice lar bilan
#############################################

set -euo pipefail

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly VERSION="1.0.0"
readonly LOG_FILE="${LOG_FILE:-/var/log/${SCRIPT_NAME%.sh}.log}"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Logging
log_info() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*"
    echo -e "${GREEN}${msg}${NC}" | tee -a "$LOG_FILE"
}

log_warn() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $*"
    echo -e "${YELLOW}${msg}${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*"
    echo -e "${RED}${msg}${NC}" >&2 | tee -a "$LOG_FILE"
}

# Cleanup function
cleanup() {
    log_info "Cleaning up..."
    # Vaqtinchalik fayllarni o'chirish
    rm -f /tmp/temp_*
}

# Error handler
error_handler() {
    local line=$1
    log_error "Error occurred at line $line"
    cleanup
    exit 1
}

# Signal handlers
trap cleanup EXIT
trap 'error_handler $LINENO' ERR
trap 'log_warn "Script interrupted"; exit 130' INT TERM

# Requirements check
check_requirements() {
    local -a required_commands=("jq" "curl" "git")
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            log_error "Required command not found: $cmd"
            exit 1
        fi
    done
}

# Input validation
validate_input() {
    local input="$1"
    
    if [ -z "$input" ]; then
        log_error "Input cannot be empty"
        return 1
    fi
    
    # Custom validation logic
    return 0
}

# Main function
main() {
    log_info "Script started (version $VERSION)"
    
    # Requirementsni tekshirish
    check_requirements
    
    # Input validation
    if [ $# -eq 0 ]; then
        log_error "No arguments provided"
        usage
        exit 1
    fi
    
    # Main logic
    log_info "Processing..."
    
    # ...
    
    log_info "Script completed successfully"
}

# Usage
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] ARGS

OPTIONS:
    -v, --version       Show version
    -h, --help          Show help
    -d, --debug         Debug mode
    
EXAMPLES:
    $SCRIPT_NAME file.txt
    $SCRIPT_NAME --debug file.txt
    
EOF
    exit 0
}

# Argument parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            echo "$SCRIPT_NAME version $VERSION"
            exit 0
            ;;
        -h|--help)
            usage
            ;;
        -d|--debug)
            set -x
            shift
            ;;
        -*)
            log_error "Unknown option: $1"
            usage
            ;;
        *)
            INPUT_FILE="$1"
            shift
            ;;
    esac
done

# Run
main "$@"
```

### 📝 Vazifalar:

1. **Vazifa 1:** Shellcheck bilan tozalangan, barcha best practice lar bilan skript yozing
2. **Vazifa 2:** Input validation: email, telefon, IP manzil, URL ni tekshiruvchi funksiyalar
3. **Vazifa 3:** Secure temp file handler: mktemp, permissions, cleanup
4. **Vazifa 4:** Error handling system: log levels, stack trace, alerting
5. **Vazifa 5:** Production template: logging, cleanup, error handling, argument parsing
