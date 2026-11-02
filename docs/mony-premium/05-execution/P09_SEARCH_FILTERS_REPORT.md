# P09 — Búsqueda y filtros combinados

**Estado:** APPROVED por autorización persistente del usuario.  
**Fecha:** 2026-11-02.  
**Fase siguiente:** P10 — fechas, locale y hora.

## Entrega
- Consulta Drift reactiva sobre descripción, categoría y método de pago.
- Debounce de texto de 300 ms con `stream_transform 2.1.2`.
- Filtros por tipo, categorías múltiples, métodos múltiples, importes mínimo/máximo, fechas inclusivas y orden por fecha/importe.
- Chips eliminables, contador, estado vacío, botón de reset completo y retry del stream.
- Las búsquedas escapan `%`, `_` y `\\`; Drift enlaza valores como parámetros y composición de filtros aplica AND entre facetas, OR dentro de búsqueda/selecciones.

## Criterios y comprobación
- AC-09-1 a AC-09-4 implementados y descritos en `03-features/10_SEARCH_FILTERS.md`.
- AC-09-5 requiere que el usuario pruebe una lista con volumen representativo; pruebas automatizadas no se ejecutaron ni añadieron.
- `dart format`: correcto.
- `flutter analyze`: sin issues.
- `git diff --check`: correcto (Git avisó sobre la conversión de finales de línea CRLF, sin errores de diff).
- `flutter build web --release`: correcto; compilación completada en 53.7 s y wasm dry run exitoso.

## Decisiones y límites
- Solo hay moneda DOP en el modelo; no corresponde agregar filtro de divisa.
- Se reutilizan los índices existentes; no se cambia el esquema sin profiling.
- `LIKE` de SQLite preserva caracteres acentuados exactos, pero el plegado de mayúsculas base no cubre todas las letras acentuadas en todos los targets.
- Reversión: revertir commits de P09 por separado (dependencia, código y docs); no hay migración de base de datos.
