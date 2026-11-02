# MONY PREMIUM — Plan maestro ejecutable

**Estado:** P00–P03 ejecutadas y aprobadas; P04 es la siguiente fase y aún no se ha iniciado.
**Objetivo:** evolucionar Mony (Flutter multiplataforma) a producto financiero premium con funcionalidades reales, interacción refinada y arquitectura sostenible.  
**Regla fundamental:** **una fase a la vez**, sin avanzar automáticamente; cada fase exige evidencia, revisión y aprobación explícita.

## Cómo usar este repositorio de planificación
1. Copia toda esta carpeta a `docs/mony-premium/` en la raíz del proyecto Flutter. Conserva estructura y nombres.
2. Abre Codex **en la raíz del proyecto** y pega `05-execution/CODEX_MASTER_PROMPT.md`.
3. Codex audita el repositorio y ejecuta **solo P00**. Luego entrega reporte, actualiza progreso y **se detiene**.
4. Revisa evidencia y confirma `APROBAR P00`; entonces Codex podrá iniciar **solo P01**; repite el ciclo.
5. Una fase con pruebas fallidas queda bloqueada. Para corregirla, usa `CORREGIR Pxx`; no empieces la siguiente.

## Orden y dependencias
| ID | Especificación | Entregable principal | Depende de |
|---|---|---|---|
| P00 | `00-governance/01_AUDIT.md` | Inventario del proyecto y línea base verificable | — |
| P01 | `00-governance/02_DEPENDENCIES.md` | Matriz pub.dev y ADR de selección | P00 |
| P02 | `01-foundation/03_ARCHITECTURE.md` | Arquitectura objetivo incremental | P01 |
| P03 | `01-foundation/04_DESIGN_SYSTEM.md` | Tokens, temas y biblioteca base | P02 |
| P04 | `02-experience/05_NAVIGATION.md` | Shell y navegación responsive | P03 |
| P05 | `02-experience/06_MOTION_PLATFORM.md` | Motion, iOS/Android y accesibilidad | P04 |
| P06 | `02-experience/07_FEEDBACK_OVERLAYS.md` | Toasts, modales, dialogs y errores | P05 |
| P07 | `03-features/08_HOME.md` | Dashboard con datos reales y estados vacíos | P06 |
| P08 | `03-features/09_TRANSACTIONS.md` | CRUD de movimientos, acciones y listas | P07 |
| P09 | `03-features/10_SEARCH_FILTERS.md` | Búsqueda, filtros y ordenación | P08 |
| P10 | `03-features/11_CALENDAR_TIME.md` | Calendario, fechas y reloj | P09 |
| P11 | `03-features/12_CATEGORIES_PAYMENTS.md` | Categorías y métodos de pago | P10 |
| P12 | `03-features/13_ANALYTICS.md` | Estadísticas y gráficos verificables | P11 |
| P13 | `04-quality/14_SECURITY_PRIVACY.md` | Revisión de protección de información | P12 |
| P14 | `04-quality/15_TESTING_PERFORMANCE.md` | Test suite, accesibilidad y perf | P13 |
| P15 | `04-quality/16_RELEASE.md` | Validación multiplataforma y cierre | P14 |

Las fases son pequeñas unidades de aceptación, **no una obligación de instalar todos los paquetes**. Se permite reordenar únicamente con ADR escrito y aprobación del usuario.

## Reglas globales
- Preservar funciones, persistencia, datos, rutas existentes y compatibilidad. No reformatear todo el repositorio sin necesidad.
- No fabricar cuentas, balances ni transacciones reales. Datos de demo solo tras una etiqueta explícita y fuera de producción.
- Verificar documentación vigente de pub.dev, licencias, mantenimiento, versión del SDK y soporte por plataforma.
- Antes de cualquier migración Drift: backup y plan de rollback. Cualquier cambio destructivo requiere aprobación específica.
- Elegir widgets Flutter nativos antes que dependencias que resuelvan el mismo problema sin valor añadido.
- Evitar depender de APIs específicas de iOS/Android en web/escritorio sin fallback seguro.
- Cada funcionalidad debe incluir estados loading/empty/error/success, accesibilidad, localización y tests apropiados.
- En cada fase documentar decisiones (ADR), archivos tocados, capturas si es posible, comandos y sus resultados.

## Definición de terminado (DoD) transversal
- Criterios de aceptación de la fase cubiertos y trazados a test/evidencia.
- `dart format --output=none --set-exit-if-changed <archivos modificados>` pasa; `flutter analyze` pasa, `flutter test` pasa (o bloqueo diagnosticado).
- Plataforma objetivo comprobada según disponibilidad; **no declarar probado lo que no se ha ejecutado**.
- Sin regresiones conocidas, o explicitadas como bloqueo.
- Actualizar `05-execution/PROGRESS.md` y `05-execution/CHANGELOG.md`.
- **STOP**: ninguna fase nueva hasta recibir aprobación.

Consulta `00-governance/00_WORKING_AGREEMENT.md` para el contrato de trabajo detallado.
