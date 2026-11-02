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
