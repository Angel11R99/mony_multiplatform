# P07 — Home Dashboard financiero

**Estado:** APPROVED bajo la autorización persistente del usuario, 2026-11-02.  
**Fase siguiente:** P08 — movimientos.  
**Regla de paquetes:** revisar primero pub.dev e integrar paquetes compatibles donde cubran la necesidad.

## Cambios

- Se aclara el indicador como balance neto del mes: ingresos menos gastos del período seleccionado, no saldo disponible de cuentas. El modelo no tiene cuentas, saldos iniciales ni monedas por movimiento; los importes existentes son DOP.
- Se añadieron agregados mensuales para seis meses desde las mismas transacciones, y una gráfica comparativa accesible con `fl_chart 1.3.0`.
- Si no hay transacciones, Home muestra el estado inicial y CTAs reales para registrar ingreso o gasto, sin presentar KPIs en cero.
- Las acciones principales permanecen visibles y los accesos secundarios dejaron de competir con el resumen y los movimientos.
- Si falla la carga de categorías, el dashboard sigue visible y ofrece reintentar esa parte; distingue nombres no disponibles de categorías archivadas.
- Los KPIs y la tendencia se derivan del stream local de Drift; las modificaciones de movimientos se reflejan a través de Riverpod. No se requiere conexión para leer los datos guardados.

## Aceptación

| Criterio | Evidencia |
|---|---|
| AC-07-1 | La suma usa centavos enteros y prueba determinista existente `test/features/dashboard/financial_dashboard_summary_test.dart` fija ingresos, gastos, balance y últimos movimientos. Pruebas no ejecutadas en esta fase. |
| AC-07-2 | Empty state condicional a cero movimientos globales; no grafica ni enseña métricas ficticias. |
| AC-07-3 | CTAs abren `transactionNew` con `type=income` o `type=expense`. |
| AC-07-4 | `dashboardSummaryProvider` observa `transactionsProvider`, un stream de Drift que actualiza tras las escrituras del repositorio. |
| AC-07-5 | Consulta local offline; loading/errors con recuperación, categorías como fallo parcial y lista reciente con scroll. Verificación de contenido largo en plataforma queda pendiente para el usuario. |

## Paquete evaluado

- `fl_chart 1.3.0`, MIT, publisher `flchart.dev`, Dart mínimo 3.6 y los seis targets actuales. Paquete activo (publicado 12 días antes de la consulta), con dependencias inmediatas `equatable` y `vector_math`; resuelto y fijado en `pubspec.lock`.
- Skeletons no agregados: el loader centrado mantiene geometría simple y estable. El SDK cubre el control sin introducir una representación duplicada de datos financieros.

## Verificación y límites

- `dart format`: PASS.
- `flutter analyze`: PASS (`No issues found`).
- `git diff --check`: PASS.
- `flutter run -d chrome`: la app inicializó desde `main`. El host de automatización no expuso Chrome para inspección/captura; no se declara revisión visual completada.
- No se ejecutaron pruebas automatizadas ni interacción manual. Revisión visual sugerida: vacío, datos típicos/largos, light/dark, 320–390 dp, ancho escritorio, texto ampliado y lector de pantalla para la descripción del gráfico.
- Riesgo: el gráfico no muestra etiquetas numéricas visibles en cada barra para evitar saturar seis grupos en móvil; su descripción semántica expone importes exactos, y los KPIs muestran los totales del mes seleccionado.

## Commits

Pendientes hasta la petición del siguiente paso, separados por dependencia, código del dashboard y documentación P07.
