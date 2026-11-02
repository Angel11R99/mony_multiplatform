# P14 — Testing, accesibilidad y rendimiento

## Pirámide de pruebas
Unit: formatting, importes, fechas, rangos, cálculos, filtros. Widget: shell, tabs, empty/error/loading, formularios, modales, reduced motion, focus/semantics. Integration: crear movimiento → Home/Analytics, editar, eliminar con confirmación, filtro + calendario, web navegación, rutas. Golden tests para al menos Home/Transactions/Dialogs dark y light si el entorno soporta fonts estables.

## Matriz mínima
Mobile estrecho 320–390dp, teléfono grande, tablet, escritorio 1024+, texto 200%, landscape, dark/light, teclado/ratón/touch, Internet ausente (si offline), 0 / 1 / 1000+ transacciones. Plataformas iOS, Android, Windows, macOS, Linux y web se prueban **según SDK y runner disponibles**; reportar no probadas.

## Performance
Perfil antes/después cuando sea posible: smoothness, frame build/raster, memoria, tamaño de bundle, startup, lista de 1000 filas, query agregadas. Objetivos se basan en baseline y hardware comprobado, no cifras publicitarias. Evitar cargas repetidas, jank en scroll y múltiples setState por evento.

## Aceptación
- [ ] AC-14-1: CI/local lint/test sin regresiones.
- [ ] AC-14-2: core flows con integración automatizada donde sea viable.
- [ ] AC-14-3: accesibilidad y contraste validados.
- [ ] AC-14-4: comparación de perf con baseline o limitación reproducible.
- [ ] AC-14-5: matriz de plataformas reales y pendientes.
