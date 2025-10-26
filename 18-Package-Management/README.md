## 1️⃣8️⃣ PAKET BOSHQARUV
**Global nomi:** Package Management  
**O'zbek nomi:** Paket boshqaruv

### APT (Debian/Ubuntu)

```bash
# Paketlar ro'yxatini yangilash
sudo apt update

# Tizimni yangilash
sudo apt upgrade

# Full upgrade (eski paketlarni o'chirish)
sudo apt full-upgrade

# Paket o'rnatish
sudo apt install nginx

# Ko'p paketlar
sudo apt install nginx mysql-server php

# Paket o'chirish
sudo apt remove nginx

# To'liq o'chirish (config bilan)
sudo apt purge nginx

# Paket qidirish
apt search nginx

# Paket haqida ma'lumot
apt show nginx

# O'rnatilgan paketlar
apt list --installed

# Yangilanishi kerak bo'lgan paketlar
apt list --upgradable

# Foydalanilmayotgan paketlarni tozalash
sudo apt autoremove

# Cache tozalash
sudo apt clean
sudo apt autoclean

# Broken packages tuzatish
sudo apt --fix-broken install
```

**Amaliy skript:**

```bash
#!/bin/bash

# Tizimni yangilash
echo "=== SYSTEM UPDATE ==="

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt clean

echo "✓ Update complete"

# Yangilanish kerak bo'lgan paketlar
upgradable=$(apt list --upgradable 2>/dev/null | grep -c upgradable)

if [ $upgradable -gt 0 ]; then
    echo "⚠ $upgradable paket yangilanishi kerak"
else
    echo "✓ Barcha paketlar yangi"
fi
```

### YUM/DNF (RHEL/CentOS/Fedora)

```bash
# Paketlar ro'yxatini yangilash
sudo yum check-update
sudo dnf check-update

# Paket o'rnatish
sudo yum install nginx
sudo dnf install nginx

# Paket o'chirish
sudo yum remove nginx
sudo dnf remove nginx

# Tizimni yangilash
sudo yum update
sudo dnf update

# Paket qidirish
yum search nginx
dnf search nginx

# Paket haqida ma'lumot
yum info nginx
dnf info nginx

# O'rnatilgan paketlar
yum list installed
dnf list installed

# Repository lar
yum repolist
dnf repolist

# Cache tozalash
sudo yum clean all
sudo dnf clean all

# Grouplar
sudo yum groupinstall "Development Tools"
sudo dnf groupinstall "Development Tools"
```

### Pacman (Arch Linux)

```bash
# Tizimni yangilash
sudo pacman -Syu

# Paket o'rnatish
sudo pacman -S nginx

# Paket o'chirish
sudo pacman -R nginx

# To'liq o'chirish (dependencies bilan)
sudo pacman -Rns nginx

# Paket qidirish
pacman -Ss nginx

# O'rnatilgan paketlarni qidirish
pacman -Qs nginx

# Paket haqida ma'lumot
pacman -Si nginx

# O'rnatilgan paket haqida
pacman -Qi nginx

# Orphaned paketlarni o'chirish
sudo pacman -Rns $(pacman -Qtdq)

# Cache tozalash
sudo pacman -Sc
```

### Snap (Universal packages)

```bash
# Snap o'rnatish
sudo apt install snapd

# Paket o'rnatish
sudo snap install code --classic

# O'rnatilgan paketlar
snap list

# Paket yangilash
sudo snap refresh code

# Barcha paketlarni yangilash
sudo snap refresh

# Paket o'chirish
sudo snap remove code

# Paket qidirish
snap find "text editor"

# Paket haqida ma'lumot
snap info code
```

### Flatpak (Universal packages)

```bash
# Flatpak o'rnatish
sudo apt install flatpak

# Repository qo'shish
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Paket o'rnatish
flatpak install flathub org.gimp.GIMP

# O'rnatilgan paketlar
flatpak list

# Paket ishlatish
flatpak run org.gimp.GIMP

# Paket yangilash
flatpak update org.gimp.GIMP

# Barcha paketlarni yangilash
flatpak update

# Paket o'chirish
flatpak uninstall org.gimp.GIMP
```

### From Source (Manba koddan o'rnatish)

```bash
# Dependencies o'rnatish
sudo apt install build-essential

# Download
wget https://example.com/software-1.0.tar.gz
tar -xzf software-1.0.tar.gz
cd software-1.0

# Configure
./configure --prefix=/usr/local

# Compile
make

# Install
sudo make install

# Uninstall (agar Makefile da bo'lsa)
sudo make uninstall
```

**Amaliy skript:**

```bash
#!/bin/bash

install_from_source() {
    local url=$1
    local name=$(basename "$url" .tar.gz)
    
    echo "=== Installing $name from source ==="
    
    # Download
    wget "$url" -O "/tmp/$name.tar.gz"
    
    # Extract
    tar -xzf "/tmp/$name.tar.gz" -C /tmp
    
    # Build
    cd "/tmp/$name"
    ./configure --prefix=/usr/local
    make
    sudo make install
    
    # Cleanup
    cd -
    rm -rf "/tmp/$name" "/tmp/$name.tar.gz"
    
    echo "✓ $name installed"
}

# Usage
install_from_source "https://example.com/app-1.0.tar.gz"
```

### Amaliy loyiha: Package manager

```bash
#!/bin/bash

#############################################
# UNIVERSAL PACKAGE MANAGER WRAPPER
#############################################

set -euo pipefail

# Detect OS and package manager
detect_pm() {
    if command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

PM=$(detect_pm)

if [ "$PM" = "unknown" ]; then
    echo "✗ Package manager not detected"
    exit 1
fi

# Update
pm_update() {
    echo "=== Updating package lists ==="
    
    case $PM in
        apt)
            sudo apt update
            ;;
        dnf|yum)
            sudo $PM check-update || true
            ;;
        pacman)
            sudo pacman -Sy
            ;;
    esac
}

# Upgrade
pm_upgrade() {
    echo "=== Upgrading system ==="
    
    case $PM in
        apt)
            sudo apt upgrade -y
            ;;
        dnf|yum)
            sudo $PM upgrade -y
            ;;
        pacman)
            sudo pacman -Syu --noconfirm
            ;;
    esac
}

# Install
pm_install() {
    local packages=("$@")
    
    echo "=== Installing: ${packages[*]} ==="
    
    case $PM in
        apt)
            sudo apt install -y "${packages[@]}"
            ;;
        dnf|yum)
            sudo $PM install -y "${packages[@]}"
            ;;
        pacman)
            sudo pacman -S --noconfirm "${packages[@]}"
            ;;
    esac
}

# Remove
pm_remove() {
    local packages=("$@")
    
    echo "=== Removing: ${packages[*]} ==="
    
    case $PM in
        apt)
            sudo apt remove -y "${packages[@]}"
            ;;
        dnf|yum)
            sudo $PM remove -y "${packages[@]}"
            ;;
        pacman)
            sudo pacman -R --noconfirm "${packages[@]}"
            ;;
    esac
}

# Search
pm_search() {
    local query=$1
    
    echo "=== Searching: $query ==="
    
    case $PM in
        apt)
            apt search "$query"
            ;;
        dnf|yum)
            $PM search "$query"
            ;;
        pacman)
            pacman -Ss "$query"
            ;;
    esac
}

# Info
pm_info() {
    local package=$1
    
    case $PM in
        apt)
            apt show "$package"
            ;;
        dnf|yum)
            $PM info "$package"
            ;;
        pacman)
            pacman -Si "$package"
            ;;
    esac
}

# Clean
pm_clean() {
    echo "=== Cleaning cache ==="
    
    case $PM in
        apt)
            sudo apt autoremove -y
            sudo apt clean
            ;;
        dnf|yum)
            sudo $PM autoremove -y
            sudo $PM clean all
            ;;
        pacman)
            sudo pacman -Sc --noconfirm
            ;;
    esac
}

# List installed
pm_list() {
    case $PM in
        apt)
            apt list --installed
            ;;
        dnf|yum)
            $PM list installed
            ;;
        pacman)
            pacman -Q
            ;;
    esac
}

# Usage
usage() {
    cat << EOF
Universal Package Manager Wrapper
Detected: $PM

Usage: $0 COMMAND [ARGS]

COMMANDS:
    update              Update package lists
    upgrade             Upgrade all packages
    install PKG...      Install packages
    remove PKG...       Remove packages
    search QUERY        Search packages
    info PKG            Package information
    clean               Clean cache
    list                List installed packages
    
EXAMPLES:
    $0 update
    $0 install nginx mysql
    $0 search python
    $0 clean
EOF
    exit 0
}

# Main
case ${1:-help} in
    update)
        pm_update
        ;;
    upgrade)
        pm_update
        pm_upgrade
        pm_clean
        ;;
    install)
        shift
        pm_install "$@"
        ;;
    remove)
        shift
        pm_remove "$@"
        ;;
    search)
        pm_search "$2"
        ;;
    info)
        pm_info "$2"
        ;;
    clean)
        pm_clean
        ;;
    list)
        pm_list
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        echo "Unknown command: $1"
        usage
        ;;
esac
```

### 📝 Vazifalar:

1. **Vazifa 1:** Tizimni avtomatik yangilovchi skript (update, upgrade, cleanup)
2. **Vazifa 2:** Ko'p paketlarni bir vaqtda o'rnatuvchi skript (ro'yxat fayldan)
3. **Vazifa 3:** Package manager detector: OS ni aniqlaydi va mos buyruqlarni ishlatadi
4. **Vazifa 4:** Backup qiluvchi skript: o'rnatilgan paketlar ro'yxatini saqlaydi va qayta o'rnatadi
5. **Vazifa 5:** Security updates checker: faqat xavfsizlik yangilanishlarini o'rnatadi

---