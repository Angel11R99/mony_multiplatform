# P06 — Toasts, modales, diálogos, popups

## API de experiencia unificada
FeedbackService o patrón actual: `success`, `info`, `warning`, `error`, `undo`; cola/dedupe; no spam. Overlays presentados en contexto correcto de navegación.

## Componentes
- Snackbars/toasts con descripción breve, contraste y `Semantics` live region donde aplique.
- Confirmación destructiva explícita con nombre de objeto y acción irreversible; cancelar por defecto.
- Bottom sheet: altura adaptable, scroll interno, drag handle cuando soporte dismiss, teclado visible, SafeArea; no perder datos al arrastrar.
- Dialog: title, message, primary/secondary, loading/disabled durante acción, errores recuperables; Escape/click outside solo cuando seguro.
- Popup menu, selección y contexto adaptativos con cierre accesible y foco restaurado.
- Undo solo si rollback real y temporal; no prometer undo cuando el backend o Drift no lo soporta.

## Errores típicos a evitar
Notificación duplicada por reconstrucción, overlay sobre otro overlay, botón guardar doble, modal recortado por teclado, diálogo imposible de cerrar con teclado.

## Aceptación
- [ ] AC-06-1: variantes éxito/error/advertencia/info/undo demo y tests.
- [ ] AC-06-2: confirmación evita eliminar por accidente.
- [ ] AC-06-3: sheets funcionan con teclado, scroll y SafeArea.
- [ ] AC-06-4: no se muestran avisos duplicados al reconstruir.
