# TikTok v42.9.3 - Análisis de Diferencias y Sistema de Parcheo

Este proyecto contiene el análisis completo de las diferencias entre dos versiones de TikTok v42.9.3 (modificada vs original) y proporciona scripts automatizados para aplicar las modificaciones.

## 📋 Contenido del Repositorio

```
.
├── ANALYSIS_REPORT.md          # Reporte detallado del análisis
├── PATCHING_GUIDE.md           # Esta guía
├── scripts/
│   ├── extract_patches.sh      # Extrae parches de la app modificada
│   └── patch_tiktok_42.9.3.sh  # Aplica parches a la app original
├── com_zhiliaoapp_musically_3/ # App modificada (ignorada en git)
├── com_zhiliaoapp_musically_4/ # App original (ignorada en git)
└── .gitignore                  # Configuración de archivos ignorados
```

## 🔍 Resumen de Diferencias

### Cambios en AndroidManifest.xml
- ✅ Permisos de ubicación y ads **deshabilitados**
- ✅ Shared User ID añadido: `TikTok.Mod.Cloud`
- ✅ Instalación forzada a almacenamiento interno
- ✅ Metadata de Google Ads removida
- ✅ Nuevos componentes agregados (CrashActivity, KillAppReceiver)

### Nuevos Componentes
- 📦 **Paquete me.tigrik**: Sistema de manejo de crashes
- 📦 **Paquete tigrik0**: Integración con biblioteca nativa
- 🔧 **libtigrik.so**: Biblioteca nativa para ARM64 y ARMv7

### Estadísticas
- 📊 **362,228** archivos smali en app modificada
- 📊 **362,153** archivos smali en app original
- 📊 **~99%** de archivos tienen modificaciones
- 📊 **+75** archivos netos añadidos

## 🚀 Inicio Rápido

### Prerrequisitos

```bash
# Herramientas necesarias
- apktool (v2.9.0 o superior)
- bash
- git
```

### 1. Clonar Repositorios de Apps

```bash
# Clonar app modificada
git clone https://github.com/extremerom/com_zhiliaoapp_musically_3.git

# Clonar app original
git clone https://github.com/extremerom/com_zhiliaoapp_musically_4.git
```

### 2. Extraer Parches

```bash
# Ejecutar extractor de parches
./scripts/extract_patches.sh com_zhiliaoapp_musically_3 tiktok_patches

# Esto creará el directorio tiktok_patches/ con:
# - Nuevas clases smali
# - Bibliotecas nativas
# - Archivo de parche del manifest
```

### 3. Aplicar Parches

```bash
# Aplicar parches a la app original
./scripts/patch_tiktok_42.9.3.sh com_zhiliaoapp_musically_4 tiktok_patched

# Esto creará tiktok_patched/ con todos los cambios aplicados
```

### 4. Recompilar y Firmar

```bash
# Recompilar con apktool
apktool b tiktok_patched -o tiktok_modified.apk

# Firmar el APK (necesitas un keystore)
apksigner sign --ks my-keystore.jks tiktok_modified.apk

# O usar jarsigner
jarsigner -keystore my-keystore.jks tiktok_modified.apk alias_name
zipalign -v 4 tiktok_modified.apk tiktok_final.apk
```

### 5. Instalar

```bash
# Instalar en dispositivo vía ADB
adb install tiktok_final.apk
```

## 📖 Guías Detalladas

### Análisis Completo
Ver [ANALYSIS_REPORT.md](ANALYSIS_REPORT.md) para:
- Análisis detallado de todos los cambios
- Propósito de cada modificación
- Componentes técnicos nuevos
- Patrones de modificación en bytecode

### Parcheo Manual

Si prefieres aplicar los parches manualmente:

#### 1. AndroidManifest.xml

```xml
<!-- Cambiar installLocation -->
<manifest android:installLocation="internalOnly" 
          android:sharedUserId="TikTok.Mod.Cloud"
          ...>

<!-- Deshabilitar permisos -->
<uses-permission android:name="disabled_android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="disabled_android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="disabled_com.google.android.gms.permission.AD_ID"/>

<!-- Añadir componentes -->
<application ...>
    <activity android:exported="true" 
              android:name="me.tigrik.CrashActivity" 
              android:theme="@android:style/Theme.Holo.NoActionBar"/>
    
    <receiver android:exported="true" 
              android:name="me.tigrik.KillAppReceiver">
        <intent-filter>
            <action android:name="com.rezvorck.action.KILL_APP"/>
        </intent-filter>
    </receiver>
    ...
</application>
```

#### 2. Copiar Archivos

```bash
# Copiar nuevas clases
cp -r tiktok_patches/smali_classes34/* tiktok_original/smali_classes34/

# Copiar bibliotecas nativas
cp -r tiktok_patches/lib/* tiktok_original/lib/
```

#### 3. Actualizar apktool.yml

```yaml
sdkInfo:
  minSdkVersion: 26  # Cambiar de 23 a 26
  targetSdkVersion: 35
```

## 🛠️ Scripts Disponibles

### extract_patches.sh
Extrae los componentes necesarios de la app modificada.

```bash
Uso: ./extract_patches.sh <app_modificada> <salida>

Ejemplo:
  ./extract_patches.sh com_zhiliaoapp_musically_3 tiktok_patches
```

### patch_tiktok_42.9.3.sh
Aplica automáticamente todos los parches a la app original.

```bash
Uso: ./patch_tiktok_42.9.3.sh <app_original> <salida>

Ejemplo:
  ./patch_tiktok_42.9.3.sh com_zhiliaoapp_musically_4 tiktok_patched
```

## 🔒 Características de Privacidad

Las modificaciones incluyen mejoras de privacidad:

✅ **Permisos Deshabilitados**
- Ubicación (ACCESS_COARSE_LOCATION, ACCESS_FINE_LOCATION)
- ID de publicidad (AD_ID, ACCESS_ADSERVICES_AD_ID)
- Atribución de anuncios (ACCESS_ADSERVICES_ATTRIBUTION)

✅ **Rastreo Removido**
- Metadata de Google Ads eliminada
- Servicios de instalación de Play Store deshabilitados

## ⚠️ Advertencias

- 🚫 **Solo para fines educativos y de investigación**
- 🚫 Las modificaciones pueden violar los ToS de TikTok
- 🚫 Usar bajo tu propia responsabilidad
- 🚫 No garantía de funcionamiento en futuras versiones

## 📝 Notas Técnicas

### Modificaciones en Bytecode

La app modificada tiene un patrón sistemático de duplicación de instrucciones:

```smali
# Original
const/4 v2, 0x0

# Modificado
const/4 v2, 0x0
const/4 v2, 0x0  # Duplicado
```

Este patrón sugiere:
- Ofuscación adicional
- Posible protección anti-análisis
- Modificación automatizada del bytecode

### Biblioteca Nativa

La biblioteca `libtigrik.so` proporciona:
- Registro de métodos nativos
- Funcionalidad de hooking
- Sistema de crash reporting personalizado

## 🤝 Contribuciones

Este análisis es automático. Para contribuir:

1. Reporta problemas encontrados
2. Sugiere mejoras a los scripts
3. Documenta hallazgos adicionales

## 📄 Licencia

Este proyecto es solo para análisis y fines educativos.

## 🔗 Enlaces

- **App Modificada**: https://github.com/extremerom/com_zhiliaoapp_musically_3
- **App Original**: https://github.com/extremerom/com_zhiliaoapp_musically_4
- **Versión**: 42.9.3 (versionCode: 2024209030)

---

**Fecha de análisis**: 2025-12-11
**Herramientas**: apktool v3.0.0-dirty
**Target SDK**: 35
