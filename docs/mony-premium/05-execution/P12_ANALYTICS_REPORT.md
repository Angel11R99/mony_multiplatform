# P12 — Estadísticas, gráficos y comparaciones

**Estado:** APPROVED bajo la autorización persistente del usuario  
**Fecha:** 2026-11-02  
**Base:** commits P11 `5101482` (integridad) y `034989d` (documentación)  
**Siguiente:** P13 — privacidad y manejo de datos

## Implementado

- El gráfico manual `CustomPainter` se reemplazó por `LineChart` de `fl_chart` 1.3.0, dependencia existente adoptada en P07. Incluye tooltip al tocar, colores/leyenda para ingresos y gastos, escala desde cero, etiqueta semántica y una lista expandible con los importes por mes.
- La tendencia respeta el rango seleccionado y el filtro de categoría. Histórico completo conserva seis meses; rangos de más de 12 meses muestran los 12 más recientes y lo dicen en el título. Los meses vacíos se incluyen con importes cero.
- KPIs, comparación, desglose, límites y tendencia usan la selección de categoría. Las métricas usan sumas de enteros en centavos.
- Mes y año comparan acumulados hasta el mismo día del período anterior; ciclo compara una ventana de igual duración. Histórico y rango personalizado no presentan una variación porcentual que no tenga período comparable.
- El rango mensual se limita al mes transcurrido hasta hoy.

## Verificación

- `dart format lib/features/statistics/domain/financial_statistics.dart lib/features/statistics/presentation/statistics_page.dart` — OK.
- `flutter analyze` — OK, sin issues.
- `git diff --check` — OK.
- `flutter build web --release` — OK; build finalizado y dry run Wasm exitoso.
- No se ejecutó la suite automatizada, según la preferencia de validación manual del usuario. Los tests existentes conservan compatibilidad con el argumento `months` de `monthlyStatistics`.

## Alcance pendiente para validación manual

- El usuario puede contrastar importes en la pantalla con movimientos conocidos, un período vacío y un período con un único movimiento.
- No se midió rendimiento con miles de movimientos. El cálculo sigue derivándose en memoria del stream local y no tiene caché ni consulta agregada en DAO; si la medición manual/P14 indica latencia, mover agregación a la capa de datos.
- El modelo almacena una sola moneda implícita, DOP; por tanto no mezcla divisas. Transferencias, reembolsos y cancelaciones no tienen semántica propia en el esquema, y siguen el tipo ingreso/gasto con el que estén registradas. Fechas financieras son fechas civiles, sin zona horaria.
- Los totales incluyen solo movimientos aún presentes en Drift; eliminar un movimiento lo retira de la estadística.

## Archivos

- `lib/features/statistics/domain/financial_statistics.dart`
- `lib/features/statistics/presentation/statistics_page.dart`
- `docs/mony-premium/03-features/13_ANALYTICS.md`
- `docs/mony-premium/05-execution/ACCEPTANCE_MATRIX.md`
- `docs/mony-premium/05-execution/PROGRESS.md`
- `docs/mony-premium/05-execution/CHANGELOG.md`

Los commits de implementación y documentación quedan pendientes hasta que el usuario solicite el siguiente paso; se separarán por categoría.
