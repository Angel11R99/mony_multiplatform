# Mony Multiplatform

Aplicación Flutter de finanzas personales para Android e iOS, diseñada para funcionar offline-first.

## Ejecutar

```sh
flutter pub get
flutter run --dart-define=APP_ENV=development
```

Entornos disponibles: `development`, `staging` y `production`. El valor se configura con `--dart-define=APP_ENV=...`; si no se indica o es desconocido, se usa `development`.

## Estructura

- `lib/app`: composición de la aplicación y proveedores de Riverpod.
- `lib/core`: configuración, logging y navegación compartidos.
- `lib/features`: módulos organizados por funcionalidad; cada módulo añade capas `presentation`, `domain` y `data` cuando las necesite.
- `test`: pruebas unitarias y de widgets.

Riverpod administra la composición de dependencias y GoRouter las rutas declarativas. La captura global de errores evita registrar el contenido de excepciones; el logger emite identificadores de evento y tipos de error.

## CI

GitHub Actions ejecuta análisis estático y pruebas de Flutter en Ubuntu y macOS, además de generar un APK de Android y una build de simulador iOS.

## Roadmap

El alcance de los módulos está en [`docs/MONY_FLUTTER_ROADMAP.md`](docs/MONY_FLUTTER_ROADMAP.md).

## Apariencia y preferencias

Desde el botón de ajustes en Inicio puedes elegir tema del sistema, claro u oscuro; cambiar los colores principal y secundario con la paleta o el selector HSV; y elegir si DOP se muestra como `RD$` o `DOP`. Los ajustes se guardan localmente. Los importes se formatean desde unidades menores enteras y usan el locale dominicano.

## Categorías

Las categorías se guardan localmente en SQLite mediante Drift. La primera apertura crea el catálogo inicial de 21 categorías de Mony. Se pueden crear, editar, archivar y restaurar categorías, con icono, color y límite de presupuesto opcional. Las categorías archivadas mantienen su ID para que los movimientos históricos puedan seguir apuntando a ellas; los selectores de movimientos solo ofrecen categorías activas. Los nombres se validan sin distinguir mayúsculas y se impide archivar la última categoría de ingresos activa.

La versión web necesita `web/sqlite3.wasm` y `web/drift_worker.js`, incluidos en el proyecto y servidos junto con la app Flutter.

## Métodos de pago

El catálogo local inicia con efectivo, débito y crédito. Se pueden crear, editar, archivar y restaurar métodos, personalizar sus iconos y colores, y escoger el predeterminado. Siempre hay un método activo y un predeterminado activo; al archivar el predeterminado, se asigna otro automáticamente. El archivado conserva el ID para referencias futuras. Las bases de categorías v1 se actualizan a v2 mediante una migración probada que preserva sus datos.

## Ingresos y gastos

En Movimientos puedes registrar ingresos y gastos con importe en centavos exactos, fecha calendario, categoría activa, método de pago y nota opcional. Las filas se ordenan por fecha y hora de creación; se pueden editar, duplicar (con fecha de hoy) y eliminar. Las referencias a categorías y métodos se conservan por ID, por lo que archivar un elemento mantiene legible el historial. Las bases v2 se migran a v3 sin alterar los catálogos. Los resúmenes financieros y filtros se completarán en sus módulos correspondientes.

## Historial, búsqueda y filtros

El historial muestra movimientos en páginas de 20 y permite cargar más resultados. La búsqueda encuentra texto de la nota o de la categoría; se pueden combinar tipo, categoría (incluidas las archivadas), rango de fechas y orden por fecha o importe. Cada fila abre el detalle del movimiento, desde donde también se edita, duplica o elimina. Los filtros se aplican a los movimientos locales y se actualizan al cambiar los datos.

## Dashboard financiero

Inicio muestra el resumen del mes seleccionado: ingresos, gastos y balance neto calculados en centavos, junto con los cinco movimientos más recientes. Puedes recorrer los meses y abrir el detalle de cada movimiento. Los accesos rápidos inician directamente el formulario de ingreso o gasto; los importes respetan el formato de moneda configurado. El resumen se deriva del stream local de movimientos y se actualiza al crear, editar o eliminar.

## Metas de ahorro

Metas de ahorro permite crear, editar, completar, reabrir y eliminar objetivos, consultar sus aportes y seguir el saldo frente al objetivo. Cada aporte se guarda una sola vez como gasto en la categoría activa **Ahorro** y queda vinculado a la meta; su progreso se calcula desde esos movimientos. Al eliminar una meta, los gastos permanecen en el historial y se desvinculan. La base v3 migra a v4 conservando los movimientos existentes.
