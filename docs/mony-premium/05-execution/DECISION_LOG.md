# Registro de decisiones técnicas (ADR)

Crear ADR por decisión significativa, numeradas `ADR-0001`, `ADR-0002`... con: Contexto, Opciones, Decisión, Justificación, Plataformas, Alternativas descartadas, Riesgos, Validación, Fecha, Fase y Reversibilidad.

## Decisiones registradas
- ADR-0001 — conservar go_router 18.1.2: ver ADR-0001 en `02_DEPENDENCIES.md` (documentado en P01).
- ADR-0002 — conservar límites feature/Riverpod/Drift y hacer cambios incrementales: ver contratos y evidencia P02 en `01-foundation/03_ARCHITECTURE.md`.
- ADR-0003 — tema y widgets compartidos Mony, definidos en esta fase y documentados en `P03_DESIGN_SYSTEM_REPORT.md`.
- ADR-0004 — shell responsive con ramas indexadas go_router, descrito en `P04_NAVIGATION_REPORT.md`.

### ADR-0002 — Conservar arquitectura feature-based con Riverpod y Drift

- **Contexto:** app existente con `ProviderScope` raíz, GoRouter, Riverpod 3, contratos y modelos por feature, repositorios Drift y schemaVersion 9.
- **Opciones:** conservar este diseño y documentar límites; mover providers/repositorios en bloque a capas nuevas; reemplazar el estado o la persistencia.
- **Decisión:** conservar estructura y paquetes actuales. Aplicar en features nuevas separación `presentation → domain ← data`; providers actuales son el seam de composición, exponen contratos tipados y usan las implementaciones Drift. Sin gestor de estado paralelo, service locator, DTO de SQLite ni migración por trabajo visual.
- **Justificación:** el flujo actual comparte streams reactivos y permite derivar Home/Statistics del mismo origen; una reubicación amplia no es necesaria para clarificar ownership y añade riesgo al código/BD existente.
- **Plataformas:** targets del proyecto Android, iOS, Web, Linux, macOS y Windows; Web ya declara WASM/worker de Drift. La arquitectura mantiene almacenamiento actual por target.
- **Alternativas descartadas:** Clean Architecture estricta con carpetas/use-cases para cada operación sin regla de negocio adicional; nuevo gestor de estado o wrapper Result/Either; acceso SQL desde widgets.
- **Riesgos:** wiring de dependencias sigue ubicado en archivos providers bajo `presentation`; navegación aún sin shell persistente; compatibilidad por plataforma y back/deep links se verifican en P04/P15.
- **Validación:** lectura estática de `main.dart`, composición de `MonyApp`, `appDatabaseProvider`, router, providers/repositorios/modelos de movimientos/categorías/métodos, estadísticas y formato monetario. Se documentó AC-02-5 por instancia compartida de `transactionsProvider`; no se ejecutó prueba dinámica en P02.
- **Fecha/Fase/Reversibilidad:** 2026-11-02, P02; alta reversibilidad porque solo se añadió contrato documental, sin editar Dart ni datos.

## Decisiones pendientes
- Gestor de estado existente vs alternativa (por defecto conservar).
- Gráficos fl_chart vs existente.
- Paquete de toast vs ScaffoldMessenger.
- Material/Cupertino adaptativos.
- Estrategia monetaria multi-divisa.
- Calendario especializado vs nativo.
- Política de borrado de categorías y métodos referenciados.

No transformar una sugerencia en decisión aprobada sin evidencias y aprobación en la fase relevante.
