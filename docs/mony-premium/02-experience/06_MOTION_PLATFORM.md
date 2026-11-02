# P05 — Motion, haptics y lenguaje nativo

## Motion tokens propuestos
Fast 120–180 ms (pressed/hover); standard 180–280 ms (tab/chip); emphasis 280–420 ms (modal/hero), sujetos a pruebas con dispositivos. Curvas coherentes, sin overshoot que perjudique lectura financiera.

## Implementación P05
- `MonyMotion` centraliza duraciones y curvas, y usa `MediaQuery.disableAnimations` para llevar las transiciones decorativas a duración cero y curva lineal.
- `circle_nav_bar` usa 220 ms para desplazar el indicador y 120 ms para el icono activo; el modo de movimiento reducido los neutraliza. Los destinos superpuestos son controles InkWell, conservan foco visible y admiten teclado y tacto.
- Los importes de Balance/StatTile usan `PageTransitionSwitcher` y Fade Through de `animations` 3.0.0 solo cuando cambia el texto. No interpola ni cuenta cifras, y no anima si el dato se mantiene igual. La semántica publica un único valor actual.
- No se agregó haptics: son opcionales y no se justificó feedback háptico adicional sobre las respuestas táctiles nativas de Flutter.

## Patrones
- Transición de tabs corta, sin bloquear interacción; skeletons solo durante carga real.
- `PageTransitionSwitcher` para transiciones de KPI, sin animar números al abrir repetidamente con datos iguales.
- Presupuesto: evitar animar simultáneamente 30 filas y los gráficos; respetar `MediaQuery.disableAnimations` o API equivalente.
- iOS: Safe Areas, scroll physics apropiado, Cupertino picker si se decide; Android: Material 3 y feedback nativo; escritorio: hover/focus, scroll wheel, teclado y tooltips.
- Haptics opcionales y discretos, nunca obligatorios ni en cada scroll, fallback sin vibración.

## Pruebas
Widget tests con reduced motion, transición rápida entre tabs, foco por teclado, text scaling, animaciones sin interacción bloqueada.

## Aceptación
- [x] AC-05-1: motion system centralizado en `MonyMotion`.
- [x] AC-05-2: reduced motion neutraliza decoraciones mediante duración cero.
- [x] AC-05-3: transición discreta con `animations`; nunca interpola cifras ni cambia acciones.
- [x] AC-05-4: controles de navegación con foco visible, teclado, semántica y tacto.
