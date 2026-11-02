# P08 — Movimientos y operación financiera

## UX
Listar ingresos/gastos agrupados por fecha con importe y moneda, categoría, método y descripción cuando existan. CTA agregar, detalle, editar, eliminar y confirmación. Swipes con acciones accesibles también por menú o botón visible.

## Reglas de negocio
Validar tipo, importe > 0, redondeo/precisión monetaria, fecha y relación válida con categoría y método; no cambiar esquema ni semántica actual sin ADR. Cuando existan transferencias/reembolsos, documentar impacto en estadísticas para evitar doble conteo.

## Rendimiento y resiliencia
ListView.builder/paginación si volumen alto, agrupación ordenada con stable keys, estados empty/loading/error, actualizaciones optimistas solo con rollback correcto, doble submit bloqueado, error persistencia informado sin borrar datos de formulario.

El historial se agrupa por día para orden cronológico; al ordenar por importe, la lista conserva el orden global y cada fila mantiene su fecha visible. Las acciones de deslizamiento se ofrecen solo para movimientos independientes; el menú de cada fila sigue disponible como alternativa accesible y por puntero/teclado. Eliminar siempre abre confirmación.

La forma guarda importes en centavos DOP, exige importe mayor que cero, categoría activa del tipo correcto y método activo; el repositorio repite validaciones transaccionales. No existen transferencias ni reembolsos en el modelo actual, así que P08 no altera esquema ni reglas contables. Cambiar la fecha en un formulario nuevo también activa la protección de borrador.

## Aceptación
- [x] AC-08-1: crear/editar/eliminar y restricciones cubiertos por `drift_transaction_repository_test.dart`; flujo UI de creación cubierto por `transaction_flow_test.dart` (pruebas no ejecutadas en P08).
- [x] AC-08-2: la ruta de eliminación sale antes de mutar el repositorio si no se confirma.
- [x] AC-08-3: `flutter_slidable` con iconos/labels y `SlidableAutoCloseBehavior`; el menú visible conserva editar, duplicar y eliminar como alternativa.
- [x] AC-08-4: listado y dashboard consumen el mismo `transactionsProvider` de Drift; cambios persistidos reemiten ambos.
- [x] AC-08-5: `PopScope` protege texto, importe, tipo, categoría, método y fecha en edición/creación; la salida confirmada se serializa y el guardado evita doble submit.
