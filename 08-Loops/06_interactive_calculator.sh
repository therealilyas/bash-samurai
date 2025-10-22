#!/bin/bash

echo "=== KALKULATOR ==="
echo "Buyruqlar: +, -, *, /, ^, %, clear, exit"
echo ""

natija=0

while true; do
    echo "Hozirgi natija: $natija"
    echo ""
    
    # Amal tanlash
    PS3="Amal tanlang: "
    select amal in "Qo'shish (+)" "Ayirish (-)" "Ko'paytirish (*)" "Bo'lish (/)" "Daraja (^)" "Qoldiq (%)" "Tozalash" "Chiqish"; do
        case $REPLY in
            1) oper="+"; break ;;
            2) oper="-"; break ;;
            3) oper="*"; break ;;
            4) oper="/"; break ;;
            5) oper="^"; break ;;
            6) oper="%"; break ;;
            7)
                natija=0
                echo "✓ Tozalandi"
                break 2  # Tashqi siklga qaytish
                ;;
            8)
                echo "Xayr!"
                exit 0
                ;;
            *)
                echo "✗ Noto'g'ri tanlov!"
                continue
                ;;
        esac
    done
    
    read -p "Son kiriting: " son
    
    case $oper in
        "+")
            natija=$((natija + son))
            ;;
        "-")
            natija=$((natija - son))
            ;;
        "*")
            natija=$((natija * son))
            ;;
        "/")
            if [ $son -eq 0 ]; then
                echo "✗ 0 ga bo'lib bo'lmaydi!"
                continue
            fi
            natija=$(echo "scale=2; $natija / $son" | bc)
            ;;
        "^")
            natija=$((natija ** son))
            ;;
        "%")
            natija=$((natija % son))
            ;;
    esac
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━"
done