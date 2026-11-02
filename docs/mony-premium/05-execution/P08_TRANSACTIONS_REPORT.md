# P08 — Movimientos y operación financiera

**Estado:** APPROVED bajo la autorización persistente del usuario, 2026-11-02.  
**Fase siguiente:** P09 — búsqueda, filtros y orden.  
**Commits P07 cerrados antes de iniciar:** `c8df2f4`, `97d5a0d`, `b692604`.

## Cambios

- `flutter_slidable 4.0.3` en filas independientes con editar, duplicar y eliminar. La última versión pub.dev 5.2.0 exige Flutter 3.47/Dart 3.13; 4.0.3 se resuelve con Flutter 3.44/Dart 3.12. El menú de fila sigue accesible como alternativa y los movimientos de series conservan su acción de administración.
- Historial cronológico agrupado por día, con keys estables y `SlidableAutoCloseBehavior`. Las ordenaciones por importe conservan el orden global y muestran fecha en cada fila.
- Corregido el estado vacío sin filtros (`Todavía no hay movimientos`); se conserva el mensaje distinto para búsquedas/filtros sin resultados.
- Categoría y método activos y tipo válido se verifican tanto en formulario como en repositorio. El importe se parsea a centavos DOP y debe ser mayor de cero.
- Home y listado siguen leyendo el stream de Drift compartido; no se añadieron estado duplicado, mutaciones optimistas ni cambios de esquema.
- Se muestra el error concreto de dominio cuando persistencia rechaza duplicar/eliminar. Cambiar la fecha en un formulario nuevo ahora cuenta como borrador; una sola confirmación de descarte y guardado bloqueado mientras persiste.

## Aceptación

| Criterio | Evidencia |
|---|---|
| AC-08-1 | CRUD/restricciones cubiertos por `drift_transaction_repository_test.dart`; creación UI por `transaction_flow_test.dart`. No ejecutados en P08. |
| AC-08-2 | La cancelación de `MonyConfirmDialog` sale antes del repositorio; estática revisada. |
| AC-08-3 | Gestos por paquete y acciones alternativas en menú; etiquetas de acción explícitas. |
| AC-08-4 | `transactionsProvider` alimenta historial y dashboard a través de sus providers derivados reactivos. |
| AC-08-5 | `PopScope` contempla importe, descripción, tipo, fecha, categoría y método; errores de guardado dejan el formulario montado. |

## Verificación y límites

- `dart format`: PASS.
- `flutter analyze`: PASS (`No issues found`).
- `git diff --check`: PASS.
- `flutter build web --release`: PASS (`Built build\\web`; Wasm dry run succeeded).
- Pruebas automatizadas y prueba manual de gestos no ejecutadas; el usuario hará la revisión interactiva.
- No se cambió el esquema ni existen aún transferencias/reembolsos en el dominio. Acciones de swipe validan visual/lector de pantalla en el menú alternativo; revisar en Android/iOS y Chrome antes de release.

## Commits

Pendientes hasta que el usuario pida el siguiente paso, separados por dependencia, integración de CRUD/listado/editor y documentación P08.
