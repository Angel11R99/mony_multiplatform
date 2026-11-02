# P04 — App Shell, bottom nav y rutas

## Modelo de navegación
Arranque directo a **Inicio**. Destinos persistentes: **Inicio, Movimientos, Categorías, Métodos**; Analytics puede residir como ruta de detalle de Inicio hasta decisión de producto. No usar pantalla de acceso a módulos como inicio.

## Comportamiento
- En móvil: `circle_nav_bar` con 4 destinos y selección clara; acción `+` flotante **solo si** existe flujo de creación apropiado (no añadir quinto tab sin aprobación).
- Desktop/tablet ancho: `NavigationRail` o sidebar; UI central reutilizada y ruta URL consistente.
- Si ya existe go_router: preferir `StatefulShellRoute.indexedStack`; si no, comparar estrategia mínima que preserve back stack por tab.
- **Origen de implementación:** la barra móvil usa [`circle_nav_bar`](https://pub.dev/packages/circle_nav_bar) 2.2.0, elegido por el usuario. Se mantiene `NavigationRail` del SDK Flutter para escritorio y [`go_router`](https://pub.dev/packages/go_router) para rutas y estado de ramas. La integración debe exponer labels y estado seleccionado a tecnologías de asistencia porque el paquete no los aporta de forma completa.
- Preservar scroll, filtro y estado efímero sensato; formularios con cambios no guardados deben advertir o preservar borrador.
- Tap en destino activo: comportamiento documentado (por ejemplo scroll-to-top, sin recargar).
- Navegador web: URL por destino, back/forward y refresh deep link; rutas anidadas para detalles.
- Modal y navegación no pueden dejar shell duplicado ni barras superpuestas.

## Matriz de pruebas
Arranque, cambio 1→2→1, cambio de ruta secundaria, back Android, web back/forward/refresh, ventana 320px y ancho escritorio, teclado, pantalla con datos y vacía.

## Aceptación
- [x] AC-04-1: aplicación abre en Inicio sin menú intermedio.
- [x] AC-04-2: 4 módulos completos accesibles sin perder funciones.
- [x] AC-04-3: shell persistente, estado y scroll según contrato.
- [x] AC-04-4: rutas/back implementados; back del SO y browser history requieren validación en dispositivo/navegador.
- [x] AC-04-5: barra adaptativa y pruebas compacta/ancha escritas; ejecución visual pendiente.

## Contrato implementado
- Reselect del destino activo: no-op; conserva ruta, filtros y scroll.
- Android/iOS back: primero cierra overlays o vuelve desde rutas del navegador raíz; después usa el back stack de la rama seleccionada; en Home raíz sigue el comportamiento del sistema.
- Web: `/`, `/transactions`, `/categories` y `/payment-methods` son ubicaciones directas. GoRouter sincroniza branch changes con la URL; historial/back/forward/refresh debe validarse en navegador real.
- Detalle/edición de movimiento cubre el shell en el Navigator raíz; `PopScope` pregunta si hay borrador con cambios.
- Umbral responsive: `MonyBreakpoints.expanded` (840 dp); abajo usa `NavigationBar`, desde ahí `NavigationRail`.
- Referencias: [Flutter `NavigationBar`](https://api.flutter.dev/flutter/material/NavigationBar-class.html), [Flutter `NavigationRail`](https://api.flutter.dev/flutter/material/NavigationRail-class.html), [paquete `go_router`](https://pub.dev/packages/go_router).
