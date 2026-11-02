# Historial de implementación

## P09 — Búsqueda y filtros combinados — 2026-11-02
- Resultado: APPROVED bajo la autorización persistente del usuario.
- `stream_transform 2.1.2` aporta debounce de 300 ms; la consulta reactiva de Drift busca descripción, categoría y método y combina filtros AND/OR parametrizados.
- Añadidos filtros por tipo, selección múltiple de categorías y métodos, rango de importes validado, fechas inclusivas, orden y chips eliminables; Reset restaura el estado inicial.
- Sin cambios de esquema. Limitación documentada: SQLite base no normaliza mayúsculas acentuadas para `LIKE` en todos los targets.
- `dart format`, `flutter analyze`, `git diff --check` y build web release completados. Pruebas automatizadas no ejecutadas; queda la prueba manual de volumen al usuario.
- Commits de dependencia, código y documentación pendientes hasta la petición del siguiente paso; progreso en P10.

## P08 — Movimientos y operación financiera — 2026-11-02
- Resultado: APPROVED bajo la autorización persistente del usuario.
- Adoptado `flutter_slidable 4.0.3` porque la última versión 5.2.0 no cabe en Flutter 3.44/Dart 3.12; filas agrupadas por fecha y acciones de editar/duplicar/eliminar con el menú alternativo visible.
- Corregido el estado vacío del historial y conservada una sola fuente de datos: el stream de Drift alimenta tanto lista como Home. Errores de persistencia muestran causa de dominio; fecha editada en una creación nueva protege el borrador; submit y confirmación de descarte están serializados.
- Sin cambio de esquema ni regla monetaria; el repositorio valida importes positivos y relaciones activas.
- `dart format`, `flutter analyze`, `git diff --check` y `flutter build web --release` completados (Wasm dry run exitoso). Pruebas existentes de repo/flujo no se ejecutaron; quedan para la verificación del usuario.
- Commits de paquete, código y docs pendientes hasta la petición del siguiente paso; progreso en P09.

## P07 — Home Dashboard financiero — 2026-11-02
- Resultado: APPROVED bajo la autorización persistente del usuario.
- `fl_chart` 1.3.0 para comparar ingresos/gastos de seis meses, con descripción semántica; resumen y gráfica usan movimientos locales y una sola moneda (DOP).
- Estado de primera instalación ahora ofrece CTA a los dos formularios sin mostrar KPIs cero; reduce accesos secundarios y aclara que el balance es el neto del mes seleccionado.
- La falla de categorías ya no oculta el dashboard; permite reintentar nombres y mantiene los cálculos disponibles. Dashboard se deriva del stream reactivo de Drift para actualizar CRUD.
- `dart format`, `flutter analyze` y `git diff --check` completados. No se ejecutaron pruebas automáticas ni se inspeccionó captura visual porque el host de navegador no estuvo disponible; queda prueba manual del usuario.
- Commits P07 separados: `c8df2f4`, `97d5a0d`, `b692604`; progreso en P08.

## P06 — Feedback, confirmaciones y sheets — 2026-11-02
- Resultado: APPROVED bajo la autorización persistente del usuario.
- `toastification`, `adaptive_dialog` y `modal_bottom_sheet`; feedback de operaciones centralizado, confirmación segura y undo real al archivar una categoría.
- `flutter analyze` y formato completados. Prueba manual queda para el usuario; sin pruebas automatizadas ejecutadas.
- Commits `6126ed3`, `12e6af7`, `c8dd5cd`; progreso en P07.

## P05 — Motion, haptics y lenguaje nativo — 2026-11-02
- Resultado: APPROVED bajo la autorización persistente del usuario.
- `MonyMotion` aplica movimiento reducido; barra circular con movimiento corto; `animations` 3.0.0 provee Fade Through para importes de resumen solo al cambiar.
- Navegación móvil ahora ofrece foco visible, activación por teclado/tacto y estado seleccionado semántico.
- `dart format`, `flutter analyze` y `git diff --check` completados. Tests de motion añadidos, no ejecutados; el usuario hará la prueba.
- Se agrega `animations` 3.0.0. Sin haptics añadidos. Commits P05 `affa4f8`, `4e8d5f5`, `c51a714`; progreso en P06.

## P04 — App Shell, bottom nav y rutas — 2026-11-02
- Resultado: APPROVED bajo la autorización explícita del usuario para aprobar las fases implementadas.
- `StatefulShellRoute.indexedStack` con Inicio, Movimientos, Categorías y Métodos; `circle_nav_bar` compacto y NavigationRail ancho.
- Preservación de stack/filtros; rutas de detalle y edición cubren el shell; formulario con confirmación para descartar cambios. Acciones secundarias de Home agrupadas en menú compacto.
- Tests de routing y viewport añadidos; `dart format`, `flutter analyze` y `git diff --check` completados. No se ejecutaron pruebas de Flutter/browser/device para que el usuario pruebe.
- Se agrega `circle_nav_bar` 2.2.0; commits P04 `07b828c` y `437acd0`. El progreso queda en P05.

## P03 — Design System y temas — 2026-11-02
- Resultado: APPROVED bajo la autorización explícita del usuario para aprobar las fases implementadas.
- Añadidos tokens, tema claro/oscuro y semántica financiera; `flex_color_scheme` 8.4.0 genera el tema y subtemas Material. Eliminados wrappers genéricos que solo delegaban en controles nativos.
- Home integrado con balance, métricas y loading/error/empty compartidos; color lavanda añadido como predeterminado y opción de apariencia.
- `dart format` y `flutter analyze` completados. No se ejecutó `flutter test` ni render visual para que el usuario pruebe.
- Tres commits P03 separados por tema, controles compartidos y documentación. El progreso queda en P04.

## Aprobación P01 e inicio P02 — 2026-11-02
- El usuario pidió marcar P01 como aprobada y autorizó aprobar las fases que se ejecuten.
- P01 actualizada a APPROVED; se inició solo P02.
- No hay cambios de código.

## P02 — Arquitectura incremental — 2026-11-02
- Resultado: APPROVED bajo la autorización explícita del usuario para aprobar las fases ejecutadas.
- Diagrama de datos, ownership de state/DB, contratos de routing, Riverpod, errores, dinero y límites feature/data/domain documentados en `01-foundation/03_ARCHITECTURE.md`.
- AC-02-5 sustentado por demostración estática: el mismo StreamProvider sirve Home y Movimientos en el ProviderScope raíz; no existe shell de pestañas. No se ejecutó prueba dinámica.
- Sin cambios de código, dependencias ni esquema Drift.

## Aprobación de P00 — 2026-11-02
- El usuario confirmó que revisó el reporte y pidió marcar P00 como hecha.
- Estado P00 actualizado a APPROVED; por el protocolo se inició solamente P01.
- P01 en progreso; sin cambios de dependencias ni código.

## P01 — Curaduría de dependencias — 2026-11-02
- Resultado: PASS_PENDING_APPROVAL; se evaluaron 15 candidatos con estado, constraints, plataformas, licencia, dependencias directas, actividad y riesgo en `00-governance/02_DEPENDENCIES.md`.
- ADR-0001 propone conservar go_router 18.1.2. Dos candidatos se rechazaron por requerir Flutter >=3.47/Dart ^3.13; alternativas sin caso actual quedan diferidas a fases funcionales.
- Sin cambios de código, paquetes, builds ni datos.
- No se hicieron spikes; tamaños exactos y accesibilidad quedan sin verificar hasta una necesidad concreta.

## P00 — Auditoría y baseline — 2026-11-02
- Resultado: PASS_PENDING_APPROVAL; reporte en `AUDIT_REPORT.md`.
- Inventario de las cuatro áreas, navegación, estado, Drift v9, SDK, targets, dependencias y riesgos.
- `flutter analyze`: sin issues. 168 pruebas pasan en copia temporal; en checkout original Flutter no pudo borrar el DLL SQLite generado/bloqueado.
- Sin cambios en código, dependencias o datos.

## Plan inicial — 2026-11-02
- Documentación del roadmap premium creada fuera del código de Mony.
- No hay cambios ejecutados en el repositorio Flutter.
- Registrar futuras fases aquí en orden cronológico con archivos y tests.
