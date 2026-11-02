# P10 — Calendario, rangos y reloj

**Estado:** APPROVED bajo la autorización persistente del usuario.  
**Fecha:** 2026-11-02.  
**Fase siguiente:** P11 — integridad referencial de categorías y métodos.

## Entrega
- Se añadió `table_calendar 3.2.1` para una grilla mensual adaptativa con marcadores basados en movimientos reales; el usuario puede abrir la actividad de un día, ver conteo/estado vacío y aplicar ese día como filtro.
- Se añadieron presets de fechas Hoy, Semana, Mes, Año y Personalizado. Semana respeta `firstDayOfWeekIndex` del locale. Todos los extremos se interpretan inclusivamente sobre fechas civiles almacenadas como `dateEpochDay`.
- `MonyDateFormatter` centraliza formato de fecha/mes y ofrece salida horaria de 12/24 h. Se inicializan símbolos `intl` antes de `runApp`; `MaterialApp` soporta `es` y `en`.
- Se sustituyeron formatos numéricos manuales duplicados de fechas en movimientos, Home, estadísticas, obligaciones, ahorro, compras, recibos y recordatorios.

## Criterios y comprobación
- AC-10-1 a AC-10-5 implementados y registrados en `03-features/11_CALENDAR_TIME.md`.
- `dart format`: correcto.
- `flutter analyze`: sin issues.
- `git diff --check`: correcto (solo avisos de normalización CRLF de Git).
- `flutter build web --release`: correcto; compilación terminada en 57.7 s y wasm dry run exitoso.
- No se añadieron ni ejecutaron pruebas automatizadas. Queda verificación manual visual/táctil del calendario y de selección de rango por el usuario.

## Decisiones y límites
- `table_calendar 3.2.1` usa `intl ^0.20.0`; resuelve con intl 0.20.2 del SDK. Latest 3.3.0 requiere intl >=0.20.3, incompatible. No se usaron overrides.
- La entidad financiera representa fechas civiles sin hora; no se convierte el día a UTC como timestamp ni se agregó selector horario. `dateToEpochDay` codifica los componentes civiles.
- No cambia el esquema Drift ni las zonas horarias de las notificaciones existentes.
- Reversión: retirar dependencia y módulo de formato/calendario con commits P10 separados, sin migración de datos.
