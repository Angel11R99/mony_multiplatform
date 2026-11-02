# P06 — Feedback, confirmaciones y overlays

**Estado:** APPROVED por autorización persistente del usuario, 2026-11-02.  
**Rama base:** estado posterior a P05.  
**Criterio permanente:** comprobar pub.dev y preferir paquete compatible antes de implementar capacidad propia.

## Implementación

- `toastification 3.2.2`: envoltorio global con cola/límite y APIs tipadas de éxito, información, advertencia y error; actualizados los avisos de formularios y operaciones.
- `adaptive_dialog 2.8.3`: confirmaciones estándar, cancelación por defecto y tono destructivo. Formularios y el diálogo con comparación de tickets mantienen contenido Material específico.
- `modal_bottom_sheet 3.0.0`: historiales scrollables de presupuesto y aportes, con controlador coordinado de scroll y SafeArea.
- Deshacer solo se ofrece al archivar una categoría, operación que el repositorio permite revertir. Los borrados irreversibles no muestran acción ficticia.
- Localizaciones delegadas para español añadidas a `MaterialApp.router`.
- Evaluación y estados de dependencia registrados en `00-governance/02_DEPENDENCIES.md`; especificación funcional actualizada en `02-experience/07_FEEDBACK_OVERLAYS.md`.

## Criterios de aceptación

| Criterio | Resultado |
|---|---|
| AC-06-1: variantes de feedback y undo | APIs para las cuatro variantes; undo de archivo de categoría. No se añadieron pruebas automatizadas de widgets. |
| AC-06-2: confirmación segura | Migradas las confirmaciones simples; cancelar es el resultado por defecto; acción destructiva rotulada. |
| AC-06-3: scroll, teclado y SafeArea | Los dos historiales usan controlador scrollable y SafeArea del paquete; formularios conservaron sus diálogos con campos. |
| AC-06-4: reconstrucción sin duplicados | Feedback solo se emite desde handlers/resultado de acción, nunca desde `build`. El wrapper limita cola; no hace dedupe de eventos idénticos. |

## Verificación y límites

- `dart format` en archivos modificados: PASS.
- `flutter analyze`: PASS (`No issues found`).
- `flutter test`: no ejecutado en esta fase. La inspección visual/teclado en plataforma real queda para prueba del usuario.
- Los paquetes declaran plataformas actuales del proyecto. `adaptive_dialog` incorpora `flutter_localizations` y registrantes transitivos para plataformas desktop; los builds nativos deberán cubrirse en CI.
- Riesgo: `modal_bottom_sheet 3.0.0` tiene mantenimiento/publicación menos reciente que los otros candidatos. Alcance limitado a dos historiales para obtener su coordinación scroll/drag y SafeArea.

## Commits previstos

Separar cambios por categoría: integración de paquetes, estandarización del feedback, confirmaciones seguras y documentación de P06. Commits a crear al iniciar la siguiente fase, de acuerdo con la instrucción del usuario.
