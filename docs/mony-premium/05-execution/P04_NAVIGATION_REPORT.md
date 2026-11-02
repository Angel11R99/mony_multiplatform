# P04 — App Shell, bottom nav y rutas

**Fecha:** 2026-11-02  
**Base:** P03 aprobado; commits `b3f6099`, `c125c81`, `41e7ab7`, `c17b159`  
**Estado:** APPROVED bajo la autorización explícita del usuario para aprobar fases implementadas.  
**Siguiente fase:** P05, todavía sin iniciar.

## Entrega

- `StatefulShellRoute.indexedStack` mantiene cuatro historiales independientes: Inicio (`/`), Movimientos (`/transactions`), Categorías (`/categories`) y Métodos (`/payment-methods`). Se conservaron nombres de ruta para los destinos y rutas existentes.
- `MonyNavigationShell` usa `circle_nav_bar` 2.2.0 en móvil y `NavigationRail` del SDK desde 840 dp. Se conserva `StatefulShellRoute`/go_router para URL, ramas y deep links.
- La integración añade controles semánticos con nombre y estado seleccionado, porque el paquete dibuja la barra con `CustomPainter` y gestos sin exponer por sí solo semántica completa de selección.
- Cambiar de destino conserva widgets, scroll y filtros. Tocar el destino activo no resetea su ruta ni su estado.
- Los detalles y el formulario de movimientos se presentan en el navegador raíz por encima del shell, evitando barras duplicadas. Al volver se conserva la pestaña.
- El formulario de movimiento advierte antes de descartar cambios; permite seguir editando o descartarlos.
- Home concentra los ocho accesos secundarios en un menú accesible para evitar desbordar la AppBar en ventanas compactas. Las rutas de categorías y métodos siguen accesibles por el shell.

## Criterios de aceptación

| Criterio | Resultado | Evidencia |
|---|---|---|
| AC-04-1 | Cubierto en rutas | `/` abre Home directamente; prueba de arranque escrita. |
| AC-04-2 | Cubierto en rutas | Los cuatro destinos completos y los nombres previos siguen accesibles; tests escritos. |
| AC-04-3 | Cubierto en implementación | `StatefulShellRoute.indexedStack`, selección activa no-op y formulario con confirmación de descarte. |
| AC-04-4 | Implementado; validación de plataforma pendiente | Prueba escrita para destino por URL, pop a shell y deep link frío. Back/forward/refresh del navegador y back nativo se dejan a validación manual. |
| AC-04-5 | Cobertura preparada | Pruebas escritas a 320×800 y 1200×900 dp, sin barras duplicadas en ruta de detalle. No ejecutadas. |

## Verificación y límites

- `dart format`, `flutter analyze` y `git diff --check` ejecutados; análisis sin problemas.
- Se añadió `test/core/routing/app_navigation_test.dart` con cobertura de inicio, destinos, estado del filtro, link frío, ancho compacto/escritorio, pop de ruta y cambios sin guardar.
- No se ejecutaron `flutter test`, pruebas en navegador ni pruebas en dispositivo. El usuario hará la prueba funcional/visual; esas salidas no se declaran como evidencia ejecutada.
- Se agrega `circle_nav_bar` 2.2.0, compatible con los targets declarados del proyecto. Pub.dev indica publicación hace 22 meses y uploader no verificado; se registra el riesgo de mantenimiento. Sin cambios de persistencia ni de esquema Drift.
- Se explicitó el origen de cada API en `02-experience/05_NAVIGATION.md` para distinguir widgets del SDK de dependencias pub.dev.
- P04 aprobado bajo autorización persistente del usuario. Sin commit todavía; se harán commits por categoría cuando el usuario pida avanzar a P05.

## Archivos principales

- `lib/core/routing/app_router.dart`
- `lib/core/routing/mony_navigation_shell.dart`
- `lib/features/home/presentation/home_page.dart`
- `lib/features/transactions/presentation/transaction_editor_page.dart`
- `test/core/routing/app_navigation_test.dart`
- `docs/mony-premium/05-execution/PROGRESS.md`
