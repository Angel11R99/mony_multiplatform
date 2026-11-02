# P03 — Design System y temas

**Fecha:** 2026-11-02  
**Base:** rama `main`, P02 aprobada  
**Estado:** APPROVED por autorización explícita del usuario de aprobar las fases implementadas.  
**Siguiente fase:** P04, reabierta para cambiar la barra móvil por `circle_nav_bar`.

## Entrega

- `MonyTheme` conserva modo claro, oscuro y sistema; `flex_color_scheme` 8.4.0 construye el `ThemeData` y sus subtemas Material. Paleta, tokens Mony y colores financieros siguen propios del producto.
- `MonyFinanceColors` expone colores semánticos de ingresos, gastos y avisos mediante `ThemeExtension`.
- `MonySpace`, `MonyRadius`, `MonyMotion`, `MonyBreakpoints` y `MonyPalette` centralizan ritmo, formas, movimiento, anchos y paleta.
- Se eliminaron `MonyScaffold` y los wrappers genéricos de botones, iconos, búsqueda, chips e iconos semánticos. Se usan `Scaffold`/`SafeArea` y controles Material directamente; se mantienen los widgets Mony con presentación financiera o estructura compartida.
- Home ya usa los componentes compartidos para estructura, balance, ingresos/gastos, encabezados y estados asíncronos. No se alteró persistencia, esquema Drift ni rutas.
- Se añadió la opción lavanda al selector de apariencia, conservando los colores personalizados que ya tengan guardados los usuarios.

## Criterios de aceptación

| Criterio | Resultado | Evidencia |
|---|---|---|
| AC-03-1 | Cubierto en implementación | `MonyTheme.themeMode` sigue resolviendo sistema/claro/oscuro; tests escritos. |
| AC-03-2 | Cubierto en módulos nuevos | Colores, espacios, radios, breakpoints y duraciones vienen de tokens/ThemeData. |
| AC-03-3 | Cubierto | Tests de tema, semántica, estados y texto grande en `test/core/theme/mony_design_system_test.dart`. |
| AC-03-4 | Contrastes calculados | Combinaciones semánticas figuran abajo; controles tienen objetivo mínimo 48 dp en tema. |
| AC-03-5 | Cobertura preparada | Test de 360×800 dp y escala de texto 2.0 escrito. No se ejecutó; queda para la prueba del usuario. |

### Contraste WCAG calculado

La razón se calculó para los colores semánticos de texto sobre los fondos de pantalla respectivos. Todas superan 4.5:1 para texto normal.

| Par | Contraste |
|---|---:|
| Ingreso oscuro `#75D6AC` sobre `#151218` | 10.58:1 |
| Gasto oscuro `#F08D9B` sobre `#151218` | 7.94:1 |
| Aviso oscuro `#E9BB69` sobre `#151218` | 10.41:1 |
| Ingreso claro `#176B4A` sobre blanco | 6.48:1 |
| Gasto claro `#9E3345` sobre blanco | 6.97:1 |
| Aviso claro `#79520B` sobre blanco | 6.94:1 |

## Verificación y límites

- `dart format` aplicado a los archivos Dart modificados.
- `flutter analyze` pasó sin issues tras el refactor con FlexColorScheme 8.4.0.
- `git diff --check` pasó.
- No se ejecutaron pruebas automatizadas ni renderizado/capturas; los tests de widgets quedan para que el usuario haga la prueba solicitada. Por tanto, el test de escala y la revisión visual en dispositivos/plataformas no se reportan como ejecutados.
- Commit P03 creado antes de iniciar cambios de P04, según instrucción del usuario.
- La versión 9 de flex_color_scheme continúa incompatible con el SDK del proyecto; P03 usa 8.4.0, cuya resolución sí pasó.

## Archivos principales

- `lib/core/theme/mony_tokens.dart`
- `lib/core/theme/mony_finance_colors.dart`
- `lib/core/theme/mony_theme.dart`
- `lib/core/widgets/mony_*.dart`
- `lib/features/home/presentation/home_page.dart`
- `lib/features/preferences/domain/app_preferences.dart`
- `lib/features/preferences/presentation/settings_page.dart`
- `test/core/theme/mony_design_system_test.dart`
- `docs/mony-premium/05-execution/PROGRESS.md`
