# P12 — Estadísticas, gráficos y comparaciones

## Métricas y definiciones
Ingresos y gastos son sumas de `amountInCents` por `TransactionType` dentro de fechas civiles inclusivas; balance neto = ingresos − gastos. El promedio de gasto usa división entera por cantidad de movimientos de gasto. Las tarjetas no etiquetan el balance como ahorro ni rentabilidad.

El mes y el año comparan el acumulado hasta el mismo día del período anterior; el ciclo de presupuesto compara la misma cantidad de días inmediatamente anteriores. Histórico completo y rango personalizado no muestran porcentaje comparativo. Las fechas se guardan como día civil local, sin hora ni conversión de zona horaria. La moneda no está en el modelo: todos los importes actuales se interpretan como DOP y no se mezclan monedas. Transferencias, devoluciones y cancelaciones no son tipos del modelo; hoy se reflejan según estén registradas como ingreso/gasto y no se netean automáticamente. La eliminación física de un movimiento lo quita de agregados.

## UX
Pantalla Estadísticas en el shell. Tarjetas KPI + línea de ingresos/gastos con `fl_chart` (paquete ya adoptado en P07), interacción por toque y leyenda. El selector de categoría se aplica a KPIs, tendencia, comparación y desglose. La línea muestra seis meses para histórico completo; para otros períodos muestra meses seleccionados hasta un máximo de 12, claramente rotulado. Meses sin movimientos conservan valor cero. Una sección expandible expone los valores legibles por mes para lector de pantalla y como alternativa textual.

## Arquitectura
Los agregados se derivan en memoria del stream reactivo local de Drift y se recalculan al reconstruirse la vista; no hay caché de agregación ni consultas DAO especializadas. El chart no envía datos financieros fuera del dispositivo. Para miles de filas queda pendiente medir latencia real y, si hace falta, mover las agregaciones a consultas en el repositorio.

## Aceptación
- [x] AC-12-1: fórmulas enteras, inclusividad y reglas de comparación están definidas; contrastación interactiva queda para UAT manual.
- [x] AC-12-2: meses vacíos se rellenan con cero y un solo mes queda representable; rendimiento con miles queda pendiente de medición.
- [x] AC-12-3: Semantics describe el gráfico y la sección expandible lista valores por mes.
- [x] AC-12-4: categoría afecta agregados y serie; cambios de rango reconstruyen serie desde el período seleccionado.
- [x] AC-12-5: el modelo actual solo admite DOP, así que no puede agregar monedas distintas; multi-moneda requerirá ampliar modelo y conversiones antes de sumarlas.
