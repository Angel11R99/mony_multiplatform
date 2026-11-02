# P09 — Buscador y sistema de filtros

## Especificación
Consulta por texto sobre campos existentes permitidos: descripción, nombre categoría, método. Filtros: tipo ingreso/gasto, categoría, método, importe mín/máx, rango fecha, moneda si multimoneda, orden reciente/antiguo/importe. Combinar filtros con AND; selección múltiple dentro del mismo atributo con OR salvo decisión explícita. Chip de filtros activos, contador de resultados, Reset y aplicación coherente.

## Integración con datos
Debounce 250–400 ms de teclado, cancelación de búsquedas obsoletas, consultas parametrizadas Drift, índices solo si profiling justifica cambio y aprobación. Separar `draftFilter` del filtro aplicado si hay botón Aplicar. Persistencia de filtro durante cambio de tabs según P04, no global para toda la vida por defecto.

## Casos límite
Texto vacío, caracteres especiales/acentos, cantidades negativas inválidas, min > max, rango invertido, fecha inclusive (start inclusive/end exclusivo en timestamps cuando corresponda), muchas coincidencias, sin resultados, errores de BD.

## Aceptación
- [ ] AC-09-1: combinaciones AND/OR documentadas y testeadas.
- [ ] AC-09-2: Reset elimina filtros y actualiza resultados.
- [ ] AC-09-3: entrada rápida no produce resultados obsoletos.
- [ ] AC-09-4: accesibilidad chips y teclado.
- [ ] AC-09-5: pruebas con volúmenes representativos.
