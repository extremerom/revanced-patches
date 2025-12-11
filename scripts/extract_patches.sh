#!/bin/bash

# Script para extraer los archivos de parches de la app modificada
# Extrae solo los componentes nuevos necesarios para el parcheo

set -e

MODIFIED_APP="$1"
OUTPUT_DIR="$2"

if [ -z "$MODIFIED_APP" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Uso: $0 <directorio_app_modificada> <directorio_salida_parches>"
    echo ""
    echo "Ejemplo:"
    echo "  $0 /path/to/modified_app /path/to/patches_output"
    exit 1
fi

if [ ! -d "$MODIFIED_APP" ]; then
    echo "Error: El directorio de la app modificada no existe: $MODIFIED_APP"
    exit 1
fi

echo "========================================="
echo "Extractor de Parches TikTok v42.9.3"
echo "========================================="
echo ""

# Crear estructura de directorios
mkdir -p "$OUTPUT_DIR/smali_classes34"
mkdir -p "$OUTPUT_DIR/lib/arm64-v8a"
mkdir -p "$OUTPUT_DIR/lib/armeabi-v7a"

# Extraer clases me.tigrik
echo "1. Extrayendo clases me.tigrik..."
if [ -d "$MODIFIED_APP/smali_classes34/me" ]; then
    cp -r "$MODIFIED_APP/smali_classes34/me" "$OUTPUT_DIR/smali_classes34/"
    echo "   ✓ Clases me.tigrik extraídas"
else
    echo "   ⚠ No se encontró el paquete me.tigrik"
fi

# Extraer clases tigrik0
echo "2. Extrayendo clases tigrik0..."
if [ -d "$MODIFIED_APP/smali_classes34/tigrik0" ]; then
    cp -r "$MODIFIED_APP/smali_classes34/tigrik0" "$OUTPUT_DIR/smali_classes34/"
    echo "   ✓ Clases tigrik0 extraídas"
else
    echo "   ⚠ No se encontró el paquete tigrik0"
fi

# Extraer bibliotecas nativas
echo "3. Extrayendo bibliotecas nativas..."
for arch in arm64-v8a armeabi-v7a; do
    if [ -f "$MODIFIED_APP/lib/$arch/libtigrik.so" ]; then
        cp "$MODIFIED_APP/lib/$arch/libtigrik.so" "$OUTPUT_DIR/lib/$arch/"
        echo "   ✓ libtigrik.so extraída para $arch"
    else
        echo "   ⚠ No se encontró libtigrik.so para $arch"
    fi
done

# Crear archivo de parche para AndroidManifest
echo "4. Generando archivo de parche para AndroidManifest..."
cat > "$OUTPUT_DIR/manifest_changes.patch" << 'EOF'
--- AndroidManifest.xml.original
+++ AndroidManifest.xml.modified
@@ -1,1 +1,1 @@
-android:installLocation="auto"
+android:installLocation="internalOnly"

@@ -1,1 +1,1 @@
-package="com.zhiliaoapp.musically"
+android:sharedUserId="TikTok.Mod.Cloud" package="com.zhiliaoapp.musically"

@@ -1,1 +1,1 @@
-<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
+<uses-permission android:name="disabled_android.permission.ACCESS_COARSE_LOCATION"/>

@@ -1,1 +1,1 @@
-<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
+<uses-permission android:name="disabled_android.permission.ACCESS_FINE_LOCATION"/>

@@ -1,1 +1,1 @@
-<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
+<uses-permission android:name="disabled_com.google.android.gms.permission.AD_ID"/>

@@ -1,1 +1,1 @@
-<uses-permission android:name="android.permission.ACCESS_ADSERVICES_ATTRIBUTION"/>
+<uses-permission android:name="disabled_android.permission.ACCESS_ADSERVICES_ATTRIBUTION"/>

@@ -1,1 +1,1 @@
-<uses-permission android:name="android.permission.ACCESS_ADSERVICES_AD_ID"/>
+<uses-permission android:name="disabled_android.permission.ACCESS_ADSERVICES_AD_ID"/>

@@ -1,1 +1,1 @@
-android:icon="@mipmap/c"
+android:icon="@mipmap/ic_launcher"

@@ -1,1 +1,1 @@
-android:roundIcon="@mipmap/c"
+android:roundIcon="@mipmap/ic_launcher_round"

# Remover esta línea:
-        <meta-data android:name="com.google.android.gms.ads.APPLICATION_ID" android:value="ca-app-pub-6536861780333891~4547192519"/>

# Añadir después de <application>:
+        <activity android:exported="true" android:name="me.tigrik.CrashActivity" android:theme="@android:style/Theme.Holo.NoActionBar"/>

# Añadir antes de </application>:
+        <receiver android:exported="true" android:name="me.tigrik.KillAppReceiver">
+            <intent-filter>
+                <action android:name="com.rezvorck.action.KILL_APP"/>
+            </intent-filter>
+        </receiver>
EOF

echo "   ✓ Parche de manifest generado"

# Crear README
echo "5. Generando README..."
cat > "$OUTPUT_DIR/README.md" << 'EOF'
# Parches TikTok v42.9.3

Este directorio contiene los archivos necesarios para parchear TikTok v42.9.3 original.

## Contenido

- `smali_classes34/` - Nuevas clases Java/Smali
  - `me/tigrik/` - Sistema de crash handling y control
  - `tigrik0/` - Integración con biblioteca nativa
  
- `lib/` - Bibliotecas nativas
  - `arm64-v8a/libtigrik.so`
  - `armeabi-v7a/libtigrik.so`
  
- `manifest_changes.patch` - Cambios para AndroidManifest.xml

## Uso

### Método 1: Script Automático

```bash
../patch_tiktok_42.9.3.sh /path/to/original_app /path/to/output
```

### Método 2: Manual

1. Copiar `smali_classes34/` al directorio de la app
2. Copiar `lib/` al directorio de la app
3. Aplicar cambios de `manifest_changes.patch` a AndroidManifest.xml
4. Actualizar apktool.yml: `minSdkVersion: 26`

## Notas

- Los permisos de ubicación y ads son deshabilitados para privacidad
- Se añade sistema de crash reporting personalizado
- Se integra biblioteca nativa para funcionalidad extendida
EOF

echo "   ✓ README generado"
echo ""

echo "========================================="
echo "Extracción completada!"
echo "========================================="
echo ""
echo "Archivos extraídos en: $OUTPUT_DIR"
echo ""
echo "Estructura creada:"
echo "  - smali_classes34/"
echo "  - lib/"
echo "  - manifest_changes.patch"
echo "  - README.md"
echo ""
