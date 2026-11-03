# P14 — Pruebas, accesibilidad y rendimiento

**Estado:** BLOCKED  
**Fecha:** 2026-11-02  
**Base:** P13 aprobada; cambios de código previos intactos  
**Siguiente:** corregir y estabilizar P14; P15 no iniciada

## Alcance y cambios

No se modificó código de la aplicación. Se ejecutaron los controles disponibles y se registraron los bloqueos observados. El único cambio previo de Git sigue siendo la modificación preexistente de `pubspec.lock`; no se alteró como parte de P14. Flutter creó `devtools_options.yaml` durante la verificación y se retiró al terminar.

## Criterios de aceptación

| Criterio | Estado | Evidencia |
|---|---|---|
| AC-14-1: lint/test sin regresiones | **BLOCKED** | `flutter analyze` pasó. La suite llegó a 162 pruebas aprobadas y 15 fallidas en la ejecución concurrente, con overflow/missed taps en navegación estrecha, timers de toastification pendientes y expectativas de UI fallidas. El proceso no cerró limpiamente. La repetición serial quedó bloqueada cargando `app_navigation_test.dart` y se detuvo; no cuenta como éxito. |
| AC-14-2: flujos core con integración automatizada | **PARTIAL** | Ya existen tests unitarios, Drift y de flujos widget, pero el fallo de la suite impide considerarlos evidencia aceptada. No se añadieron pruebas nuevas en esta fase. |
| AC-14-3: accesibilidad y contraste validados | **NOT DONE** | Hay comprobaciones semánticas puntuales existentes, pero no se encontró una suite de `AccessibilityGuideline`, contraste ni cobertura de escalado de texto. |
| AC-14-4: rendimiento comparado con baseline | **NOT DONE** | No hay baseline perfilado reproducible para startup, frames, memoria, bundle, consultas agregadas o listas de 1000+ filas. No se afirmaron mediciones. |
| AC-14-5: matriz de plataformas | **PARTIAL** | Solo hay runner/dispositivo Linux disponible. Android SDK y Chrome no están instalados; iOS, macOS y Windows no están disponibles en este host. No se ejecutaron builds de plataforma. |

## Comandos y resultados

- `flutter analyze` — OK, sin issues (Flutter 3.47.7, Dart 3.13.5).
- `flutter test` — suite no aceptable: 162 aprobadas, 15 fallidas al momento de quedarse bloqueada; se interrumpió el proceso colgado y no se toma ese resultado como ejecución completa.
- `flutter test --concurrency=1 --reporter=compact` — se bloqueó cargando `test/core/routing/app_navigation_test.dart`; se detuvo después de 1:05. No es una corrida completa.
- `flutter devices` — solo Linux desktop.
- `flutter doctor -v` — Linux toolchain disponible; Android SDK y Chrome ausentes.
- `rg` de tests — 33 `testWidgets`; no se encontraron golden tests ni `AccessibilityGuideline`/`meetsGuideline`.
- Git — `pubspec.lock` permanece modificado desde antes de P14; sin cambios de aplicación.

## Skills consultadas

- `flutter-testing`: estrategia de capas, determinismo y ciclo de vida de pruebas.
- `flutter-state-management`: ownership y transiciones de estado.
- `designing-flutter-architecture`: límites de capas al revisar la estructura existente.
- `flutter-ui-design`: matriz de verificación visual y accesibilidad; no se afirmó verificación visual sin render.

## Bloqueos y riesgos

1. La suite actual no produce un resultado verde ni termina consistentemente. Los traces incluyen overflow de layout/missed taps en el test de navegación de 320 px, timers pendientes generados por feedback, y algunas expectativas widget que no encontraron el contenido esperado.
2. No hay cobertura objetiva de contraste, texto ampliado, golden states ni rendimiento. El host no permite cubrir la matriz de plataformas requerida.
3. La ejecución concurrente pudo dejar artefactos de herramienta; se eliminó únicamente el archivo generado `devtools_options.yaml`. `pubspec.lock` fue preservado.

## Trabajo para desbloquear P14

- Reproducir cada fallo del runner por test, arreglar overflow/interacción real en viewport estrecho y hacer que tests de toast limpien timers/overlays de manera determinista.
- Añadir comprobaciones de accesibilidad y contraste sobre pantallas representativas, incluyendo texto ampliado.
- Definir y ejecutar un benchmark pequeño y reproducible para una lista de 1000 movimientos y consultas de estadísticas; registrar hardware y valores observados.
- Repetir suite completa hasta terminar con salida verde; anotar plataformas no disponibles sin declararlas probadas.

## Rollback

No hay cambios de código que revertir. El reporte y los estados de seguimiento pueden corregirse al resolver P14. No se inició P15.
