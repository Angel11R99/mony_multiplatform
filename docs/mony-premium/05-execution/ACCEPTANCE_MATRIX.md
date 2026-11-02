# Matriz consolidada de aceptación

Esta matriz se enlaza a los criterios AC-xx-y de cada documento; **no marcar como aprobados desde la documentación sola**.

| Fase | Evidencia mínima | Estado inicial |
|---|---|---|
| P00 | Auditoría con árbol, SDK, módulos y baseline | APPROVED — `AUDIT_REPORT.md` |
| P01 | Matriz de paquetes, licencias y compatibilidad | APPROVED — `00-governance/02_DEPENDENCIES.md` |
| P02 | Contratos de arquitectura y consistencia de estado | APPROVED — `01-foundation/03_ARCHITECTURE.md` |
| P03 | Theme tokens y pruebas de componentes | APPROVED — `P03_DESIGN_SYSTEM_REPORT.md`; pruebas escritas pero no ejecutadas |
| P04 | 4 destinos con back/deep-link/estado probados | APPROVED — `P04_NAVIGATION_REPORT.md`; pruebas escritas, ejecución de navegador/dispositivo pendiente |
| P05 | Motion + reduced motion + navegación accesible | APPROVED — `P05_MOTION_REPORT.md` |
| P06 | Overlays, toasts, confirmaciones y pruebas | APPROVED — `P06_FEEDBACK_REPORT.md`; revisión manual pendiente del usuario |
| P07 | KPIs reales y empty/error states | APPROVED — `P07_HOME_REPORT.md`; revisión manual pendiente del usuario |
| P08 | CRUD y coherencia entre vistas | APPROVED — `P08_TRANSACTIONS_REPORT.md`; pruebas no ejecutadas |
| P09 | Filtros combinados y búsqueda estable | APPROVED — `P09_SEARCH_FILTERS_REPORT.md`; análisis y build web OK; validación manual de volumen queda para el usuario |
| P10 | Inclusión de fechas/locale/hora verificada | APPROVED — calendario `table_calendar` y fechas civiles centralizadas; analyze y build web OK; prueba visual manual queda para el usuario |
| P11 | Integridad referencial categorías/métodos | APPROVED — validaciones redundantes en repositorios, archivado sin huérfanos y campos sensibles bloqueados; analyze y build web OK; pruebas existentes no ejecutadas |
| P12 | Fórmulas estadísticas y chart tests | TODO |
| P13 | Privacy review y controles documentados | TODO |
| P14 | Pruebas, perf, accesibilidad y plataformas | TODO |
| P15 | Release checklist, UAT y rollback | TODO |

Cada test debe registrar referencia a AC en el reporte de fase. Las evidencias pueden ser test automatizado, captura, salida de comando o checklist manual explicando pasos y resultado.
