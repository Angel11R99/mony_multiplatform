# P11 — Categorías y métodos de pago

## Categorías
Listar, crear, editar, archivar/eliminar según reglas actuales; distinguir ingreso/gasto si esquema lo admite; icono/color semántico seleccionable con límites de paleta; evitar categorías duplicadas según reglas existentes. Definir comportamiento cuando hay movimientos asociados antes de permitir eliminar: bloquear, archivar o reasignar **solo según modelo y aprobación**.

## Métodos
Tipos existentes (efectivo, tarjeta, cuenta u otros) sin asumir campos inexistentes. Crear/editar/ocultar de forma segura, descripción corta, saldo asociado solo si hay fuente fiable. No solicitar ni almacenar PAN, CVV, credenciales bancarias ni datos innecesarios. Iconografía neutra y coherente.

## Componentes
Picker de iconos buscable si el catálogo lo justifica, selector de color accesible, formulario con validación inline, estados vacíos, botones claramente etiquetados, confirmaciones que expliquen impacto sobre transacciones.

## Aceptación
- [x] AC-11-1: CRUD existente preservado; validaciones duplicadas se aplican también en repositorios. Pruebas existentes de CRUD/validator no se ejecutaron.
- [x] AC-11-2: movimientos mantienen claves foráneas restrictivas; archivar conserva IDs y referencias, borrar directamente no está expuesto.
- [x] AC-11-3: no hay campos para PAN/CVV/credenciales; el nombre del método rechaza cadenas con 12+ dígitos o términos sensibles desde UI y repositorio.
- [x] AC-11-4: tipo se identifica con selector/etiquetas e iconografía además del color; tonos incluyen nombres accesibles y check de selección.
- [x] AC-11-5: formularios están en scroll, inputs tienen labels/límites, iconos y colores son enfocables y semánticamente anunciados.

## Decisiones P11
- El esquema existente ya tiene `ON DELETE RESTRICT` para ambos vínculos, y las operaciones de gestión usan archivar/restaurar, no borrar/reasignar historiales.
- Los repositorios vuelven a validar nombres/duplicados para no confiar en la pantalla; el último tipo disponible se verifica dentro de transacción.
- Archivar comunica que las operaciones existentes se conservan y que el elemento no estará en nuevos movimientos.
- Los nombres de método no pueden contener 12 o más dígitos ni palabras de PAN/CVV/PIN/credenciales. El modelo no almacena números ni información bancaria.
- Se conserva el catálogo curado de iconos Material. `icon_picker 2.1.0` no soporta Dart 3; `flutter_iconpicker 4.0.3` agrega fuentes/dependencias y sus propias advertencias de codepoints/tree shaking. El catálogo actual de 28 opciones no requiere ese paquete.
- Sin cambios de esquema ni dependencias. No se agregaron ni ejecutaron pruebas automatizadas; se mantienen las existentes para revisión del usuario.
