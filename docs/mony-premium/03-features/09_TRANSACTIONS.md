# P08 — Movimientos y operación financiera

## UX
Listar ingresos/gastos agrupados por fecha con importe y moneda, categoría, método y descripción cuando existan. CTA agregar, detalle, editar, eliminar y confirmación. Swipes con acciones accesibles también por menú o botón visible.

## Reglas de negocio
Validar tipo, importe > 0, redondeo/precisión monetaria, fecha y relación válida con categoría y método; no cambiar esquema ni semántica actual sin ADR. Cuando existan transferencias/reembolsos, documentar impacto en estadísticas para evitar doble conteo.

## Rendimiento y resiliencia
ListView.builder/paginación si volumen alto, agrupación ordenada con stable keys, estados empty/loading/error, actualizaciones optimistas solo con rollback correcto, doble submit bloqueado, error persistencia informado sin borrar datos de formulario.

## Aceptación
- [ ] AC-08-1: crear/editar/eliminar funciona con repositorio real o doble en tests.
- [ ] AC-08-2: cancelar delete no cambia BD.
- [ ] AC-08-3: listas accesibles y acciones alternativas a swipe.
- [ ] AC-08-4: Home y lista reflejan cambios consistentes.
- [ ] AC-08-5: no se pierde borrador inesperadamente.
