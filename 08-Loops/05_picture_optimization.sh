#!/bin/bash

echo "=== RASMLARNI OPTIMIZATSIYA ===="

if ! command -v convert &> /dev/null; then
    echo "✗ ImageMagick o'rnatilmagan!"
    echo "O'rnatish: sudo apt install imagemagick"
    exit 1
fi

read -p "Sifat (1-100, tavsiya 85): " sifat
sifat=${sifat:-85}

mkdir -p optimized

jami=0
muvaffaqiyatli=0

for rasm in *.jpg *.png *.jpeg; do
    if [ -f "$rasm" ]; then
        ((jami++))
        
        echo -n "[$jami] $rasm ... "
        
        asl_hajm=$(stat -f%z "$rasm" 2>/dev/null || stat -c%s "$rasm")
        
        if convert "$rasm" -quality $sifat "optimized/$rasm"; then
            yangi_hajm=$(stat -f%z "optimized/$rasm" 2>/dev/null || stat -c%s "optimized/$rasm")
            
            # Hajm farqi
            farq=$((asl_hajm - yangi_hajm))
            foiz=$((farq * 100 / asl_hajm))
            
            if [ $farq -gt 0 ]; then
                echo "✓ -${foiz}% ($(echo "scale=1; $farq/1024" | bc)KB)"
                ((muvaffaqiyatli++))
            else
                echo "○ O'zgarmadi"
            fi
        else
            echo "✗ Xato!"
        fi
    fi
done

if [ $jami -eq 0 ]; then
    echo "Rasmlar topilmadi!"
else
    echo ""
    echo "=== NATIJA ==="
    echo "Jami: $jami"
    echo "Optimizatsiya qilindi: $muvaffaqiyatli"
fi