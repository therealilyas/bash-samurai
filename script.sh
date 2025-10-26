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

    cat > "$script_name" << EOF
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
log_info() { echo -e "\${GREEN}[INFO]\${NC} \$1"; }
log_error() { echo -e "\${RED}[ERROR]\${NC} \$1" >&2; }
log_warning() { echo -e "\${YELLOW}[WARNING]\${NC} \$1"; }

# Cleanup
cleanup() { log_info "Tozalash..."; }
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
Foydalanish: \$0 [OPTIONS]

OPTIONS:
    -h, --help      Yordam
    -v, --verbose   Batafsil

USAGE
    exit 0
}

# Argumentlar
while [[ \$# -gt 0 ]]; do
    case \$1 in
        -h|--help) usage ;;
        -v|--verbose) set -x; shift ;;
        *) log_error "Noma'lum argument: \$1"; usage ;;
    esac
done

main "\$@"
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

    cat > "$script_name" << EOF
#!/bin/bash

set -euo pipefail

# Cleanup
cleanup() { echo "[DEBUG] Tozalash..."; }
trap cleanup EXIT INT TERM

# Debug
DEBUG=\${DEBUG:-0}
debug() { [[ "\$DEBUG" -eq 1 ]] && echo "[DEBUG] \$*" >&2; }

# Logging
readonly LOG_FILE="/tmp/\${0##*/}.log"
log() { local level=\$1; shift; echo "[$(date '+%Y-%m-%d %H:%M:%S')] [\$level] \$*" | tee -a "\$LOG_FILE"; }

# Xatolarni boshqarish
error_handler() { log ERROR "Xato \$1-qatorda"; cleanup; exit 1; }
trap 'error_handler $LINENO' ERR

# Argument parsing
parse_args() {
    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -h|--help) usage ;;
            -d|--debug) DEBUG=1; set -x; shift ;;
            *) log ERROR "Noma'lum: \$1"; usage ;;
        esac
    done
}

usage() {
    cat << EOF2
Foydalanish: \$0 [OPTIONS]

OPTIONS:
    -h, --help    Yordam
    -d, --debug   Debug rejimi
EOF2
    exit 0
}

main() {
    parse_args "\$@"
    log INFO "Boshlandi"
    # Kod
    log INFO "Tugadi"
}

main "\$@"
EOF

    chmod +x "$script_name"
    echo "✓ Advanced skript yaratildi: $script_name"
}

# CLI
case ${1:-} in
    basic) shift; generate_basic "$@" ;;
    advanced) shift; generate_advanced "$@" ;;
    *)
        echo "Foydalanish:"
        echo "  $0 basic SCRIPT_NAME 'Description'"
        echo "  $0 advanced SCRIPT_NAME"
        exit 1
        ;;
esac

