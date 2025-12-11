# TikTok v42.9.3 Patches

Este directorio contiene los archivos .patch que documentan las diferencias entre la app original y modificada.

## Archivos de Parche

### 001-android-manifest.patch
Cambios en AndroidManifest.xml:
- Permisos de ubicación y ads deshabilitados
- Shared user ID añadido: `TikTok.Mod.Cloud`
- Nuevos componentes: CrashActivity, KillAppReceiver
- Metadata de Google Ads removida

### 002-apktool-config.patch
Cambios en apktool.yml:
- minSdkVersion actualizado de 23 a 26

### 003-new-classes-list.txt
Lista de todas las clases nuevas añadidas:
- Paquete `me.tigrik` (crash handling)
- Paquete `tigrik0` (native integration)

### 004-native-libraries-list.txt
Lista de bibliotecas nativas añadidas:
- libtigrik.so (ARM64-v8a)
- libtigrik.so (ARMv7)

### 005-smali-modifications.patch ⭐ NUEVO
Parche unificado de TODOS los archivos smali modificados:
- Contiene cambios en archivos smali existentes
- NO incluye archivos nuevos (ver 003-new-classes-list.txt)
- Generado con `scripts/generate_smali_patch.sh`
- Incluye archivos con cambios sistemáticos (instrucciones duplicadas)

**Tamaño:** Variable (depende de cuántos archivos se generaron)
**Archivos incluidos:** ~290,000 archivos smali modificados

**Archivos complementarios:**
- `smali-patch-stats.txt` - Estadísticas detalladas del parche
- `smali-modified-files.txt` - Lista completa de archivos modificados

## Uso

### Aplicar manualmente con patch:
```bash
# Aplicar parche de manifest
cd /path/to/original_app
patch -p0 < /path/to/001-android-manifest.patch

# Aplicar parche de apktool
patch -p0 < /path/to/002-apktool-config.patch

# Aplicar parche de smali (NUEVO)
patch -p1 < /path/to/005-smali-modifications.patch
```

### Usar scripts automatizados:
Los scripts en `../scripts/` automatizan todo el proceso:
```bash
# Método recomendado
bash ../scripts/patch_tiktok_42.9.3.sh /path/to/original_app /path/to/output
```

### Generar el parche de smali:
Si necesitas regenerar el parche de smali:
```bash
bash ../scripts/generate_smali_patch.sh \
  /path/to/modified_app \
  /path/to/original_app \
  patches/tiktok-v42.9.3
```

## Notas

- Los archivos .patch son diffs unificados estándar
- Las nuevas clases y bibliotecas deben copiarse manualmente o usar el script automatizado
- Para obtener los archivos completos, usa `extract_patches.sh`
- Estos parches son específicos para TikTok v42.9.3 (versionCode: 2024209030)
- El parche 005 es muy grande y puede tardar varios minutos en aplicarse

## Ver También

- [ANALYSIS_REPORT.md](../ANALYSIS_REPORT.md) - Análisis técnico completo
- [PATCHING_GUIDE.md](../PATCHING_GUIDE.md) - Guía de uso
- [scripts/README.md](../scripts/README.md) - Documentación de scripts
