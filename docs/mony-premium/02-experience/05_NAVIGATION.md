# P04 — App Shell, bottom nav y rutas

## Modelo de navegación
Arranque directo a **Inicio**. Destinos persistentes: **Inicio, Movimientos, Categorías, Métodos**; Analytics puede residir como ruta de detalle de Inicio hasta decisión de producto. No usar pantalla de acceso a módulos como inicio.

## Comportamiento
- En móvil: `NavigationBar` Material 3 con 4 destinos y selección clara; acción `+` flotante **solo si** existe flujo de creación apropiado (no añadir quinto tab sin aprobación).
- Desktop/tablet ancho: `NavigationRail` o sidebar; UI central reutilizada y ruta URL consistente.
- Si ya existe go_router: preferir `StatefulShellRoute.indexedStack`; si no, comparar estrategia mínima que preserve back stack por tab.
- Preservar scroll, filtro y estado efímero sensato; formularios con cambios no guardados deben advertir o preservar borrador.
- Tap en destino activo: comportamiento documentado (por ejemplo scroll-to-top, sin recargar).
- Navegador web: URL por destino, back/forward y refresh deep link; rutas anidadas para detalles.
- Modal y navegación no pueden dejar shell duplicado ni barras superpuestas.

## Matriz de pruebas
Arranque, cambio 1→2→1, cambio de ruta secundaria, back Android, web back/forward/refresh, ventana 320px y ancho escritorio, teclado, pantalla con datos y vacía.

## Aceptación
- [ ] AC-04-1: aplicación abre en Inicio sin menú intermedio.
- [ ] AC-04-2: 4 módulos completos accesibles sin perder funciones.
- [ ] AC-04-3: shell persistente, estado y scroll según contrato.
- [ ] AC-04-4: back y deep links correctos o limitaciones declaradas.
- [ ] AC-04-5: sin overflows ni duplicados de navbar.
