# Workflow Visual - TikTok Analysis & Patching

## 🔄 Flujo Completo del Proyecto

```
┌─────────────────────────────────────────────────────────────┐
│                    FASE 1: PREPARACIÓN                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌──────────────────────────────────────┐
        │  Clonar Repositorios de Apps         │
        ├──────────────────────────────────────┤
        │  • com_zhiliaoapp_musically_3        │
        │    (App Modificada)                  │
        │  • com_zhiliaoapp_musically_4        │
        │    (App Original)                    │
        └──────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    FASE 2: ANÁLISIS                          │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
        ┌──────────────────┐   ┌──────────────────┐
        │ generate_diffs.sh │   │ Análisis Manual  │
        ├──────────────────┤   ├──────────────────┤
        │ • Manifest diff  │   │ • Revisar smali  │
        │ • Config diff    │   │ • Estudiar logs  │
        │ • Files lists    │   │ • Documentar     │
        │ • Sample diffs   │   │                  │
        └──────────────────┘   └──────────────────┘
                    │                   │
                    └─────────┬─────────┘
                              ▼
                    ┌──────────────────┐
                    │  ANALYSIS_       │
                    │  REPORT.md       │
                    └──────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 FASE 3: EXTRACCIÓN DE PARCHES                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                  ┌──────────────────────┐
                  │  extract_patches.sh  │
                  ├──────────────────────┤
                  │  INPUT:              │
                  │  • App Modificada    │
                  │                      │
                  │  OUTPUT:             │
                  │  • smali_classes34/  │
                  │  • lib/*.so          │
                  │  • manifest.patch    │
                  │  • README.md         │
                  └──────────────────────┘
                              │
                              ▼
                  ┌──────────────────────┐
                  │   tiktok_patches/    │
                  │   (Paquete Completo) │
                  └──────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 FASE 4: APLICACIÓN DE PARCHES                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌────────────────────────────┐
              │  patch_tiktok_42.9.3.sh    │
              ├────────────────────────────┤
              │  1. Copiar app original    │
              │  2. Modificar Manifest     │
              │  3. Actualizar apktool.yml │
              │  4. Copiar nuevas clases   │
              │  5. Copiar librerías .so   │
              └────────────────────────────┘
                              │
                              ▼
                  ┌──────────────────────┐
                  │   tiktok_patched/    │
                  │   (App Modificada)   │
                  └──────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│               FASE 5: COMPILACIÓN Y FIRMA                    │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
          ┌──────────────┐     ┌──────────────┐
          │   apktool    │     │  apksigner   │
          │   build      │────▶│   sign       │
          └──────────────┘     └──────────────┘
                                       │
                                       ▼
                              ┌──────────────────┐
                              │ tiktok_final.apk │
                              └──────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  FASE 6: INSTALACIÓN                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                      ┌──────────────┐
                      │ adb install  │
                      └──────────────┘
                              │
                              ▼
                      ┌──────────────┐
                      │   Device     │
                      │   📱         │
                      └──────────────┘
```

## 📊 Componentes del Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                     ARQUITECTURA                             │
└─────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│                    DOCUMENTACIÓN                            │
├────────────────────────────────────────────────────────────┤
│  • README_TIKTOK_ANALYSIS.md  ─── Resumen ejecutivo       │
│  • ANALYSIS_REPORT.md         ─── Análisis técnico        │
│  • PATCHING_GUIDE.md          ─── Guía de uso             │
│  • scripts/README.md          ─── Doc de scripts          │
└────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────┐
│                       SCRIPTS                               │
├────────────────────────────────────────────────────────────┤
│  • extract_patches.sh         ─── Extractor               │
│  • patch_tiktok_42.9.3.sh     ─── Aplicador               │
│  • generate_diffs.sh          ─── Analizador              │
└────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────┐
│                     DATOS/APPS                              │
├────────────────────────────────────────────────────────────┤
│  • com_zhiliaoapp_musically_3 ─── App modificada          │
│  • com_zhiliaoapp_musically_4 ─── App original            │
│  • tiktok_patches             ─── Parches extraídos       │
└────────────────────────────────────────────────────────────┘
```

## 🎯 Modificaciones Aplicadas

```
┌──────────────────────────────────────────────────────────────┐
│                  ANDROID MANIFEST                             │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  installLocation: auto ──────────▶ internalOnly              │
│  sharedUserId: (none) ───────────▶ TikTok.Mod.Cloud         │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ PERMISOS DESHABILITADOS                             │    │
│  ├─────────────────────────────────────────────────────┤    │
│  │ ✗ ACCESS_COARSE_LOCATION                            │    │
│  │ ✗ ACCESS_FINE_LOCATION                              │    │
│  │ ✗ AD_ID                                              │    │
│  │ ✗ ACCESS_ADSERVICES_ATTRIBUTION                     │    │
│  │ ✗ ACCESS_ADSERVICES_AD_ID                           │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ COMPONENTES NUEVOS                                  │    │
│  ├─────────────────────────────────────────────────────┤    │
│  │ + CrashActivity (me.tigrik)                         │    │
│  │ + KillAppReceiver (me.tigrik)                       │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ REMOVIDO                                            │    │
│  ├─────────────────────────────────────────────────────┤    │
│  │ - Google Ads Metadata                               │    │
│  └─────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                    NUEVAS CLASES                              │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  smali_classes34/                                            │
│  ├── me/tigrik/                                              │
│  │   ├── CrashActivity.smali          [Crash Handler]       │
│  │   ├── CrashActivity$Close.smali    [Inner Class]         │
│  │   ├── CrashActivity$Share.smali    [Inner Class]         │
│  │   ├── KillAppReceiver.smali        [Remote Control]      │
│  │   └── [Support Classes a-f]                              │
│  │                                                            │
│  └── tigrik0/                                                │
│      ├── tigrik.smali                  [Native Bridge]       │
│      └── [Hidden Classes]                                    │
│                                                               │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                 BIBLIOTECAS NATIVAS                           │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  lib/                                                        │
│  ├── arm64-v8a/                                             │
│  │   └── libtigrik.so                 [~1.3 MB]            │
│  │                                                           │
│  └── armeabi-v7a/                                           │
│      └── libtigrik.so                 [~1.0 MB]            │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

## 📈 Estadísticas del Análisis

```
┌─────────────────────────────────────────────────────┐
│              RESUMEN DE CAMBIOS                      │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Total archivos smali (mod):    362,228            │
│  Total archivos smali (orig):   362,153            │
│                                  ───────            │
│  Diferencia neta:                +75               │
│                                                      │
│  ┌──────────────────────────────────────┐          │
│  │  Archivos Comunes: 295,373           │          │
│  │  └─ Modificados: ~292,000 (99%)      │          │
│  └──────────────────────────────────────┘          │
│                                                      │
│  Archivos nuevos:                66,855            │
│  Archivos eliminados:            66,780            │
│                                                      │
│  ┌──────────────────────────────────────┐          │
│  │  Cambios en Manifest: 10+            │          │
│  │  Paquetes nuevos: 2                  │          │
│  │  Bibliotecas .so: 2                  │          │
│  │  Tamaño parches: 2.3 MB              │          │
│  └──────────────────────────────────────┘          │
│                                                      │
└─────────────────────────────────────────────────────┘
```

## ⚙️ Proceso Técnico

```
ANÁLISIS DE BYTECODE
═══════════════════════════════════════════════════

Original Smali:
┌─────────────────────────────────┐
│ .source "SourceFile"            │
│ const/4 v2, 0x0                 │
│ const/4 v1, 0x3                 │
└─────────────────────────────────┘

Modificado Smali:
┌─────────────────────────────────┐
│ # .source "SourceFile" <--┐     │
│ const/4 v2, 0x0           │     │
│ const/4 v2, 0x0 ◄─────────┼─ Duplicado
│ const/4 v1, 0x3           │     │
│ const/4 v1, 0x3 ◄─────────┘     │
└─────────────────────────────────┘

INTERPRETACIÓN:
• Ofuscación de código
• Protección anti-análisis
• Modificación automatizada
```

---

**Generado**: 2025-12-11  
**Versión**: TikTok 42.9.3  
**Tipo**: Análisis Automatizado
