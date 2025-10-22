#!/bin/bash

# ===============================
# FUNKTSIYALAR
# ===============================

# Bosh menyu
bosh_menyu() {
    clear
    echo "╔═══════════════════════════════╗"
    echo "║   KUTUBXONA BOSHQARUV TIZIMI   ║"
    echo "╚═══════════════════════════════╝"
    echo ""
    echo "1. Kitob qo'shish"
    echo "2. Kitoblarni ko'rish"
    echo "3. Kitob qidirish"
    echo "4. Kitob o'chirish"
    echo "5. Statistika"
    echo "6. Chiqish"
    echo ""
}

# Kitob qo'shish
kitob_qosh() {
    echo ""
    echo "=== YANGI KITOB ==="
    read -p "Nomi: " nom
    read -p "Muallif: " muallif
    read -p "Yili: " yil
    read -p "Sahifalar: " sahifa
    
    echo "$nom|$muallif|$yil|$sahifa" >> kitoblar.db
    
    yashil "✓ Kitob qo'shildi"
    read -p "Davom etish uchun Enter..."
}

# Kitoblarni ko'rish
kitoblar_korish() {
    echo ""
    echo "=== KITOBLAR RO'YXATI ==="
    
    if [ ! -f kitoblar.db ] || [ ! -s kitoblar.db ]; then
        sari "Kitoblar yo'q"
    else
        echo ""
        printf "%-30s %-20s %-6s %-8s\n" "NOM" "MUALLIF" "YIL" "SAHIFA"
        echo "─────────────────────────────────────────────────────────────────"
        
        while IFS='|' read -r nom muallif yil sahifa; do
            printf "%-30s %-20s %-6s %-8s\n" "$nom" "$muallif" "$yil" "$sahifa"
        done < kitoblar.db
    fi
    
    echo ""
    read -p "Davom etish uchun Enter..."
}

# Kitob qidirish
kitob_qidir() {
    echo ""
    read -p "Qidiruv (nom yoki muallif): " qidiruv
    
    if [ ! -f kitoblar.db ]; then
        sari "Kitoblar yo'q"
    else
        echo ""
        echo "=== QIDIRUV NATIJALARI ==="
        
        topildi=0
        while IFS='|' read -r nom muallif yil sahifa; do
            if [[ $nom == *"$qidiruv"* ]] || [[ $muallif == *"$qidiruv"* ]]; then
                echo ""
                echo "Nomi: $nom"
                echo "Muallif: $muallif"
                echo "Yili: $yil"
                echo "Sahifalar: $sahifa"
                echo "───────────────────────"
                ((topildi++))
            fi
        done < kitoblar.db
        
        if [ $topildi -eq 0 ]; then
            sari "Hech narsa topilmadi"
        else
            yashil "Topildi: $topildi ta"
        fi
    fi
    
    echo ""
    read -p "Davom etish uchun Enter..."
}

# Kitob o'chirish
kitob_ochir() {
    echo ""
    read -p "O'chiriladigan kitob nomi: " nom
    
    if [ ! -f kitoblar.db ]; then
        sari "Kitoblar yo'q"
    else
        if grep -q "^$nom|" kitoblar.db; then
            grep -v "^$nom|" kitoblar.db > kitoblar.tmp
            mv kitoblar.tmp kitoblar.db
            yashil "✓ Kitob o'chirildi"
        else
            qizil "✗ Kitob topilmadi"
        fi
    fi
    
    echo ""
    read -p "Davom etish uchun Enter..."
}

# Statistika
statistika() {
    echo ""
    echo "=== STATISTIKA ==="
    
    if [ ! -f kitoblar.db ] || [ ! -s kitoblar.db ]; then
        sari "Kitoblar yo'q"
    else
        jami=$(wc -l < kitoblar.db)
        echo "Jami kitoblar: $jami"
        
        # Eng ko'p sahifali kitob
        eng_kop=$(sort -t'|' -k4 -nr kitoblar.db | head -1)
        nom=$(echo "$eng_kop" | cut -d'|' -f1)
        sahifa=$(echo "$eng_kop" | cut -d'|' -f4)
        echo "Eng ko'p sahifali: $nom ($sahifa sahifa)"
        
        # O'rtacha sahifa
        jami_sahifa=0
        while IFS='|' read -r _ _ _ sahifa; do
            ((jami_sahifa += sahifa))
        done < kitoblar.db
        ortacha=$((jami_sahifa / jami))
        echo "O'rtacha sahifalar: $ortacha"
    fi
    
    echo ""
    read -p "Davom etish uchun Enter..."
}

# Rang funktsiyalari
qizil() { echo -e "\033[31m$1\033[0m"; }
yashil() { echo -e "\033[32m$1\033[0m"; }
sari() { echo -e "\033[33m$1\033[0m"; }

# ===============================
# ASOSIY DASTUR
# ===============================

while true; do
    bosh_menyu
    read -p "Tanlovingiz: " tanlov
    
    case $tanlov in
        1) kitob_qosh ;;
        2) kitoblar_korish ;;
        3) kitob_qidir ;;
        4) kitob_ochir ;;
        5) statistika ;;
        6)
            yashil "Xayr!"
            exit 0
            ;;
        *)
            qizil "Noto'g'ri tanlov!"
            sleep 1
            ;;
    esac
done