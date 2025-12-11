#!/bin/bash

# Script automatizado para parchear TikTok v42.9.3
# Aplica las modificaciones encontradas en la app modificada
# Autor: Análisis automático de diferencias

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuración
ORIGINAL_APP_DIR="$1"
OUTPUT_DIR="$2"

if [ -z "$ORIGINAL_APP_DIR" ] || [ -z "$OUTPUT_DIR" ]; then
    echo -e "${RED}Uso: $0 <directorio_app_original> <directorio_salida>${NC}"
    echo ""
    echo "Ejemplo:"
    echo "  $0 /path/to/original_app /path/to/patched_app"
    exit 1
fi

if [ ! -d "$ORIGINAL_APP_DIR" ]; then
    echo -e "${RED}Error: El directorio de la app original no existe: $ORIGINAL_APP_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}TikTok v42.9.3 Auto-Patcher${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

# Crear directorio de salida
mkdir -p "$OUTPUT_DIR"

# Copiar app original al directorio de salida
echo -e "${YELLOW}1. Copiando app original...${NC}"
cp -r "$ORIGINAL_APP_DIR"/* "$OUTPUT_DIR/"
echo -e "${GREEN}   ✓ App copiada${NC}"
echo ""

# Parche 1: AndroidManifest.xml
echo -e "${YELLOW}2. Aplicando parches a AndroidManifest.xml...${NC}"

MANIFEST="$OUTPUT_DIR/AndroidManifest.xml"

if [ ! -f "$MANIFEST" ]; then
    echo -e "${RED}   Error: AndroidManifest.xml no encontrado${NC}"
    exit 1
fi

# 2.1 Cambiar installLocation
echo -e "   - Cambiando installLocation a internalOnly..."
sed -i 's/android:installLocation="auto"/android:installLocation="internalOnly"/g' "$MANIFEST"

# 2.2 Añadir sharedUserId
echo -e "   - Añadiendo sharedUserId..."
sed -i 's/<manifest\([^>]*\)package="com.zhiliaoapp.musically"/<manifest\1android:sharedUserId="TikTok.Mod.Cloud" package="com.zhiliaoapp.musically"/g' "$MANIFEST"

# 2.3 Deshabilitar permisos de ubicación y ads
echo -e "   - Deshabilitando permisos de rastreo..."
sed -i 's/<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"\/>/<uses-permission android:name="disabled_android.permission.ACCESS_COARSE_LOCATION"\/>/g' "$MANIFEST"
sed -i 's/<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"\/>/<uses-permission android:name="disabled_android.permission.ACCESS_FINE_LOCATION"\/>/g' "$MANIFEST"
sed -i 's/<uses-permission android:name="com.google.android.gms.permission.AD_ID"\/>/<uses-permission android:name="disabled_com.google.android.gms.permission.AD_ID"\/>/g' "$MANIFEST"
sed -i 's/<uses-permission android:name="android.permission.ACCESS_ADSERVICES_ATTRIBUTION"\/>/<uses-permission android:name="disabled_android.permission.ACCESS_ADSERVICES_ATTRIBUTION"\/>/g' "$MANIFEST"
sed -i 's/<uses-permission android:name="android.permission.ACCESS_ADSERVICES_AD_ID"\/>/<uses-permission android:name="disabled_android.permission.ACCESS_ADSERVICES_AD_ID"\/>/g' "$MANIFEST"
sed -i 's/<uses-permission android:name="com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE"\/>/<uses-permission android:name="disabled_com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE"\/>/g' "$MANIFEST"

# 2.4 Cambiar iconos
echo -e "   - Actualizando iconos de la app..."
sed -i 's/android:icon="@mipmap\/c"/android:icon="@mipmap\/ic_launcher"/g' "$MANIFEST"
sed -i 's/android:roundIcon="@mipmap\/c"/android:roundIcon="@mipmap\/ic_launcher_round"/g' "$MANIFEST"

# 2.5 Remover metadata de Google Ads
echo -e "   - Removiendo metadata de Google Ads..."
sed -i '/<meta-data android:name="com.google.android.gms.ads.APPLICATION_ID"/d' "$MANIFEST"

# 2.6 Añadir nuevos componentes (después de la etiqueta <application>)
echo -e "   - Añadiendo CrashActivity y KillAppReceiver..."
# Buscar la línea que contiene <application y añadir después de ella
sed -i '/<application.*>/a\        <activity android:exported="true" android:name="me.tigrik.CrashActivity" android:theme="@android:style/Theme.Holo.NoActionBar"/>' "$MANIFEST"

# Buscar un buen lugar para añadir el receiver (antes del cierre de application)
# Buscar la primera ocurrencia de </application> y añadir el receiver antes
LINE_NUM=$(grep -n "</application>" "$MANIFEST" | head -1 | cut -d: -f1)
if [ ! -z "$LINE_NUM" ]; then
    sed -i "${LINE_NUM}i\\        <receiver android:exported=\"true\" android:name=\"me.tigrik.KillAppReceiver\">" "$MANIFEST"
    sed -i "$((LINE_NUM+1))i\\            <intent-filter>" "$MANIFEST"
    sed -i "$((LINE_NUM+2))i\\                <action android:name=\"com.rezvorck.action.KILL_APP\"/>" "$MANIFEST"
    sed -i "$((LINE_NUM+3))i\\            </intent-filter>" "$MANIFEST"
    sed -i "$((LINE_NUM+4))i\\        </receiver>" "$MANIFEST"
fi

echo -e "${GREEN}   ✓ AndroidManifest.xml parcheado${NC}"
echo ""

# Parche 2: apktool.yml
echo -e "${YELLOW}3. Actualizando apktool.yml...${NC}"

APKTOOL="$OUTPUT_DIR/apktool.yml"

if [ -f "$APKTOOL" ]; then
    echo -e "   - Actualizando minSdkVersion a 26..."
    sed -i 's/minSdkVersion: 23/minSdkVersion: 26/g' "$APKTOOL"
    echo -e "${GREEN}   ✓ apktool.yml actualizado${NC}"
else
    echo -e "${YELLOW}   ⚠ apktool.yml no encontrado (puede ser opcional)${NC}"
fi
echo ""

# Parche 3: Copiar nuevas clases
echo -e "${YELLOW}4. Añadiendo nuevas clases...${NC}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PATCHES_DIR="$SCRIPT_DIR/tiktok_patches"

if [ -d "$PATCHES_DIR/smali_classes34" ]; then
    echo -e "   - Copiando clases me.tigrik..."
    mkdir -p "$OUTPUT_DIR/smali_classes34"
    cp -r "$PATCHES_DIR/smali_classes34/"* "$OUTPUT_DIR/smali_classes34/"
    echo -e "${GREEN}   ✓ Nuevas clases añadidas${NC}"
else
    echo -e "${YELLOW}   ⚠ Directorio de parches no encontrado: $PATCHES_DIR${NC}"
    echo -e "${YELLOW}     Las clases me.tigrik deben añadirse manualmente${NC}"
fi
echo ""

# Parche 4: Copiar bibliotecas nativas
echo -e "${YELLOW}5. Añadiendo bibliotecas nativas...${NC}"

if [ -d "$PATCHES_DIR/lib" ]; then
    echo -e "   - Copiando libtigrik.so..."
    for arch in arm64-v8a armeabi-v7a; do
        if [ -f "$PATCHES_DIR/lib/$arch/libtigrik.so" ]; then
            mkdir -p "$OUTPUT_DIR/lib/$arch"
            cp "$PATCHES_DIR/lib/$arch/libtigrik.so" "$OUTPUT_DIR/lib/$arch/"
            echo -e "     ✓ libtigrik.so copiada para $arch"
        fi
    done
    echo -e "${GREEN}   ✓ Bibliotecas nativas añadidas${NC}"
else
    echo -e "${YELLOW}   ⚠ Bibliotecas nativas no encontradas en $PATCHES_DIR${NC}"
    echo -e "${YELLOW}     Las bibliotecas .so deben añadirse manualmente${NC}"
fi
echo ""

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Parcheo completado!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "La app parcheada está en: ${GREEN}$OUTPUT_DIR${NC}"
echo ""
echo -e "${YELLOW}Próximos pasos:${NC}"
echo "1. Recompilar la app con apktool:"
echo "   apktool b $OUTPUT_DIR -o tiktok_patched.apk"
echo ""
echo "2. Firmar el APK:"
echo "   apksigner sign --ks your-keystore.jks tiktok_patched.apk"
echo ""
echo "3. Instalar en dispositivo:"
echo "   adb install tiktok_patched.apk"
echo ""
