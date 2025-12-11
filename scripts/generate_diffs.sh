#!/bin/bash

# Script para generar diffs de componentes específicos
# Útil para análisis detallado de cambios

MODIFIED_APP="$1"
ORIGINAL_APP="$2"
OUTPUT_DIR="${3:-/tmp/tiktok_diffs}"

if [ -z "$MODIFIED_APP" ] || [ -z "$ORIGINAL_APP" ]; then
    echo "Uso: $0 <app_modificada> <app_original> [directorio_salida]"
    echo ""
    echo "Ejemplo:"
    echo "  $0 com_zhiliaoapp_musically_3 com_zhiliaoapp_musically_4"
    exit 1
fi

echo "========================================="
echo "Generador de Diffs Específicos"
echo "========================================="
echo ""

mkdir -p "$OUTPUT_DIR"

# 1. Diff de AndroidManifest
echo "1. Generando diff de AndroidManifest.xml..."
diff -u "$ORIGINAL_APP/AndroidManifest.xml" "$MODIFIED_APP/AndroidManifest.xml" > "$OUTPUT_DIR/AndroidManifest.diff" 2>&1
if [ $? -eq 0 ]; then
    echo "   ⚠ Sin diferencias"
else
    echo "   ✓ Guardado en AndroidManifest.diff"
fi

# 2. Diff de apktool.yml
echo "2. Generando diff de apktool.yml..."
diff -u "$ORIGINAL_APP/apktool.yml" "$MODIFIED_APP/apktool.yml" > "$OUTPUT_DIR/apktool.diff" 2>&1
if [ $? -eq 0 ]; then
    echo "   ⚠ Sin diferencias"
else
    echo "   ✓ Guardado en apktool.diff"
fi

# 3. Lista de archivos nuevos
echo "3. Listando archivos nuevos..."
(cd "$MODIFIED_APP" && find . -name "*.smali" | sort) > /tmp/mod_files.txt
(cd "$ORIGINAL_APP" && find . -name "*.smali" | sort) > /tmp/orig_files.txt
comm -23 /tmp/mod_files.txt /tmp/orig_files.txt > "$OUTPUT_DIR/new_files.txt"
NEW_COUNT=$(wc -l < "$OUTPUT_DIR/new_files.txt")
echo "   ✓ $NEW_COUNT archivos nuevos listados"

# 4. Archivos eliminados
echo "4. Listando archivos eliminados..."
comm -13 /tmp/mod_files.txt /tmp/orig_files.txt > "$OUTPUT_DIR/deleted_files.txt"
DEL_COUNT=$(wc -l < "$OUTPUT_DIR/deleted_files.txt")
echo "   ✓ $DEL_COUNT archivos eliminados listados"

# 5. Muestras de diffs de clases importantes
echo "5. Generando diffs de muestra..."

# Feed classes
mkdir -p "$OUTPUT_DIR/samples/feed"
FEED_SAMPLE=0
for file in $((cd "$ORIGINAL_APP" && find ./smali*/com/ss/android/ugc/aweme/feed -name "*.smali" 2>/dev/null) | head -10); do
    if [ -f "$MODIFIED_APP/$file" ]; then
        basename_file=$(basename "$file")
        diff -u "$ORIGINAL_APP/$file" "$MODIFIED_APP/$file" > "$OUTPUT_DIR/samples/feed/${basename_file}.diff" 2>&1
        if [ $? -ne 0 ]; then
            FEED_SAMPLE=$((FEED_SAMPLE + 1))
        else
            rm "$OUTPUT_DIR/samples/feed/${basename_file}.diff"
        fi
    fi
done
echo "   ✓ $FEED_SAMPLE diffs de muestra de feed generados"

# 6. Resumen
echo "6. Generando resumen..."
cat > "$OUTPUT_DIR/SUMMARY.txt" << EOF
Resumen de Diferencias TikTok v42.9.3
=====================================

Archivos Nuevos: $NEW_COUNT
Archivos Eliminados: $DEL_COUNT

Archivos Generados:
- AndroidManifest.diff - Cambios en el manifest
- apktool.diff - Cambios en configuración
- new_files.txt - Lista de archivos nuevos
- deleted_files.txt - Lista de archivos eliminados
- samples/ - Diffs de muestra de clases modificadas

Cambios Principales:
1. Permisos de ubicación y ads deshabilitados
2. Shared user ID añadido
3. Nuevos componentes: CrashActivity, KillAppReceiver
4. Biblioteca nativa libtigrik.so añadida
5. Metadata de Google Ads removida

Archivos Destacados:
$(head -20 "$OUTPUT_DIR/new_files.txt")

Para más detalles, consulta los archivos .diff individuales.
EOF

cat "$OUTPUT_DIR/SUMMARY.txt"

echo ""
echo "========================================="
echo "Diffs generados en: $OUTPUT_DIR"
echo "========================================="
