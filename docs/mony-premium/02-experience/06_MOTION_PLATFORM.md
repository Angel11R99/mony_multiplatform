# P05 — Motion, haptics y lenguaje nativo

## Motion tokens propuestos
Fast 120–180 ms (pressed/hover); standard 180–280 ms (tab/chip); emphasis 280–420 ms (modal/hero), sujetos a pruebas con dispositivos. Curvas coherentes, sin overshoot que perjudique lectura financiera.

## Patrones
- Transición de tabs corta, sin bloquear interacción; skeletons solo durante carga real.
- AnimatedSwitcher para cambios de estados y KPIs, sin animar números al abrir repetidamente con datos iguales.
- Presupuesto: evitar animar simultáneamente 30 filas y los gráficos; respetar `MediaQuery.disableAnimations` o API equivalente.
- iOS: Safe Areas, scroll physics apropiado, Cupertino picker si se decide; Android: Material 3 y feedback nativo; escritorio: hover/focus, scroll wheel, teclado y tooltips.
- Haptics opcionales y discretos, nunca obligatorios ni en cada scroll, fallback sin vibración.

## Pruebas
Widget tests con reduced motion, transición rápida entre tabs, foco por teclado, text scaling, animaciones sin interacción bloqueada.

## Aceptación
- [ ] AC-05-1: motion system centralizado.
- [ ] AC-05-2: reduced motion neutraliza decoraciones.
- [ ] AC-05-3: animaciones no cambian cifras ni crean dobles acciones.
- [ ] AC-05-4: UX accesible con teclado y tacto.
