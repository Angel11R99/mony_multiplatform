# P11 — Categorías y métodos de pago

## Categorías
Listar, crear, editar, archivar/eliminar según reglas actuales; distinguir ingreso/gasto si esquema lo admite; icono/color semántico seleccionable con límites de paleta; evitar categorías duplicadas según reglas existentes. Definir comportamiento cuando hay movimientos asociados antes de permitir eliminar: bloquear, archivar o reasignar **solo según modelo y aprobación**.

## Métodos
Tipos existentes (efectivo, tarjeta, cuenta u otros) sin asumir campos inexistentes. Crear/editar/ocultar de forma segura, descripción corta, saldo asociado solo si hay fuente fiable. No solicitar ni almacenar PAN, CVV, credenciales bancarias ni datos innecesarios. Iconografía neutra y coherente.

## Componentes
Picker de iconos buscable si el catálogo lo justifica, selector de color accesible, formulario con validación inline, estados vacíos, botones claramente etiquetados, confirmaciones que expliquen impacto sobre transacciones.

## Aceptación
- [ ] AC-11-1: CRUD existente preservado y cubierto por tests.
- [ ] AC-11-2: vínculos a transacciones no quedan huérfanos.
- [ ] AC-11-3: no almacenamiento de datos de tarjeta sensibles.
- [ ] AC-11-4: color nunca es el único indicador del tipo de categoría.
- [ ] AC-11-5: formularios responden bien al teclado y escala de texto.
