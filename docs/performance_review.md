# Revisión de rendimiento

Fecha: 2026-11-04

## Cambios aplicados

- El historial ahora pide a Drift solo las primeras `N + 1` filas ordenadas. La fila adicional permite mostrar “Cargar más” sin descargar todo el resultado filtrado a Dart. Los filtros, orden y búsqueda siguen aplicándose en SQLite.
- El encabezado del historial obtiene el conteo y los totales de ingresos/gastos con una agregación SQLite reactiva; conserva los valores exactos aunque la lista muestre solo una página.
- La tabla de movimientos usa un índice compuesto por fecha, creación e ID para cubrir el orden principal del historial. La migración v10 reemplaza el índice simple de fecha; el orden descendente puede recorrerse directamente en el B-tree y reduce la necesidad de ordenar las filas coincidentes en memoria temporal de SQLite.
- El resumen del inicio y el snapshot de widgets mantienen solo los cinco movimientos más recientes durante un recorrido, en vez de copiar y ordenar el historial completo.
- Los totales del snapshot de widgets se calculan en el mismo recorrido de movimientos.
- Inicio consulta únicamente las filas de los seis meses del gráfico, su período seleccionado y los cinco movimientos recientes; el resumen sigue usando la misma función de dominio.
- El sincronizador de widgets consulta solo el ciclo actual, el anterior y los cinco movimientos recientes.
- Estadísticas calcula en SQLite los totales del período actual y comparable, el gasto por categoría, los límites y la evolución mensual; Dart recibe solo grupos agregados para los rangos fechados.
- “Todo el tiempo” usa una consulta SQL agregada: devuelve totales, categorías, límites y seis grupos mensuales en vez de materializar cada movimiento y conservar el historial completo en Riverpod.
- La pantalla de historial resuelve nombres de categorías y métodos de pago con mapas en vez de búsquedas lineales por cada fila visible.
- Presupuesto y calendario de actividad consultan solo el rango de fechas que representan, en lugar de observar el historial completo.
- El escáner de recibos busca candidatos por importe, tipo y día en SQLite; ya no espera ni carga el stream completo para revisar duplicados.
- La sincronización de widgets no inicia sus proveedores de datos en web o escritorio, donde las funciones nativas de widgets no están disponibles.
- Exportaciones consulta solo los movimientos del período seleccionado, y evita cargar movimientos si se desactiva esa sección.
- La codificación de exportaciones CSV, XLSX y PDF corre con `compute` para liberar el hilo de interfaz en móviles y escritorio; la prueba confirma que el documento cruza el isolate y produce el mismo CSV. En Flutter Web `compute` mantiene su fallback del runtime web.
- La restauración cifrada encola las inserciones por tabla en batches de Drift dentro de la transacción existente, en lugar de esperar un viaje asíncrono por cada fila; se conservan el orden de tablas, la validación de claves foráneas y la atomicidad.
- La pantalla de exportación solo mantiene streams de las secciones seleccionadas; presupuesto e historial de ciclos se omiten juntos cuando la sección de presupuestos está desactivada.
- Las consultas familiares con parámetros variables (búsquedas, rangos, IDs de detalle y resúmenes) ahora liberan sus streams y resultados cuando dejan de tener observadores, evitando conservar consultas antiguas.
- El proveedor general de transacciones libera su stream al quedar sin observadores; no hay consumidores de esa lista completa dentro de `lib/`.
- La vista previa del recibo y las imágenes de producto se decodifican cerca de su tamaño visible para reducir memoria de imágenes grandes.
- La lista de compras y su pantalla de detalle construyen bajo demanda las tarjetas de listas, productos y ajustes con builders de lista/sliver; la pantalla evita también buscar cada overview con `indexOf` (un recorrido lineal por fila). El historial de abonos de obligaciones usa una lista sliver perezosa y resuelve categorías/métodos desde mapas en vez de recorrer el catálogo en cada fila. Estadísticas construye las barras por categoría y las alertas de límite bajo demanda. Los retrasos de entrada en compras, obligaciones y recurrentes ahora tienen un máximo de 240 ms.
- El cierre de ciclos suma ingresos y gastos en SQLite, evitando materializar todos los movimientos del período en Dart.
- La pantalla de presupuesto obtiene los totales y gastos por categoría del período con una agregación SQL; deja de cargar cada movimiento del ciclo. Las filas de categorías se construyen bajo demanda al desplazarse.
- Recurrentes resuelve la categoría por ID con un mapa y reúne las métricas de la lista en un solo recorrido, en vez de volver a buscar en el catálogo y filtrar los movimientos por cada tarjeta.
- El detalle de una lista de compras calcula subtotales, conteos y productos sin precio una sola vez al recibir los datos; las reconstrucciones de pantalla reutilizan esos resultados en lugar de recorrer y multiplicar todos los productos varias veces.
- La creación de copias cifra una tabla cada vez que la lee, evitando conservar simultáneamente en memoria todas las filas como mapas y su JSON completo. La restauración valida las filas sin clonarlas y conserva la inserción por lotes y la transacción atómica.
- Los streams de historial de ciclos, metas de ahorro y resúmenes de compras se liberan cuando no tienen observadores. Se eliminó el proveedor de movimientos sin filtros porque ninguna pantalla lo consume.
- El refresco de recordatorios solo observa obligaciones y recurrencias cuando las notificaciones están activadas; esos proveedores se liberan cuando no quedan pantallas ni widgets que los observen.
- El procesador de ciclos programa un temporizador de una sola ejecución para la próxima medianoche o la hora de cierre automático configurada, en vez de consultar SQLite cada minuto; también revisa al inicio, al reanudar y ante cambios de configuración/series.
- La conciliación de recordatorios continúa al inicio, al reanudar y cuando cambian obligaciones, recurrentes o preferencias; un error programa un único reintento de respaldo a los cinco minutos.
- La barra inferior anterior (`nav_bar`) mantenía un ticker global que llamaba `setState` cada cuadro y controladores repetidos, incluso con efectos visuales apagados. Se retiró la dependencia y su identidad Sumi-e se reprodujo con pintado local: lavado de tinta y trazo que se animan solo al cambiar de módulo, sello bermellón separado del glifo de Historial e iconos de alto contraste. El icono seleccionado conserva el movimiento vertical y reduce su escala al 75%; respeta “reducir movimiento” y no mantiene ticker en reposo.
- Las fuentes Inter y Plus Jakarta Sans se empaquetan en variantes estáticas subseteadas para Latin/acentos y símbolos monetarios; la interfaz no solicita esas fuentes por red en el primer render. Se conserva Roboto porque la exportación PDF lo carga para generar documentos.
- El snapshot del widget reúne totales de obligaciones, metas y recurrencias durante el mismo recorrido de selección de elementos activos; antes repetía filtros y folds sobre esas listas. La pantalla de metas crea solo una lista filtrada por estado/búsqueda y calcula la consulta normalizada una vez por reconstrucción.

## Hallazgos que requieren trabajo adicional

- La comparación sintética de historial no sustituye una medición con datos reales ni cubre todas las consultas agregadas de estadísticas; conviene perfilar esas pantallas con una base poblada en dispositivo.
- Exportaciones y copias cifradas deben serializar conjuntos completos por diseño; aunque el procesamiento de archivos se separó del hilo principal o la copia ya se serializa por tabla, aún no se midió el pico de memoria con una base cercana al límite de 47 MiB de copia.
- No se midieron tiempos sostenidos de cuadro ni memoria en dispositivos físicos; el emulador no sustituye esos perfiles.
- Flutter advierte que `cryptography_flutter`, `file_saver` y `home_widget` aún aplican Kotlin Gradle Plugin propio; futuras versiones de Flutter dejarán de compilar esa configuración si los plugins no migran.

## Validación realizada

- `dart format` en los archivos modificados.
- `flutter analyze`: sin problemas.
- `git diff --check`: sin errores.
- `flutter build web --profile` y `flutter build web --release`: compilación exitosa; también pasó el dry run Wasm.
- `flutter build apk --profile`: compilación exitosa.
- Los builds finales tras virtualizar listas, agregar Presupuesto en SQLite, añadir la migración v10, mover la codificación de exportaciones a un isolate, agrupar la restauración de copias y eliminar el sondeo por minuto (`flutter build apk --profile` y `flutter build web --release`) compilaron correctamente; el build web pasó el dry run Wasm. La APK actual se instaló y abrió en el emulador Android conectado sin excepciones Flutter ni desbordamientos de layout.
- `flutter test`: suite completa exitosa, 202 pruebas pasaron, ninguna falló o quedó omitida; se volvió a ejecutar después de los cambios de fuentes, las optimizaciones del snapshot/lista y la verificación de familias tipográficas locales.
- Tras empaquetar Inter/Plus Jakarta Sans y retirar `google_fonts`, pasaron `flutter analyze`, `flutter test` (202 pruebas), `flutter build web --release` y `flutter build apk --profile`. Los logs de pruebas ya no muestran intentos de descargar familias tipográficas. El test de tema confirma que lectura usa Inter y los encabezados Plus Jakarta Sans.
- `flutter build apk --profile --split-per-abi` generó APK de 62.6 MiB (armeabi-v7a), 69.1 MiB (arm64-v8a) y 72.2 MiB (x86_64). El APK universal de perfil mide 187.4 MiB y contiene las tres arquitecturas. Por ABI, el paquete incluye aproximadamente 9.6–16.7 MiB comprimidos de bibliotecas ML Kit/barcode y 596 KiB de fuentes subseteadas; son medidas de perfil local, no la descarga final de Play ni el tamaño de una build release.
- `flutter test test/drift/app_database/migration_test.dart`: las 53 pruebas de migración pasaron; se comprobó v9→v10 con preservación de movimientos y reemplazo del índice, además de los saltos desde esquemas anteriores.
- `dart run drift_dev make-migrations` y `dart run build_runner build`: snapshot v10 y código Drift generados. El índice compuesto sustituye al índice de fecha simple, evitando mantener dos índices redundantes con coste de escritura.
- `EXPLAIN QUERY PLAN` sobre el orden paginado principal del historial muestra `SCAN transactions USING INDEX transactions_date_created_idx`, sin tabla temporal para ordenar ese recorrido.
- Las pruebas de UI ahora usan bases Drift in-memory con cierre síncrono de streams y descartan los toast temporales antes de terminar, evitando temporizadores falsos del harness.
- Sonda temporal de historial con 50.000 filas sintéticas en SQLite in-memory sobre el host Windows: página limitada de 51 filas en 21 ms, resumen agregado en 5 ms y materialización más ordenamiento completo en 980 ms. Una sola ejecución comparativa; no representa una medición Android ni una base de usuario.
- Comparación temporal de la consulta de obligaciones con 10.000 filas sintéticas: mediana de 17 ms para la subconsulta correlacionada indexada actual y 15 ms para un `LEFT JOIN` agrupado. La diferencia fue pequeña en este conjunto; se conservó la consulta existente.
- La pantalla Estadísticas → Todo y el rango mensual se abrieron en un emulador Android con agregaciones SQL activas y una base vacía; no hubo errores SQLite en logcat. Esto verifica integración básica, no compara latencia o valores con una base poblada.
- Tras la agregación SQL de Presupuesto, la APK de perfil se instaló en el emulador Android y se abrió la pantalla Plan de ciclo; los totales y las asignaciones aparecieron sin excepciones Flutter ni desbordamientos visuales. La base del emulador no contiene transacciones, por lo que los importes no fueron contrastados con datos poblados.
- Arranque `flutter run --profile --trace-startup` en emulador Android tras el cambio de navegación: primer cuadro en 1.976 s y primera imagen rasterizada en 2.216 s; se reportaron 84 cuadros omitidos durante el arranque. La referencia de una ejecución anterior en el mismo emulador fue 1.96 s y 52 cuadros omitidos. El arranque no muestra una mejora medible y las ejecuciones tienen variación; no se atribuye una ganancia de inicio a estos cambios.
- En reposo, `dumpsys gfxinfo` no registró cuadros nuevos, cuadros janky ni VSync perdidos durante una ventana de cinco segundos en la pantalla de inicio (`0/0/0`). La misma comprobación tras abrir Historial siguió en `0/0/0` en la lectura disponible. Es evidencia acotada del emulador, no un perfil de carga ni una medición de hardware físico.
- Se revisaron capturas de Historial y Compras en el emulador: aparecen los filtros, el resumen vacío y la navegación en Historial, y el estado vacío de bienvenida en Compras; no hubo errores SQLite ni Flutter en logcat.
- `flutter build windows --profile`: no disponible en este equipo porque falta habilitar Developer Mode para symlinks; Flutter Doctor también informa componentes faltantes de Desktop C++.
- `flutter build apk --release`: Gradle llegó a la etapa de empaquetado, pero el proyecto requiere firma de release mediante `MONY_RELEASE_*` o `android/key.properties`, ausente en este entorno. El build de perfil sí compila.
- Las capturas ADB del emulador siguen saliendo negras aun cuando la actividad está en primer plano y expone el árbol semántico Flutter. Se reprodujo tanto con Impeller como con una ejecución de perfil `--no-enable-impeller` (Skia); `FLAG_SECURE` aparece desactivado. Android Computer Use tampoco expone una ventana del emulador para capturarla desde el escritorio. Por ello la prueba automatizada confirma la escala del 75% y la selección, pero no hay evidencia visual concluyente del navbar en este emulador.
- iOS/macOS no se pudieron compilar desde el host Windows; requieren un host macOS y Xcode.
- No hay dispositivo físico conectado; las métricas Android provienen únicamente del emulador Android disponible en este host.

## Alcance de la revisión

- Se recorrieron `lib/` en búsquedas de listas desplazables, imágenes, streams, temporizadores y búsquedas repetidas por fila; las listas extensas visibles usan constructores o paginación, mientras que pantallas de configuración y formularios con contenido acotado mantienen desplazamiento simple.
- No se introdujeron animaciones infinitas ni dependencias nuevas; las animaciones de navegación se detienen al terminar la selección. Las automatizaciones usan temporizadores de una sola ejecución y reintentos acotados tras error.
