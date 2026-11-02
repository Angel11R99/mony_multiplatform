# P09 — Buscador y sistema de filtros

## Especificación
Consulta por texto sobre campos existentes permitidos: descripción, nombre categoría, método. Filtros: tipo ingreso/gasto, categoría, método, importe mín/máx, rango fecha, moneda si multimoneda, orden reciente/antiguo/importe. Combinar filtros con AND; selección múltiple dentro del mismo atributo con OR salvo decisión explícita. Chip de filtros activos, contador de resultados, Reset y aplicación coherente.

## Integración con datos
Debounce 250–400 ms de teclado, cancelación de búsquedas obsoletas, consultas parametrizadas Drift, índices solo si profiling justifica cambio y aprobación. Separar `draftFilter` del filtro aplicado si hay botón Aplicar. Persistencia de filtro durante cambio de tabs según P04, no global para toda la vida por defecto.

## Casos límite
Texto vacío, caracteres especiales/acentos, cantidades negativas inválidas, min > max, rango invertido, fecha inclusive (start inclusive/end exclusivo en timestamps cuando corresponda), muchas coincidencias, sin resultados, errores de BD.

## Aceptación
- [x] AC-09-1: Drift combina atributos distintos con AND; texto compara descripción/categoría/método con OR; varias categorías/métodos seleccionados usan `IN` (OR).
- [x] AC-09-2: Reset elimina texto, tipo, selección, rango de importe/fecha y restaura orden reciente.
- [x] AC-09-3: `stream_transform` debounce 300 ms; cada valor aplicado obtiene un stream de consulta actual, cancelando la suscripción anterior de Riverpod.
- [x] AC-09-4: filtros activos son `InputChip` eliminables y selecciones son controles Material accesibles por teclado.
- [ ] AC-09-5: falta la prueba manual de volumen representativo en el dispositivo del usuario; no se añadieron ni ejecutaron pruebas automatizadas según el flujo acordado.

## Decisiones P09
- Drift arma expresiones con parámetros enlazados. Los caracteres `%`, `_` y `\\` del usuario se escapan como literales en `LIKE`; no se interpolan valores en SQL.
- Fechas inclusivas por día de calendario mediante `dateEpochDay`. Rango invertido no puede elegirse desde `showDateRangePicker`.
- Los importes se convierten con `MoneyFormatter` a centavos; texto inválido, negativo o mínimo mayor que máximo no actualiza la consulta.
- La app solo maneja DOP hoy, así que no se ofrece filtro de moneda. SQLite `LIKE` conserva la búsqueda con acentos cuando coinciden los caracteres; SQLite base solo pliega mayúsculas ASCII, por lo que no garantiza equivalencia entre formas acentuadas mayúsculas/minúsculas en todos los targets.
- Se mantienen índices existentes de fecha, categoría y método. No se añadieron índices ni cambios de esquema sin profiling.
