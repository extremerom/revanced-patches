#!/bin/bash

# Script para generar parches unificados de archivos smali modificados
# Analiza solo las modificaciones reales, no los archivos nuevos
# Autor: Análisis automatizado de diferencias

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
MODIFIED_APP="$1"
ORIGINAL_APP="$2"
OUTPUT_DIR="${3:-patches/tiktok-v42.9.3}"

if [ -z "$MODIFIED_APP" ] || [ -z "$ORIGINAL_APP" ]; then
    echo -e "${RED}Uso: $0 <app_modificada> <app_original> [directorio_salida]${NC}"
    echo ""
    echo "Ejemplo:"
    echo "  $0 com_zhiliaoapp_musically_3 com_zhiliaoapp_musically_4"
    echo ""
    echo "Este script analiza los archivos smali y genera parches solo para"
    echo "los archivos que fueron realmente modificados (no archivos nuevos)."
    exit 1
fi

if [ ! -d "$MODIFIED_APP" ]; then
    echo -e "${RED}Error: Directorio de app modificada no existe: $MODIFIED_APP${NC}"
    exit 1
fi

if [ ! -d "$ORIGINAL_APP" ]; then
    echo -e "${RED}Error: Directorio de app original no existe: $ORIGINAL_APP${NC}"
    exit 1
fi

echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Generador de Parches Smali Inteligente${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}App Modificada:${NC} $MODIFIED_APP"
echo -e "${BLUE}App Original:${NC} $ORIGINAL_APP"
echo -e "${BLUE}Salida:${NC} $OUTPUT_DIR"
echo ""

# Crear directorio de salida
mkdir -p "$OUTPUT_DIR"

# Archivo de salida principal
MAIN_PATCH="$OUTPUT_DIR/005-smali-modifications.patch"
STATS_FILE="$OUTPUT_DIR/smali-patch-stats.txt"

# Limpiar archivos anteriores
> "$MAIN_PATCH"
> "$STATS_FILE"

echo -e "${YELLOW}[1/5] Analizando archivos smali comunes...${NC}"

# Encontrar archivos smali comunes entre ambas apps
echo "Buscando archivos comunes..."
TEMP_COMMON="/tmp/common_smali_$$.txt"
comm -12 \
    <(cd "$ORIGINAL_APP" && find . -name "*.smali" -type f | sort) \
    <(cd "$MODIFIED_APP" && find . -name "*.smali" -type f | sort) \
    > "$TEMP_COMMON"

TOTAL_COMMON=$(wc -l < "$TEMP_COMMON")
echo -e "${GREEN}✓ Encontrados $TOTAL_COMMON archivos smali comunes${NC}"
echo ""

echo -e "${YELLOW}[2/5] Comparando archivos para detectar modificaciones...${NC}"

# Contadores
MODIFIED_COUNT=0
IDENTICAL_COUNT=0
PROCESSED=0
SAMPLE_SIZE=0

# Arrays para tracking
declare -a MODIFIED_FILES

# Comparar archivos y encontrar los modificados
while IFS= read -r file; do
    PROCESSED=$((PROCESSED + 1))
    
    # Mostrar progreso cada 1000 archivos
    if [ $((PROCESSED % 1000)) -eq 0 ]; then
        echo -e "  Procesados: $PROCESSED/$TOTAL_COMMON archivos..."
    fi
    
    ORIGINAL_FILE="$ORIGINAL_APP/$file"
    MODIFIED_FILE="$MODIFIED_APP/$file"
    
    # Comparar archivos
    if ! cmp -s "$ORIGINAL_FILE" "$MODIFIED_FILE"; then
        MODIFIED_FILES+=("$file")
        MODIFIED_COUNT=$((MODIFIED_COUNT + 1))
    else
        IDENTICAL_COUNT=$((IDENTICAL_COUNT + 1))
    fi
    
done < "$TEMP_COMMON"

echo -e "${GREEN}✓ Análisis completado${NC}"
echo -e "  - Archivos idénticos: ${GREEN}$IDENTICAL_COUNT${NC}"
echo -e "  - Archivos modificados: ${YELLOW}$MODIFIED_COUNT${NC}"
echo ""

if [ $MODIFIED_COUNT -eq 0 ]; then
    echo -e "${YELLOW}No se encontraron modificaciones en archivos smali comunes.${NC}"
    rm -f "$TEMP_COMMON"
    exit 0
fi

echo -e "${YELLOW}[3/5] Generando parches unificados...${NC}"

# Escribir encabezado del patch
cat > "$MAIN_PATCH" << 'EOF'
# Parche unificado de modificaciones smali - TikTok v42.9.3
# Este archivo contiene todos los cambios en archivos smali existentes
# No incluye archivos nuevos (ver 003-new-classes-list.txt)
#
# Aplicar con:
#   cd /path/to/original_app
#   patch -p1 < 005-smali-modifications.patch
#
# Nota: Este es un parche grande. Contiene solo modificaciones reales.
# Los archivos con cambios sistemáticos (instrucciones duplicadas) están incluidos.

EOF

# Generar patches individuales y combinarlos
PATCH_COUNT=0
TOTAL_LINES=0

for file in "${MODIFIED_FILES[@]}"; do
    PATCH_COUNT=$((PATCH_COUNT + 1))
    
    # Mostrar progreso cada 100 archivos
    if [ $((PATCH_COUNT % 100)) -eq 0 ]; then
        echo -e "  Generando patch $PATCH_COUNT/$MODIFIED_COUNT..."
    fi
    
    ORIGINAL_FILE="$ORIGINAL_APP/$file"
    MODIFIED_FILE="$MODIFIED_APP/$file"
    
    # Generar diff unificado
    # Usar -p1 format (strip leading ./)
    FILE_PATH="${file#./}"
    
    diff -u "a/$FILE_PATH" "b/$FILE_PATH" \
        --label "a/$FILE_PATH" \
        --label "b/$FILE_PATH" \
        "$ORIGINAL_FILE" "$MODIFIED_FILE" >> "$MAIN_PATCH" 2>/dev/null || true
    
    # Contar líneas del diff
    LINES=$(diff -u "$ORIGINAL_FILE" "$MODIFIED_FILE" 2>/dev/null | wc -l || echo 0)
    TOTAL_LINES=$((TOTAL_LINES + LINES))
done

echo -e "${GREEN}✓ Parches generados${NC}"
echo ""

echo -e "${YELLOW}[4/5] Generando estadísticas...${NC}"

# Calcular tamaño del patch
PATCH_SIZE=$(du -h "$MAIN_PATCH" | cut -f1)

# Generar archivo de estadísticas
cat > "$STATS_FILE" << EOF
Estadísticas del Parche Smali - TikTok v42.9.3
═════════════════════════════════════════════════════════

RESUMEN
-------
Archivos comunes analizados:    $TOTAL_COMMON
Archivos idénticos:              $IDENTICAL_COUNT
Archivos modificados:            $MODIFIED_COUNT
Tasa de modificación:            $(awk "BEGIN {printf \"%.2f\", ($MODIFIED_COUNT * 100.0 / $TOTAL_COMMON)}")%

PARCHE GENERADO
---------------
Archivo:                         005-smali-modifications.patch
Tamaño:                          $PATCH_SIZE
Líneas totales de diff:          $TOTAL_LINES
Número de archivos parcheados:  $MODIFIED_COUNT

ARCHIVOS MODIFICADOS (muestra de primeros 50)
---------------------------------------------
EOF

# Añadir lista de primeros 50 archivos modificados
for i in "${!MODIFIED_FILES[@]}"; do
    if [ $i -lt 50 ]; then
        echo "${MODIFIED_FILES[$i]}" >> "$STATS_FILE"
    fi
done

if [ $MODIFIED_COUNT -gt 50 ]; then
    echo "... y $((MODIFIED_COUNT - 50)) archivos más" >> "$STATS_FILE"
fi

cat >> "$STATS_FILE" << EOF

NOTAS
-----
- Este parche incluye SOLO archivos que fueron modificados
- Los archivos nuevos (me.tigrik, tigrik0) no están incluidos aquí
- Ver 003-new-classes-list.txt para archivos nuevos
- Muchos archivos tienen cambios sistemáticos (instrucciones duplicadas)
- El patrón de duplicación sugiere modificación automatizada del bytecode

USO
---
Para aplicar este parche:

1. Tener la app original descompilada
2. Aplicar el parche:
   cd /path/to/app_original
   patch -p1 < $OUTPUT_DIR/005-smali-modifications.patch

3. Copiar archivos nuevos (me.tigrik, tigrik0)
4. Copiar bibliotecas nativas (libtigrik.so)
5. Aplicar parches de manifest y config
6. Recompilar con apktool

O usar el script automatizado:
   bash scripts/patch_tiktok_42.9.3.sh original_app output_app

ADVERTENCIA
-----------
Este es un parche muy grande ($MODIFIED_COUNT archivos).
La aplicación puede tardar varios minutos.
Asegúrate de tener suficiente espacio en disco y memoria.
EOF

echo -e "${GREEN}✓ Estadísticas generadas${NC}"
echo ""

echo -e "${YELLOW}[5/5] Generando índice de archivos modificados...${NC}"

# Crear lista completa de archivos modificados
MODIFIED_LIST="$OUTPUT_DIR/smali-modified-files.txt"
printf "%s\n" "${MODIFIED_FILES[@]}" > "$MODIFIED_LIST"

echo -e "${GREEN}✓ Índice generado${NC}"
echo ""

# Limpiar archivos temporales
rm -f "$TEMP_COMMON"

# Mostrar resumen
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Generación Completada${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}Archivos generados:${NC}"
echo -e "  📄 ${YELLOW}005-smali-modifications.patch${NC} ($PATCH_SIZE)"
echo -e "     Parche unificado con todas las modificaciones"
echo ""
echo -e "  📊 ${YELLOW}smali-patch-stats.txt${NC}"
echo -e "     Estadísticas y documentación del parche"
echo ""
echo -e "  📋 ${YELLOW}smali-modified-files.txt${NC}"
echo -e "     Lista completa de archivos modificados"
echo ""
echo -e "${BLUE}Estadísticas:${NC}"
echo -e "  Total de archivos modificados: ${GREEN}$MODIFIED_COUNT${NC}"
echo -e "  Total de líneas de diff: ${GREEN}$TOTAL_LINES${NC}"
echo -e "  Tamaño del parche: ${GREEN}$PATCH_SIZE${NC}"
echo ""
echo -e "${YELLOW}Para aplicar el parche:${NC}"
echo -e "  cd /path/to/app_original"
echo -e "  patch -p1 < $OUTPUT_DIR/005-smali-modifications.patch"
echo ""
echo -e "${YELLOW}O usar el script automatizado:${NC}"
echo -e "  bash scripts/patch_tiktok_42.9.3.sh original_app output_app"
echo ""

# Mostrar vista previa del archivo de estadísticas
echo -e "${BLUE}Vista previa de estadísticas:${NC}"
echo -e "${YELLOW}─────────────────────────────────────────────────${NC}"
head -30 "$STATS_FILE"
echo -e "${YELLOW}─────────────────────────────────────────────────${NC}"
echo ""
echo -e "Ver archivo completo: ${GREEN}$STATS_FILE${NC}"
echo ""
