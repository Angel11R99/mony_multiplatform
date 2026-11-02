# P06 — Toasts, modales, diálogos, popups

## API de experiencia unificada
`MonyFeedback` centraliza `success`, `info`, `warning`, `error` y `undo` sobre `toastification`. `ToastificationWrapper` fija alineación inferior, animación breve que respeta movimiento reducido, máximo de 3 avisos simultáneos y textos truncados con límite. Los avisos se emiten desde handlers de eventos/resultado, no desde `build`; por eso reconstruir una vista no vuelve a emitir el mismo aviso. La cola limita acumulación; no promete deduplicar eventos idénticos.

## Componentes
- Snackbars/toasts con descripción breve, contraste y `Semantics` live region donde aplique.
- Confirmación destructiva con `adaptive_dialog`, cancelar por defecto y etiqueta de acción específica; los borrados indican el objeto cuando está disponible.
- Bottom sheet: historiales scrollables de presupuesto y aportes usan `modal_bottom_sheet`, `ModalScrollController`, duración con movimiento reducido, drag handle y padding SafeArea. Formularios con teclado mantienen su layout Material.
- Dialog: title, message, primary/secondary, loading/disabled durante acción, errores recuperables; Escape/click outside solo cuando seguro.
- Popup menu, selección y contexto adaptativos con cierre accesible y foco restaurado.
- Undo solo si rollback real y temporal; no prometer undo cuando el backend o Drift no lo soporta.

## Errores típicos a evitar
Notificación duplicada por reconstrucción, overlay sobre otro overlay, botón guardar doble, modal recortado por teclado, diálogo imposible de cerrar con teclado.

## Aceptación
- [x] AC-06-1: variantes éxito/error/advertencia/info y undo implementadas en `MonyFeedback`; feedback se dispara desde handlers. Prueba manual de plataforma pendiente; no se ejecutaron pruebas de widgets.
- [x] AC-06-2: confirmaciones destructivas estandarizadas, con cancelar por defecto y estilo destructivo; formularios de edición y diálogo de ticket duplicado conservan contenido Material específico.
- [x] AC-06-3: historiales con scroll coordinado y SafeArea; formularios con teclado no se migraron. Falta verificación manual en dispositivos.
- [x] AC-06-4: ningún feedback se dispara desde `build`; el wrapper controla cantidad/cola. No se anuncia deduplicación de mensajes iguales.

## Decisión de paquetes y límites

- `toastification 3.2.2` cubre toasts y cola. `MonyFeedback` solo conserva integración de marca, textos españoles, semántica de deshacer, tipos y duración.
- `adaptive_dialog 2.8.3` cubre confirmaciones estándar y su navegación de teclado; formularios complejos necesitan composición de widgets Material.
- `modal_bottom_sheet 3.0.0` se usa solo en dos historiales donde scroll/drag coordinado aporta valor. No se sustituyen los sheets de formularios sin verificar foco y teclado.
- Archivar categorías se puede revertir en cinco segundos; eliminar movimientos/listas/abonos y restaurar backup requieren confirmar y no muestran un undo ficticio.
- Se añadieron delegados de localización españoles para Cupertino/Material. `flutter analyze` pasa. No se ejecutaron pruebas automatizadas ni pruebas manuales en dispositivo.
