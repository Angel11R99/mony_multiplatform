# P00 — Auditoría y baseline

**Resultado:** diagnóstico verificable; no realizar refactor ni instalar dependencias en esta fase.

## Alcance de inspección
- `pubspec.yaml`, `pubspec.lock`, Flutter/Dart SDK, SDK constraints; target platforms generadas.
- Estructura `lib/`, entrypoint, routers, navegación actual, gestión de estado, tema, localización, widgets reutilizables.
- Drift: tablas, DAO, migraciones, inicialización y estrategia de backup. No abrir datos privados del usuario para muestras públicas.
- Home actual, Movimientos, Categorías, Métodos: rutas, pantallas, repositorios y test existentes.
- Assets, fuentes, accesibilidad, test/widget/integration/golden, CI y políticas de lint.
- Skills `dart-flutter-patterns`, `designing-flutter-architecture`, `flutter-drift`, `flutter-navigation`, `flutter-state-management`, `flutter-testing`, `flutter-ui-design`: verificar rutas reales de instalación y leer instrucciones.

## Salidas
1. `docs/mony-premium/05-execution/AUDIT_REPORT.md`: mapa de navegación, estado de las 4 features, compatibilidad por plataforma, riesgos y deuda técnica priorizada.
2. Lista de paquetes actuales, duplicados y incompatibilidades verificadas.
3. Captura o descripción concreta del flujo actual y baseline visual (si el runner lo permite).
4. Resultados **reales** de `flutter --version`, `dart --version`, `flutter analyze`, `flutter test` y targets que puedan compilarse; no asumir que todos los SDKs están instalados.
5. Métricas opcionales: build time, advertencias, tests existentes, tamaño de bundle si está disponible.

## Criterios de aceptación
- [ ] AC-00-1: 4 módulos ubicados con rutas/archivos reales o ausencia documentada.
- [ ] AC-00-2: fuente de verdad de estado y BD identificada, sin cambiar datos.
- [ ] AC-00-3: SDK y soporte multiplataforma reportados según evidencia.
- [ ] AC-00-4: resultados de herramientas con salida, error o limitación reproducible.
- [ ] AC-00-5: riesgos y bloqueos clasificados en alto/medio/bajo.

**Prohibido:** reescribir navegación, crear tablas, instalar 20 paquetes por anticipado.
