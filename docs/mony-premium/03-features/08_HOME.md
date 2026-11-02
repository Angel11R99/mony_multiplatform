# P07 — Home Dashboard financiero

## Jerarquía de contenido
1. Header compacto Mony + acciones justificadas (ajustes/perfil si existen).
2. Balance total con moneda visible y fecha de actualización válida.
3. Dos indicadores: Ingresos y Gastos del período seleccionado.
4. Resumen gráfico simple y/o tendencia solo cuando el origen de datos sea fiable.
5. Movimientos recientes (3–5) + «Ver todos».
6. Acciones rápidas «Añadir ingreso» y «Añadir gasto», vinculadas a flujos reales.

## Precisión
Los modelos actuales solo almacenan movimientos de ingreso/gasto en DOP; no existen cuentas con saldos iniciales ni conversiones de moneda. Por eso Home presenta **balance neto del mes seleccionado = ingresos del mes − gastos del mes**, no dinero disponible de cuentas ni balance total histórico. Cada movimiento se recorre una vez y el cálculo usa centavos enteros. Los KPIs corresponden al mes seleccionado; recientes son los cinco movimientos más nuevos de todos los meses.

La gráfica compara ingresos y gastos de cada uno de los seis meses terminados en el mes seleccionado, calculados desde los mismos movimientos locales. No se dibuja cuando aún no existe ningún movimiento.

## Estados
Primera instalación: empty state con CTA a los formularios reales de ingreso y gasto; sin métricas demostrativas. Loading con tamaño estable. Error del stream financiero con retry. Si falla la carga de categorías, el resumen sigue disponible y el aviso ofrece reintentar; los nombres ausentes no se atribuyen falsamente a categorías archivadas. El almacenamiento es local, así que no se necesita conexión para consultar movimientos existentes. Pull-to-refresh no aplica al stream local.

## Aceptación
- [x] AC-07-1: fórmula y agregados usan centavos enteros; el test existente `financial_dashboard_summary_test.dart` comprueba ingresos, gastos, balance y orden reciente con fixtures deterministas.
- [x] AC-07-2: sin movimientos, Home muestra estado vacío y CTA; no presenta cifras inventadas ni KPIs cero como balance.
- [x] AC-07-3: CTAs pasan `type=income` o `type=expense` a la ruta del formulario real.
- [x] AC-07-4: `dashboardSummaryProvider` deriva del `transactionsProvider` reactivo que emite Drift después de cambios.
- [x] AC-07-5: datos vienen de Drift local (lectura offline); hay loading, error/retry y lista scrollable. No se ejecutaron pruebas automatizadas ni se hizo captura manual de contenido largo.

## Componentes y dependencias

- Tendencia implementada con [`fl_chart`](https://pub.dev/packages/fl_chart) 1.3.0: MIT, publisher `flchart.dev`, Dart >=3.6, compatible con los seis targets del proyecto y dependencias inmediatas `equatable` y `vector_math`. Consultado 2026-11-02; lock resuelto.
- Se evita una gráfica casera con `CustomPainter`. `skeletonizer` y `shimmer` se evaluaron y se conservaron los estados de carga nativos: un spinner centrado de tamaño estable no necesita skeletons que dupliquen la estructura financiera.
- Para verificar manualmente: tema claro/oscuro, tamaño compacto y ancho, texto ampliado, lector de pantalla sobre la descripción accesible del gráfico, primera instalación, 1 movimiento, mes sin actividad, error del stream y navegación de los dos CTA.
