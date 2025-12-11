# Análisis de Diferencias entre TikTok v42.9.3 Modificada y Original

## Resumen Ejecutivo

Este documento detalla las diferencias encontradas entre dos versiones de TikTok v42.9.3:
- **App Modificada**: com_zhiliaoapp_musically_3 (https://github.com/extremerom/com_zhiliaoapp_musically_3)
- **App Original**: com_zhiliaoapp_musically_4 (https://github.com/extremerom/com_zhiliaoapp_musically_4)

## Estadísticas Generales

- **Archivos smali en app modificada**: 362,228
- **Archivos smali en app original**: 362,153
- **Diferencia neta**: +75 archivos
- **Tasa de modificación**: ~99% de archivos comunes tienen cambios

## Cambios Principales

### 1. AndroidManifest.xml

#### 1.1 Configuración de Instalación
```xml
<!-- ORIGINAL -->
android:installLocation="auto"

<!-- MODIFICADO -->
android:installLocation="internalOnly"
android:sharedUserId="TikTok.Mod.Cloud"
```

#### 1.2 Permisos Deshabilitados
Los siguientes permisos fueron deshabilitados (prefijados con "disabled_"):
- `android.permission.ACCESS_COARSE_LOCATION`
- `android.permission.ACCESS_FINE_LOCATION`
- `com.google.android.gms.permission.AD_ID`
- `android.permission.ACCESS_ADSERVICES_ATTRIBUTION`
- `android.permission.ACCESS_ADSERVICES_AD_ID`
- `com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE`

**Propósito**: Bloquear rastreo de ubicación y publicidad

#### 1.3 Iconos de la App
```xml
<!-- ORIGINAL -->
android:icon="@mipmap/c"
android:roundIcon="@mipmap/c"

<!-- MODIFICADO -->
android:icon="@mipmap/ic_launcher"
android:roundIcon="@mipmap/ic_launcher_round"
```

#### 1.4 Componentes Nuevos
```xml
<!-- CrashActivity para manejo de errores -->
<activity 
    android:exported="true" 
    android:name="me.tigrik.CrashActivity" 
    android:theme="@android:style/Theme.Holo.NoActionBar"/>

<!-- Receiver para control de la app -->
<receiver 
    android:exported="true" 
    android:name="me.tigrik.KillAppReceiver">
    <intent-filter>
        <action android:name="com.rezvorck.action.KILL_APP"/>
    </intent-filter>
</receiver>
```

#### 1.5 Metadata de Google Ads Eliminada
```xml
<!-- REMOVIDO -->
<meta-data 
    android:name="com.google.android.gms.ads.APPLICATION_ID" 
    android:value="ca-app-pub-6536861780333891~4547192519"/>
```

### 2. Nuevas Clases Java/Smali

#### 2.1 Paquete `me.tigrik`
Ubicación: `smali_classes34/me/tigrik/`

Clases añadidas:
- `CrashActivity.smali` - Activity principal para manejo de crashes
- `CrashActivity$Close.smali` - Inner class para cerrar
- `CrashActivity$Share.smali` - Inner class para compartir
- `KillAppReceiver.smali` - BroadcastReceiver para control remoto

#### 2.2 Paquete `tigrik0`
Ubicación: `smali_classes34/tigrik0/`

Clases añadidas:
- `tigrik.smali` - Clase principal de integración con biblioteca nativa
- Clases de soporte adicionales (a-f)

### 3. Bibliotecas Nativas

#### 3.1 Nueva Biblioteca
- **Nombre**: `libtigrik.so`
- **Ubicaciones**:
  - `lib/arm64-v8a/libtigrik.so`
  - `lib/armeabi-v7a/libtigrik.so`

**Propósito**: Biblioteca nativa que proporciona funcionalidad de hooking/modificación

### 4. Modificaciones en Smali

#### 4.1 Patrón de Modificación
Los archivos smali han sido modificados con un patrón sistemático que duplica ciertas instrucciones:

```smali
# ORIGINAL
.source "SourceFile"
const/4 v2, 0x0

# MODIFICADO
# .source "SourceFile" <- Comentado
const/4 v2, 0x0
const/4 v2, 0x0  <- Duplicado
```

**Impacto**: Este patrón sugiere:
1. Ofuscación adicional del código
2. Posible protección anti-análisis
3. Modificación sistemática de bytecode

#### 4.2 Eliminación de Metadata
- La directiva `.source "SourceFile"` fue eliminada o comentada en muchos archivos
- Esto dificulta el debugging y análisis del código

### 5. Cambios en apktool.yml

```diff
< minSdkVersion: 23
---
> minSdkVersion: 26
```

El SDK mínimo fue incrementado de 23 a 26.

## Propósito de las Modificaciones

Basado en el análisis, la app modificada tiene los siguientes objetivos:

### 1. **Privacidad Mejorada**
- Deshabilita permisos de ubicación
- Deshabilita rastreo de publicidad
- Remueve integración con Google Ads

### 2. **Control de Aplicación**
- Añade sistema de crash reporting personalizado
- Añade capacidad de control remoto (KillAppReceiver)
- Integra biblioteca nativa para funcionalidad extendida

### 3. **Ofuscación y Protección**
- Modifica sistemáticamente el bytecode
- Elimina metadata de fuente
- Añade instrucciones redundantes

### 4. **Branding Personalizado**
- Cambia iconos de la aplicación
- Añade shared user ID personalizado

## Archivos de Interés

### Componentes Nuevos
- `/smali_classes34/me/tigrik/*.smali` - Nuevas activities y receivers
- `/smali_classes34/tigrik0/*.smali` - Integración con biblioteca nativa
- `/lib/*/libtigrik.so` - Biblioteca nativa

### Componentes Modificados (Ejemplos)
- `AndroidManifest.xml` - Configuración principal
- `apktool.yml` - Configuración de compilación
- Todos los archivos smali en paquetes feed/aweme (prácticamente todos)

## Recomendaciones para Parches

Para crear parches ReVanced que repliquen estas modificaciones:

### 1. Patch de Privacidad
- Deshabilitar permisos de ubicación y ads
- Remover metadata de Google Ads

### 2. Patch de Control
- Añadir CrashActivity y KillAppReceiver
- Integrar biblioteca nativa libtigrik.so

### 3. Patch de Bytecode
- Aplicar modificaciones sistemáticas de smali
- Remover directivas .source

### 4. Patch de Configuración
- Actualizar minSdkVersion
- Cambiar installLocation
- Añadir sharedUserId

## Próximos Pasos

1. Crear scripts de parcheo automatizado
2. Desarrollar parches ReVanced modulares
3. Documentar proceso de aplicación
4. Probar en app original
5. Crear guía de usuario

## Notas Técnicas

- **Versión**: 42.9.3 (versionCode: 2024209030)
- **Target SDK**: 35
- **Min SDK**: 26 (modificado) / 23 (original)
- **Arquitecturas**: arm64-v8a, armeabi-v7a
