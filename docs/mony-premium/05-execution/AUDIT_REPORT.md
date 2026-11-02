# Reporte de auditoría — P00

**Fecha:** 2026-11-02 (America/Caracas)
**Estado:** PASS_PENDING_APPROVAL
**Commit base:** `d6c98f0`
**Branch:** `main`, 55 commits adelante de `origin/main` al inicio de P00; árbol de trabajo limpio.
**Alcance:** inspección de solo lectura del código y ejecución de análisis/pruebas. No se cambió código de la app, esquema/BD ni dependencias.

## Resumen

El proyecto es una app Flutter organizada por features con presentación, dominio y datos en las áreas principales. La app inicia en `/` (Home), usa GoRouter, Riverpod y Drift. El esquema local está en versión 9, con migraciones secuenciales hasta v9 y snapshots de esquema para migraciones. Hay CI en Linux y macOS. `flutter analyze` pasa; las 168 pruebas pasan al correrlas en una copia temporal limpia del código.

En el checkout original, `flutter test` se detuvo antes de iniciar porque Flutter no pudo borrar `build/native_assets/windows/sqlite3.dll`. El mismo fallo se reprodujo dos veces. La copia temporal permitió ejecutar la suite sin tocar el artefacto bloqueado; todas las pruebas pasaron. La compilación Windows no es verificable en este host porque Visual Studio carece de componentes C++ requeridos. iOS/macOS no son compilables desde Windows.

## Inventario funcional

| Área | Ubicación / rutas | Estado observado |
|---|---|---|
| Home | `lib/features/home/presentation/home_page.dart`; `/` | Resumen mensual desde movimientos y categorías; loading/error; balance, ingresos/gastos, accesos rápidos y lista reciente. Los cálculos del resumen están en `features/dashboard`. |
| Movimientos | `lib/features/transactions/{presentation,domain,data}`; `/transactions`, `/transactions/new`, `/transactions/:id`, `/transactions/:id/edit` | Lista con búsqueda/filtros/orden, alta/edición/detalle, validación y repositorio Drift. Pruebas de dominio, repositorio, flujo e historial presentes. |
| Categorías | `lib/features/categories/{presentation,domain,data}`; `/categories` | Administración, selector, validación y repositorio/tabla Drift. Pruebas de página, validador y repositorio presentes. |
| Métodos de pago | `lib/features/payment_methods/{presentation,domain,data}`; `/payment-methods` | Administración, selector, validación y repositorio/tabla Drift. Hay pruebas de página, validador y repositorio. |

La navegación se define centralmente en `lib/core/routing/app_router.dart`; la app se compone en `lib/app/app.dart` y el punto de entrada es `lib/main.dart`. Se encontraron rutas adicionales para presupuestos, ahorros, estadísticas, compras, obligaciones, movimientos recurrentes, exportación/respaldo, escáneres, widgets y ajustes. El Home actual es un `Scaffold` con barra superior de acciones y contenido de resumen centrado (máximo 760 px), selector mensual, balance, métricas y accesos rápidos. Esta descripción procede del código; no se capturó una imagen de baseline.

## Estado, persistencia y datos

- Estado/UI: Riverpod 3; `ProviderScope` en `main.dart`; providers por feature para datos reactivos y repositorios.
- Navegación: GoRouter 18; rutas con nombre y rutas hijas para detalle/edición.
- Persistencia: Drift 2 con `drift_flutter`; `AppDatabase` en `lib/core/database/app_database.dart`, schemaVersion **9**, 13 tablas declaradas y callbacks `from1To2`…`from8To9`.
- Datos iniciales: categorías y métodos de pago insertados únicamente al crear la BD (`onCreate`). No se inspeccionaron bases de datos privadas.
- Backup: existe `encrypted_database_backup.dart` y pruebas de backup/restauración cifrados.
- Web: están presentes `web/sqlite3.wasm` y `web/drift_worker.js`, configurados en las opciones Drift Web.
- No se identificó una capa configurada de `flutter_localizations`/`localizationsDelegates` en `pubspec.yaml` o `lib`; sí se usa `intl`. La experiencia localizada debe revisarse en su fase correspondiente.

## SDK y plataformas

- `flutter --version`: Flutter 3.44.4 stable, framework `ad70ec4617`, Dart 3.12.2, Windows x64.
- `dart --version`: Dart SDK 3.12.2 stable, Windows x64.
- Constraint en `pubspec.yaml`: `sdk: ^3.12.2`.
- Targets del proyecto: Android, iOS, Web, Linux, macOS y Windows (directorios de plataforma presentes).
- Dispositivos detectados: Windows desktop, Chrome y Edge. Android toolchain y licencias disponibles; no se detectó emulador/dispositivo Android conectado.
- `flutter doctor -v`: Windows 11; Android SDK 36.1.0/JDK 17; Chrome disponible. Visual Studio 2026 está presente pero incompleto: faltan componentes de Desktop development with C++, por lo que no se validó el build Windows. No se ejecutaron builds Android/iOS/web/desktop en P00. iOS/macOS requieren host macOS para compilar.
- Hay código de fallback explícito en escáner de códigos/tickets, notificaciones y widgets de plataforma. La compatibilidad concreta de todos los plugins y features queda pendiente de matriz P01; no se infiere por la mera presencia de carpetas de plataforma.

## Dependencias

Las versiones resueltas se leyeron de `pubspec.lock` (`dart pub deps --style=compact`). Dependencias directas principales: `flutter_riverpod 3.4.3`, `go_router 18.1.2`, `drift 2.35.3`, `drift_flutter 0.3.1`, `shared_preferences 2.5.6`, `intl 0.20.2`, `flutter_local_notifications 22.3.3`, `flutter_timezone 5.1.1`, `pdf 3.13.1`, `excel_plus 2.29.2`, `file_saver 0.4.0`, `share_plus 13.3.1`, `mobile_scanner 7.5.0`, `http 1.6.0`, `image_picker 1.2.4`, `google_mlkit_text_recognition 0.17.1`, `home_widget 0.10.0`, `cryptography 2.9.0`, `cryptography_flutter 2.3.4`, `file_picker 13.3.2`, `path_provider 2.1.6`, `timezone 0.11.2` y `cupertino_icons 1.0.9`.

Desarrollo: `flutter_test` del SDK, `flutter_lints 6.0.0`, `drift_dev 2.35.2`, `build_runner 2.15.1`. No hay dependencias directas repetidas. El lock contiene tanto `sqlite3_flutter_libs 0.6.0+eol` como `sqlcipher_flutter_libs 0.7.0+eol` de forma transitiva por `drift_flutter`; es una posible superposición/riesgo de mantenimiento a verificar en P01, no una incompatibilidad demostrada por esta auditoría. No se verificaron pub.dev, licencias ni soporte/versiones vigentes paquete por paquete en P00.

## Verificaciones ejecutadas

| Comando | Resultado |
|---|---|
| `git status --short --branch`; `git rev-parse --short HEAD` | Antes de P00: `## main...origin/main [ahead 55]`; commit `d6c98f0`; árbol sin cambios locales. |
| `flutter --version` | Flutter 3.44.4 stable, Dart 3.12.2. |
| `dart --version` | Dart SDK 3.12.2 stable. |
| `flutter analyze` | `No issues found! (ran in 1.6s)`. |
| `flutter test` (checkout original; repetido) | No empezó: Flutter no pudo borrar `build/native_assets/windows/sqlite3.dll`; fallo de acceso al archivo. `--no-pub --no-test-assets` reprodujo el mismo error. |
| `flutter test --no-pub` (copia temporal limpia de `lib`, `test`, `assets`, config y `.dart_tool`) | `All tests passed!`, contador final **+168**. El checkout original y sus datos no se modificaron para conseguir la ejecución. |
| `flutter doctor -v`; `flutter devices` | Flutter/Android/Web disponibles; build Windows bloqueado por componentes VS faltantes; dispositivos detectados Windows, Chrome, Edge. |
| `dart pub deps --style=compact` | Resolución de dependencias disponible; versiones en la sección anterior. |

No se ejecutaron pruebas manuales en dispositivo, capturas, golden tests adicionales ni builds por plataforma.

## Riesgos priorizados

- **Alto:** validar que plugins de cámara/OCR, notificaciones, compartir/archivos, Drift y widgets tengan comportamiento/fallback adecuado en cada target; P00 solo confirma código y targets, no builds multiplataforma.
- **Medio:** `flutter test` no puede correr directamente desde el checkout porque Flutter no puede borrar `build/native_assets/windows/sqlite3.dll`. La suite sí pasa en una copia temporal. Investigar qué proceso retiene el archivo antes de depender de ejecución local normal.
- **Medio:** build Windows no validable con la instalación actual de Visual Studio.
- **Medio:** las dos bibliotecas SQLite/SQLCipher transitivas marcadas `+eol` requieren revisión de dependencia/uso real y alternativas en P01.
- **Bajo:** no se encontró configuración de localización Flutter pese al uso de `intl`; confirmar alcance e idioma de UI en fases de experiencia.

## Criterios P00

- [x] AC-00-1: las cuatro áreas objetivo tienen rutas/archivos identificados.
- [x] AC-00-2: fuente de estado y BD identificada; no se accedió a datos de usuario ni se cambiaron datos.
- [x] AC-00-3: SDK y targets informados según archivos y herramientas del entorno.
- [x] AC-00-4: comandos registrados con resultado o limitación reproducible.
- [x] AC-00-5: riesgos clasificados por prioridad.

## Cambios, decisiones y reversión

- Archivos de aplicación, paquetes y datos: **sin cambios**.
- Documentación actualizada para registrar P00: este reporte, `PROGRESS.md`, `CHANGELOG.md` y `ACCEPTANCE_MATRIX.md`.
- ADR: ninguno; la auditoría no selecciona ni cambia arquitectura o paquetes.
- Rollback: revertir los cuatro cambios documentales de P00. No hay migración, instalación ni operación de datos que revertir.
- Skills consultadas: `dart-flutter-patterns`, `designing-flutter-architecture`, `flutter-drift`, `flutter-navigation`, `flutter-state-management`, `flutter-testing`, `flutter-ui-design` (rutas del repo `.agents/skills/`).

## Siguiente fase sugerida

P01: matriz de dependencias, licencias, SDK y soporte por plataforma; verificar la superposición de SQLite/SQLCipher y documentar ADR solo cuando la evidencia lo permita. No iniciada.
