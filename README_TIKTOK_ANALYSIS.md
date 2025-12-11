# Proyecto de Análisis TikTok v42.9.3 - Resumen Ejecutivo

## 📊 Vista General del Proyecto

Este repositorio contiene un análisis completo y herramientas automatizadas para comparar y parchear dos versiones de TikTok v42.9.3:

- **App Modificada** (com_zhiliaoapp_musically_3): Versión con mejoras de privacidad y funcionalidad adicional
- **App Original** (com_zhiliaoapp_musically_4): Versión stock sin modificaciones

## 🎯 Objetivo

Proporcionar herramientas y documentación para:
1. Analizar diferencias entre las dos versiones
2. Extraer componentes modificados
3. Aplicar automáticamente las modificaciones a la app original
4. Generar documentación técnica detallada

## 📁 Estructura del Proyecto

```
revanced-patches/
├── ANALYSIS_REPORT.md           # Análisis técnico detallado
├── PATCHING_GUIDE.md            # Guía completa de uso
├── README_TIKTOK_ANALYSIS.md    # Este archivo
│
├── scripts/                     # Scripts de automatización
│   ├── README.md               # Documentación de scripts
│   ├── extract_patches.sh      # Extractor de parches
│   ├── patch_tiktok_42.9.3.sh  # Aplicador de parches
│   └── generate_diffs.sh       # Generador de diferencias
│
├── com_zhiliaoapp_musically_3/  # App modificada (clonada, ignorada en git)
├── com_zhiliaoapp_musically_4/  # App original (clonada, ignorada en git)
└── tiktok_patches/              # Parches extraídos (generados, ignorados en git)
```

## 🔍 Hallazgos Principales

### Estadísticas
- **Total de archivos smali modificados**: ~99% (292,000+ archivos)
- **Archivos nuevos**: 66,855
- **Archivos eliminados**: 66,780
- **Tamaño de parches**: ~2.3 MB

### Modificaciones Clave

#### 1. Mejoras de Privacidad 🔒
```
✅ Permisos de ubicación deshabilitados
✅ Rastreo de publicidad bloqueado
✅ ID de anuncios removido
✅ Metadata de Google Ads eliminada
```

#### 2. Componentes Nuevos 🆕
```
📦 Paquete me.tigrik - Sistema de manejo de crashes
📦 Paquete tigrik0 - Integración nativa
🔧 libtigrik.so - Biblioteca nativa (ARM64 + ARMv7)
```

#### 3. Configuración del Sistema ⚙️
```
📝 sharedUserId: TikTok.Mod.Cloud
📝 installLocation: internalOnly
📝 minSdkVersion: 26 (incrementado desde 23)
📝 Iconos actualizados
```

## 🚀 Inicio Rápido

### Paso 1: Clonar Apps
```bash
git clone https://github.com/extremerom/com_zhiliaoapp_musically_3.git
git clone https://github.com/extremerom/com_zhiliaoapp_musically_4.git
```

### Paso 2: Extraer Parches
```bash
cd revanced-patches
bash scripts/extract_patches.sh com_zhiliaoapp_musically_3 tiktok_patches
```

### Paso 3: Aplicar Parches
```bash
bash scripts/patch_tiktok_42.9.3.sh com_zhiliaoapp_musically_4 tiktok_patched
```

### Paso 4: Recompilar y Firmar
```bash
apktool b tiktok_patched -o tiktok_modified.apk
apksigner sign --ks keystore.jks tiktok_modified.apk
adb install tiktok_modified.apk
```

## 📚 Documentación Disponible

### Para Usuarios
- **[PATCHING_GUIDE.md](PATCHING_GUIDE.md)** - Guía paso a paso para aplicar parches
- **[scripts/README.md](scripts/README.md)** - Documentación de scripts y casos de uso

### Para Desarrolladores
- **[ANALYSIS_REPORT.md](ANALYSIS_REPORT.md)** - Análisis técnico completo
- Comentarios en scripts - Explicación línea por línea del código

## 🛠️ Herramientas Incluidas

### 1. Extract Patches (`extract_patches.sh`)
Extrae componentes modificados de la app modificada.

**Uso:**
```bash
bash scripts/extract_patches.sh <app_modificada> <salida>
```

**Genera:**
- Nuevas clases smali
- Bibliotecas nativas
- Archivo de parche de manifest
- Documentación

### 2. Patch TikTok (`patch_tiktok_42.9.3.sh`)
Aplica automáticamente todos los parches a una app original.

**Uso:**
```bash
bash scripts/patch_tiktok_42.9.3.sh <app_original> <salida>
```

**Aplica:**
- Cambios en AndroidManifest.xml
- Actualización de apktool.yml
- Copia de nuevas clases
- Integración de bibliotecas nativas

### 3. Generate Diffs (`generate_diffs.sh`)
Genera archivos diff para análisis detallado.

**Uso:**
```bash
bash scripts/generate_diffs.sh <app_mod> <app_orig> [salida]
```

**Genera:**
- Diffs de manifest y configuración
- Listas de archivos nuevos/eliminados
- Muestras de cambios en componentes clave

## 🎓 Casos de Uso

### Caso de Uso 1: Investigación
Analizar qué cambios se hicieron y por qué:
```bash
bash scripts/generate_diffs.sh com_zhiliaoapp_musically_3 com_zhiliaoapp_musically_4
# Revisar archivos en /tmp/tiktok_diffs/
```

### Caso de Uso 2: Aplicación Rápida
Aplicar las modificaciones a una app original:
```bash
bash scripts/extract_patches.sh com_zhiliaoapp_musically_3 patches
bash scripts/patch_tiktok_42.9.3.sh com_zhiliaoapp_musically_4 patched
```

### Caso de Uso 3: Distribución
Crear un paquete de parches para compartir:
```bash
bash scripts/extract_patches.sh com_zhiliaoapp_musically_3 tiktok_patches_v1
tar czf tiktok_patches_v1.tar.gz tiktok_patches_v1/
```

## 📖 Detalles Técnicos

### Cambios en AndroidManifest.xml

| Aspecto | Original | Modificado |
|---------|----------|------------|
| installLocation | `auto` | `internalOnly` |
| sharedUserId | - | `TikTok.Mod.Cloud` |
| Ubicación | Habilitado | Deshabilitado |
| Ad tracking | Habilitado | Deshabilitado |
| Google Ads | Integrado | Removido |
| Iconos | `@mipmap/c` | `@mipmap/ic_launcher` |

### Nuevos Componentes

#### CrashActivity
- **Paquete**: `me.tigrik.CrashActivity`
- **Propósito**: Manejo personalizado de crashes
- **Exported**: `true`

#### KillAppReceiver
- **Paquete**: `me.tigrik.KillAppReceiver`
- **Propósito**: Control remoto de la aplicación
- **Action**: `com.rezvorck.action.KILL_APP`

#### Biblioteca Nativa
- **Nombre**: `libtigrik.so`
- **Arquitecturas**: ARM64-v8a, ARMv7
- **Tamaño**: ~1.3 MB (arm64), ~1.0 MB (arm)

### Modificaciones en Bytecode

Patrón detectado en archivos smali:
```smali
# Original
.source "SourceFile"
const/4 v2, 0x0

# Modificado (duplicación de instrucciones)
const/4 v2, 0x0
const/4 v2, 0x0
```

**Interpretación:**
- Ofuscación adicional del código
- Posible protección anti-análisis estático
- Modificación sistemática automatizada

## ⚠️ Consideraciones Importantes

### Legales
- 📜 Solo para fines educativos y de investigación
- 📜 Puede violar los Términos de Servicio de TikTok
- 📜 No hay garantías de funcionamiento
- 📜 Usar bajo tu propia responsabilidad

### Técnicas
- 🔧 Compatible solo con TikTok v42.9.3
- 🔧 Requiere Android 8.0+ (minSdk 26)
- 🔧 Necesita dispositivo rooteado para algunas funciones
- 🔧 Los parches pueden no funcionar en versiones futuras

### Seguridad
- 🔒 Verifica la integridad de las apps antes de instalar
- 🔒 Usa solo en entornos de desarrollo/prueba
- 🔒 No instales en dispositivos de producción
- 🔒 Haz backup antes de aplicar modificaciones

## 🔄 Flujo de Trabajo Recomendado

```
1. Análisis Inicial
   ↓
   bash scripts/generate_diffs.sh ...
   
2. Extracción de Parches
   ↓
   bash scripts/extract_patches.sh ...
   
3. Revisión Manual
   ↓
   Revisar tiktok_patches/ y documentación
   
4. Aplicación de Parches
   ↓
   bash scripts/patch_tiktok_42.9.3.sh ...
   
5. Compilación
   ↓
   apktool b ... -o output.apk
   
6. Firma
   ↓
   apksigner sign ...
   
7. Pruebas
   ↓
   adb install ... && probar funcionalidad
```

## 📊 Métricas del Análisis

| Métrica | Valor |
|---------|-------|
| Tiempo de análisis | ~5 minutos |
| Archivos analizados | 362,000+ |
| Diferencias encontradas | 292,000+ |
| Nuevos componentes | 3 (packages) |
| Bibliotecas nativas | 2 (.so files) |
| Tamaño parches | 2.3 MB |
| Cambios en manifest | 10+ modificaciones |

## 🤝 Contribuciones

Este análisis fue generado automáticamente. Para contribuir:

1. **Reportar Issues**: Si encuentras problemas con los scripts
2. **Mejorar Documentación**: Añadir ejemplos o casos de uso
3. **Optimizar Scripts**: Proponer mejoras de rendimiento
4. **Actualizar para Nuevas Versiones**: Adaptar para TikTok v43+

## 📞 Soporte

- **Documentación**: Lee los archivos .md en el repositorio
- **Scripts**: Revisa scripts/README.md para detalles
- **Análisis**: Consulta ANALYSIS_REPORT.md para información técnica

## 🏁 Conclusión

Este proyecto proporciona una solución completa para:

✅ Entender las diferencias entre versiones de TikTok
✅ Aplicar modificaciones de forma automatizada
✅ Generar documentación técnica detallada
✅ Crear parches reutilizables y distribuibles

**Versión del Análisis**: 1.0
**Fecha**: 2025-12-11
**Compatible con**: TikTok v42.9.3 (versionCode: 2024209030)

---

**Nota Final**: Este análisis se realizó con fines educativos para entender cómo funcionan las modificaciones de apps Android. Usa esta información de manera responsable y ética.
