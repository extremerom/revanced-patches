# Scripts de Análisis y Parcheo TikTok v42.9.3

Esta carpeta contiene scripts automatizados para analizar diferencias entre versiones de TikTok y aplicar parches.

## 📜 Scripts Disponibles

### 1. `extract_patches.sh`
Extrae los componentes necesarios de la app modificada para crear un paquete de parches.

**Uso:**
```bash
./extract_patches.sh <directorio_app_modificada> <directorio_salida>
```

**Ejemplo:**
```bash
./extract_patches.sh ../com_zhiliaoapp_musically_3 ../tiktok_patches
```

**Salida:**
- `smali_classes34/` - Nuevas clases Java/Smali
- `lib/` - Bibliotecas nativas (libtigrik.so)
- `manifest_changes.patch` - Parche para AndroidManifest
- `README.md` - Documentación del paquete

---

### 2. `patch_tiktok_42.9.3.sh`
Aplica automáticamente todos los parches a una app original de TikTok.

**Uso:**
```bash
./patch_tiktok_42.9.3.sh <directorio_app_original> <directorio_salida>
```

**Ejemplo:**
```bash
./patch_tiktok_42.9.3.sh ../com_zhiliaoapp_musically_4 ../tiktok_patched
```

**Modificaciones aplicadas:**
1. ✅ AndroidManifest.xml
   - Cambiar `installLocation` a `internalOnly`
   - Añadir `sharedUserId`
   - Deshabilitar permisos de rastreo
   - Actualizar iconos
   - Remover metadata de Google Ads
   - Añadir CrashActivity y KillAppReceiver

2. ✅ apktool.yml
   - Actualizar `minSdkVersion` a 26

3. ✅ Nuevas Clases
   - Copiar `me.tigrik` package
   - Copiar `tigrik0` package

4. ✅ Bibliotecas Nativas
   - Copiar `libtigrik.so` (arm64-v8a, armeabi-v7a)

---

### 3. `generate_diffs.sh`
Genera archivos diff para análisis detallado de cambios específicos.

**Uso:**
```bash
./generate_diffs.sh <app_modificada> <app_original> [directorio_salida]
```

**Ejemplo:**
```bash
./generate_diffs.sh ../com_zhiliaoapp_musically_3 ../com_zhiliaoapp_musically_4
```

**Salida:**
- `AndroidManifest.diff` - Cambios en manifest
- `apktool.diff` - Cambios en configuración
- `new_files.txt` - Lista de archivos nuevos
- `deleted_files.txt` - Lista de archivos eliminados
- `samples/` - Diffs de muestra
- `SUMMARY.txt` - Resumen de cambios

---

## 🔄 Flujo de Trabajo Completo

### Análisis y Extracción
```bash
# 1. Generar diffs para análisis
./generate_diffs.sh ../com_zhiliaoapp_musically_3 ../com_zhiliaoapp_musically_4

# 2. Extraer parches
./extract_patches.sh ../com_zhiliaoapp_musically_3 ../tiktok_patches
```

### Aplicación de Parches
```bash
# 3. Aplicar parches a app original
./patch_tiktok_42.9.3.sh ../com_zhiliaoapp_musically_4 ../tiktok_patched

# 4. Recompilar
apktool b ../tiktok_patched -o tiktok_modified.apk

# 5. Firmar
apksigner sign --ks keystore.jks tiktok_modified.apk

# 6. Instalar
adb install tiktok_modified.apk
```

---

## 📋 Requisitos

### Herramientas Necesarias
- `bash` (4.0+)
- `diff` y `cmp` (GNU coreutils)
- `sed` (GNU sed)
- `find` (GNU findutils)
- `apktool` (2.9.0+) - para recompilar
- `apksigner` o `jarsigner` - para firmar APKs
- `adb` (opcional) - para instalar en dispositivos

### Verificar Instalación
```bash
# Verificar herramientas
which bash diff sed find apktool apksigner adb

# Versiones
bash --version
apktool --version
```

---

## 🎯 Casos de Uso

### Caso 1: Solo Análisis
Si solo quieres analizar las diferencias sin aplicar parches:

```bash
./generate_diffs.sh ../com_zhiliaoapp_musically_3 ../com_zhiliaoapp_musically_4 /tmp/analysis
# Revisar archivos en /tmp/analysis/
```

### Caso 2: Crear Paquete de Distribución
Para crear un paquete de parches que otros puedan usar:

```bash
./extract_patches.sh ../com_zhiliaoapp_musically_3 tiktok_patches_v1.0
tar czf tiktok_patches_v1.0.tar.gz tiktok_patches_v1.0/
# Distribuir tiktok_patches_v1.0.tar.gz
```

### Caso 3: Parcheo Rápido
Para aplicar rápidamente los parches:

```bash
# Asumiendo que ya tienes tiktok_patches/ extraídos
./patch_tiktok_42.9.3.sh ../com_zhiliaoapp_musically_4 ../patched
apktool b ../patched -o tiktok.apk
apksigner sign --ks my.jks tiktok.apk
```

---

## ⚙️ Opciones Avanzadas

### Modificar Scripts

Los scripts están diseñados para ser modificables. Puedes:

1. **Añadir más parches** editando `patch_tiktok_42.9.3.sh`
2. **Cambiar rutas** modificando las variables de configuración
3. **Personalizar salida** ajustando los mensajes y colores

### Variables de Entorno

```bash
# Ejemplo: cambiar directorio de parches
PATCHES_DIR=/custom/path ./patch_tiktok_42.9.3.sh ...
```

---

## 🐛 Solución de Problemas

### Error: "Permission denied"
```bash
chmod +x *.sh
```

### Error: "apktool not found"
```bash
# Instalar apktool
# Linux
sudo apt install apktool

# macOS
brew install apktool

# Manual
# Descargar de https://apktool.org
```

### Error: "sed command failed"
Asegúrate de usar GNU sed (no BSD sed):
```bash
# macOS: instalar GNU sed
brew install gnu-sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
```

### App no instala después de parchear
1. Verifica que el APK esté firmado correctamente
2. Desinstala la versión anterior primero
3. Comprueba que minSdkVersion sea compatible con tu dispositivo

---

## 📝 Notas Importantes

⚠️ **Advertencias:**
- Los scripts modifican archivos del sistema Android
- Solo para fines educativos y de investigación
- No garantía de funcionamiento con futuras versiones
- Usar bajo tu propia responsabilidad

✅ **Recomendaciones:**
- Haz backup de los APKs originales
- Prueba primero en un dispositivo de desarrollo
- Revisa los cambios antes de aplicarlos
- Documenta cualquier modificación adicional

---

## 📚 Documentación Relacionada

- [ANALYSIS_REPORT.md](../ANALYSIS_REPORT.md) - Análisis detallado de cambios
- [PATCHING_GUIDE.md](../PATCHING_GUIDE.md) - Guía completa de parcheo
- [tiktok_patches/README.md](../tiktok_patches/README.md) - Documentación de parches

---

## 🤝 Contribuciones

Para mejorar estos scripts:
1. Reporta bugs o problemas
2. Sugiere nuevas características
3. Documenta casos de uso adicionales
4. Comparte optimizaciones

---

**Última actualización**: 2025-12-11
**Versión compatible**: TikTok 42.9.3 (versionCode: 2024209030)
