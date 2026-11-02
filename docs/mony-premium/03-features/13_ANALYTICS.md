# P12 — Estadísticas, gráficos y comparaciones

## Métricas y definiciones
Ingresos del período, gastos del período, flujo neto = ingresos − gastos; gastos por categoría; tendencia diaria/mensual; comparación con período anterior equivalente. Escribir fórmula y tratamiento de transferencias, devoluciones, cancelaciones, zonas horarias y varias monedas. No presentar «rentabilidad» o «ahorro» si no se puede calcular correctamente.

## UX
Pantalla/section Analytics accesible desde Home. Tarjetas KPI + line/bar + donut solo cuando añadan comprensión, no gráficos decorativos. Filtros sincronizados entre gráficos; tooltip táctil/ratón, valores legibles, leyenda y tabla alternativa accesible. Mínimo de datos y barras 0 claramente representado; usar escalas no engañosas.

## Arquitectura
Agregaciones preferiblemente en capa repositorio/DAO, no reconstruir en cada frame. Serie temporal ordenada, periodos vacíos representados con 0, precisión monetaria, memoización/caching con invalidación en CRUD. Datos grandes => medir y optimizar. Charts no deben filtrar contenido financiero a servicios externos.

## Aceptación
- [ ] AC-12-1: agregados contrastados con dataset manual conocido.
- [ ] AC-12-2: periodos vacíos, una transacción y miles de transacciones.
- [ ] AC-12-3: gráficos accesibles con representación textual equivalente.
- [ ] AC-12-4: filtros sincronizados sin saltos de período.
- [ ] AC-12-5: varios tipos de moneda no se suman indebidamente.
