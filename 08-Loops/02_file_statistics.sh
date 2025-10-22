#!/bin/bash

echo "=== FAYL STATISTIKASI ==="

jami_fayllar=0
jami_kataloglar=0
jami_hajm=0

for element in *; do
    if [ -f "$element" ]; then
        ((jami_fayllar++))
        hajm=$(stat -f%z "$element" 2>/dev/null || stat -c%s "$element" 2>/dev/null)
        ((jami_hajm += hajm))
    elif [ -d "$element" ]; then
        ((jami_kataloglar++))
    fi
done

echo "Fayllar: $jami_fayllar"
echo "Kataloglar: $jami_kataloglar"
echo "Umumiy hajm: $(echo "scale=2; $jami_hajm/1024/1024" | bc) MB"