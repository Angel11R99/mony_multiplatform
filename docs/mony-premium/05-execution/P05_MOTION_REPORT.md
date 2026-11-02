# P05 — Motion, haptics y lenguaje nativo

**Fecha:** 2026-11-02  
**Base:** P04 integrada con `circle_nav_bar` 2.2.0  
**Estado:** APPROVED bajo la autorización persistente del usuario para aprobar fases implementadas.  
**Siguiente fase:** P06, pendiente de inicio.

## Entrega

- `MonyMotion` centraliza tokens y aplica `MediaQuery.disableAnimations` a las transiciones nuevas.
- El indicador de pestañas se mueve en 220 ms y el icono activo en 120 ms; ambos se neutralizan con movimiento reducido.
- La navegación móvil expone cuatro botones semánticos seleccionables con foco visible, activación por teclado y toque.
- `animations` 3.0.0 provee `PageTransitionSwitcher` y Fade Through para importes destacados de balance y métricas, solo cuando cambia el texto. No hay interpolación numérica, acción duplicada ni animación al reconstruir con el mismo importe. La accesibilidad recibe un único valor actual.
- No se añadieron vibraciones: no se necesitó un paquete ni un gesto háptico adicional.

## Criterios de aceptación

| Criterio | Resultado | Evidencia |
|---|---|---|
| AC-05-1 | Cubierto | Duraciones y curva compartidas en `MonyMotion`. |
| AC-05-2 | Cubierto en código; dispositivo pendiente | `durationFor` devuelve cero con `disableAnimations`; test widget escrito, no ejecutado. |
| AC-05-3 | Cubierto | `PageTransitionSwitcher` cambia solo el widget keyed del importe; no interpola el valor numérico. |
| AC-05-4 | Implementado; revisión manual pendiente | InkWell enfocable, foco visible, semántica button/selected y callback compartido entre teclado y toque. |

## Verificación y límites

- `dart format`, `flutter analyze` y `git diff --check` ejecutados; análisis sin issues.
- Test widget de movimiento reducido y duración estándar añadido a `test/core/theme/mony_design_system_test.dart`; no ejecutado para que el usuario pruebe.
- No se validó en dispositivo el contraste/foco ni el ajuste de los tiempos. La verificación manual queda pendiente.
- P05 agrega `animations` 3.0.0, publisher `flutter.dev`, BSD-3-Clause; compatible con SDK y targets del proyecto. Su uso queda registrado en la matriz de P01. `flutter_animate` se descartó para esta necesidad por publicación antigua y dependencias adicionales.
- P05 está aprobada bajo la autorización persistente; sus commits quedan para cuando el usuario pida continuar. P06 permanece TODO.

## Archivos principales

- `lib/core/theme/mony_tokens.dart`
- `lib/core/routing/mony_navigation_shell.dart`
- `lib/core/widgets/mony_finance_widgets.dart`
- `test/core/theme/mony_design_system_test.dart`
- `docs/mony-premium/02-experience/06_MOTION_PLATFORM.md`
