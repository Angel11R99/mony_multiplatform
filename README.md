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
