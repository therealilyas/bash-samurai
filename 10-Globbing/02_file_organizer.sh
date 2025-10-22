#!/bin/bash

shopt -s nullglob  # Bo'sh glob dan xato bermaslik

echo "=== FAYL ORGANIZATORI ==="
echo "Katalog: $(pwd)"
echo ""

# Hisoblagichlar
jami=0
suratrlar=0
hujjatlar=0
videoar=0
musiqa=0
arxivlar=0
boshqalar=0

# Papkalar yaratish
mkdir -p Sorted/{Images,Documents,Videos,Music,Archives,Others}

# Rasmlar
for fayl in *.{jpg,jpeg,png,gif,bmp,svg}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Images/
    echo "📷 $fayl → Images/"
    ((suratlar++))
    ((jami++))
done

# Hujjatlar
for fayl in *.{txt,doc,docx,pdf,odt,xls,xlsx,ppt,pptx}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Documents/
    echo "📄 $fayl → Documents/"
    ((hujjatlar++))
    ((jami++))
done

# Videolar
for fayl in *.{mp4,avi,mkv,mov,wmv,flv}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Videos/
    echo "🎬 $fayl → Videos/"
    ((videoar++))
    ((jami++))
done

# Musiqa
for fayl in *.{mp3,wav,flac,aac,ogg}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Music/
    echo "🎵 $fayl → Music/"
    ((musiqa++))
    ((jami++))
done

# Arxivlar
for fayl in *.{zip,tar,gz,bz2,7z,rar}; do
    [ -f "$fayl" ] || continue
    mv "$fayl" Sorted/Archives/
    echo "📦 $fayl → Archives/"
    ((arxivlar++))
    ((jami++))
done

# Boshqalar
for fayl in *; do
    [ -f "$fayl" ] || continue
    [ "$fayl" != "$(basename $0)" ] || continue  # Skriptni o'chirmaslik
    mv "$fayl" Sorted/Others/
    echo "📎 $fayl → Others/"
    ((boshqalar++))
    ((jami++))
done

# Natija
echo ""
echo "=== NATIJA ==="
echo "Jami ko'chirildi: $jami"
echo "  Suratlar: $suratlar"
echo "  Hujjatlar: $hujjatlar"
echo "  Videolar: $videoar"
echo "  Musiqa: $musiqa"
echo "  Arxivlar: $arxivlar"
echo "  Boshqalar: $boshqalar"

# Bo'sh papkalarni o'chirish
find Sorted -type d -empty -delete