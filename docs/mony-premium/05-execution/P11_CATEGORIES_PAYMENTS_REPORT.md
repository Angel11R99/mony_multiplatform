# P11 — Categorías, métodos e integridad referencial

**Estado:** APPROVED bajo la autorización persistente del usuario.  
**Fecha:** 2026-11-02.  
**Fase siguiente:** P12 — fórmulas estadísticas y gráficos.

## Entrega
- Las operaciones de categorías validan nombre/vacío/límite/duplicados también dentro del repositorio y transacción. Edición de un ID inexistente da error; no se puede archivar la última categoría de ingreso activa.
- Métodos de pago hacen validación equivalente contra datos actuales en repositorio; actualizaciones inexistentes dan error. El nombre rechaza cadenas con 12 o más dígitos y referencias a CVV/CVC/PIN/credenciales.
- No hay campos para PAN, CVV, PIN ni credenciales bancarias. La vista de método usa solo nombre, icono/color, activo/predeterminado.
- Archivar conserva claves y relaciones históricas; mensajes muestran que las operaciones existentes se mantienen y el elemento se excluye de nuevos movimientos.
- Los selectores de icono/color se conservan en Material, con tooltips, estado seleccionado semántico, etiqueta accesible por color, targets táctiles de 48 px y formularios desplazables.

## Criterios y comprobación
- AC-11-1 a AC-11-5 implementados y descritos en `03-features/12_CATEGORIES_PAYMENTS.md`.
- Hay pruebas existentes de repositorios/validadores de ambas features; no se añadieron ni ejecutaron pruebas automatizadas por el flujo acordado.
- `dart format`: correcto.
- `flutter analyze`: sin issues.
- `git diff --check`: correcto (avisos de normalización CRLF de Git, sin error).
- `flutter build web --release`: correcto; wasm dry run exitoso.
- Verificación manual de archivado/restauración, formularios y escala de texto queda para el usuario.

## Dependencias y esquema
- Sin cambio de esquema: `Transactions.categoryId` y `paymentMethodId` ya tienen claves foráneas `ON DELETE RESTRICT`; no hay operación de borrado en la UI.
- Sin dependencias añadidas. `icon_picker 2.1.0` de pub.dev no soporta Dart 3; `flutter_iconpicker 4.0.3` añade dcli/provider/paquetes de iconos y fonts, requiere packs y advierte de codePoints/tree shaking. El catálogo curado actual tiene 28 iconos y claves persistidas estables.
