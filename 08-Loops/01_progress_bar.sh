#!/bin/bash

echo "Yuklanmoqda..."

for i in {1..100}; do
    # Progress bar chizish
    printf "\r["
    
    # To'ldirilgan qism
    for ((j=0; j<i/2; j++)); do
        printf "="
    done
    
    # Bo'sh qism
    for ((j=i/2; j<50; j++)); do
        printf " "
    done
    
    printf "] %d%%" $i
    sleep 0.05
done

echo ""
echo "✓ Tayyor!"