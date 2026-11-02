# P02 — Arquitectura por funcionalidades y estado

## Propósito
Diseñar una arquitectura viable para la aplicación existente, sin reescribirla. Mantener separación UI / estado / dominio / persistencia.

## Contratos
- `core`: theme, router, responsive, feedback, widgets, formatting, time.
- `features`: home, transactions, categories, payment_methods, analytics; cada feature con presentation y, si existen, domain/data.
- Reutilizar provider/Riverpod/Bloc o patrón ya instalado; un segundo gestor de estado requiere ADR aprobado.
- UI recibe modelos/estados tipados y comandos; DAO Drift no se invoca directamente desde widgets de presentación nuevos.
- Repositorios exponen observables/consultas cancelables y errores tipados; evitar consultas repetidas al cambiar tabs.
- Representar `loading/data/empty/error` sin inferir que `0` significa no datos.
- Los importes se operan con precisión apropiada (centavos enteros o decimal según código existente); jamás double para operaciones de saldo si se puede evitar.

## Decisiones requeridas
Routing, manejo de estado, scope de repositorios, lifetime por pestaña, patrón de errores, inyección de dependencias y límites entre features, sin duplicar modelos.

## Aceptación
- [ ] AC-02-1: diagrama escrito de flujo de datos y ruta de usuario.
- [ ] AC-02-2: nuevos componentes tienen ownership inequívoco.
- [ ] AC-02-3: integridad con Drift y modelos existentes comprobada.
- [ ] AC-02-4: no hay migraciones de BD solo por refactor visual.
- [ ] AC-02-5: test o demostración de que cambio de pestaña no duplica cargas.

---

## P02 — Arquitectura incremental basada en el código existente

**Estado:** APPROVED — el usuario autorizó aprobar las fases ejecutadas el 2026-11-02.
**Commit base:** `d6c98f0`. **Tipo de cambio:** decisión/documentación; sin reescritura de app.

### Evidencia actual

- `main.dart` crea un `ProviderScope` único sobre `MonyApp`; el router se crea en `appRouterProvider`.
- `appDatabaseProvider` es un único provider de base de datos por `ProviderContainer`, cierra Drift al disponer el container. Los providers de repositorios toman esa misma BD y tipan su interfaz de dominio.
- `transactionsProvider` es `StreamProvider<List<FinanceTransaction>>` sobre `TransactionRepository.watchAll()`. El repositorio Drift ejecuta y observa el query; widgets no consultan tablas Drift directamente.
- `dashboardSummaryProvider(month)` deriva el resumen de `transactionsProvider`; `HomePage` consume ese resumen y `categoriesProvider`. `TransactionsPage` consume a su vez `transactionsProvider`, `categoriesProvider` y `paymentMethodsProvider`.
- Entidades y contratos de Transactions, Categories y Payment Methods viven en `domain`; implementaciones y conversión de filas viven en `data`. La transacción usa IDs de categoría/método y `amountInCents`, sin copias del modelo de movimiento.
- Rutas son `GoRoute` normales con navegación nombrada, no hay `ShellRoute`, `StatefulShellRoute`, barra inferior ni `NavigationRail`. Cada pantalla mira providers compartidos; la navegación no crea otro `ProviderScope`.
- Movimientos y agregados monetarios suman centavos `int`; solo formato/visualización y cocientes de gráfico convierten a `double`.

### Diagrama de datos y recorrido de usuario

```mermaid
flowchart LR
  U[Usuario: abre Home o Movimientos] --> UI[HomePage / TransactionsPage]
  UI --> P[Riverpod: ProviderContainer raíz]
  P --> FP[Provider de feature]
  FP --> RI[Contrato Repository en domain]
  RI --> DR[Implementación Drift en data]
  DR --> DV[Reglas/validadores de dominio]
  DR --> DB[AppDatabase · Drift]
  DB --> SQL[(SQLite local / WASM web)]
  SQL -->|cambios observables| DB
  DB -->|Stream<List<FinanceTransaction>>| FP
  FP --> AV[AsyncValue: loading / data / error]
  AV --> UI
  P --> SUM[dashboardSummaryProvider deriva de transactionsProvider]
  SUM --> UI
  UI -->|gesto: crear / editar / eliminar| CMD[ref.read(repositoryProvider)]
  CMD --> RI
```

El Home inicia con `HomePage`; el usuario puede abrir el historial, el detalle y el editor a través de rutas GoRouter. La lectura de una lista fluye por el provider/stream. Un comando sale del callback con `ref.read`, pasa por la interfaz del repositorio y su validación y se ejecuta en el repositorio Drift; el stream notifica a consumidores existentes. El resumen mensual es una derivación de datos persistidos, no un balance de muestra.

### Ownership y límites

| Estado/componente | Dueño | Vida útil / regla |
|---|---|---|
| Base local `AppDatabase` | `appDatabaseProvider` en el `ProviderContainer` raíz | Una instancia por container; la cierra el callback de `ref.onDispose`. No abrir otra BD por página. |
| Contratos y entidades financieras | `features/<feature>/domain` | Dart simple; importes en centavos; contratos declaran Streams/Commands, sin importar Drift/Flutter. |
| Query/write SQL y mapeo fila-modelo | `features/<feature>/data` | Implementa contrato; valida referencias transaccionales; tablas/migraciones permanecen en Drift. |
| Wiring de dependencias | providers actuales `features/*/presentation/*_providers.dart` | Única frontera de composición que conoce contrato e implementación; expone interfaz/provider tipado. Widgets llaman `watch` en build y `read` en acciones, no reciben DAO. |
| Estado compartido reactivo | Providers Riverpod sin `autoDispose` existentes | Un elemento por container y provider/family key; reutilizar, no crear providers/streams dentro de `build`. Añadir `autoDispose` solo con decisión de lifecycle y prueba en caso concreto. |
| Estado derivado (resumen/filtros) | Provider/domain de feature | Derivar de fuente única; no persistir/sincronizar duplicados. |
| Estado efímero de pantalla | `State` local del widget (ej. búsqueda, selector mes) | Local al consumidor; liberar controllers/focus/animation al salir de pantalla. |
| Router y ubicación | `appRouterProvider` + GoRouter | Una instancia de app; rutas con nombre/parámetros validados y error route central. No poner entidades completas en URLs. |
| Preferencias | Repositorio/preferences providers existentes | Persistencia via repository; estado del tema deriva de preferences, no de duplicar campos locales globales. |

La ubicación de providers bajo `presentation` es una convención actual y se conserva como composition seam para no mover dependencias en bloque. Las páginas acceden a provider/contrato; cualquier nuevo SQL debe quedar detrás de `data`/repository. No crear segundo gestor de estado, service locator ni modelos DTO duplicados para SQLite.

### Decisiones P02

1. **Routing:** conservar GoRouter 18.1.2 y los `GoRoute` existentes (ADR-0001 de P01); no hay un shell de pestañas ahora. Solo crear un shell con histories separados cuando P04 defina explícitamente navegación persistente y verifique Back/Web.
2. **Estado:** Riverpod 3 es único gestor. `StreamProvider` para consultas reactivas, `FutureProvider` para lectura puntual, `Provider` para repositorios y servicios; `AsyncValue` representa progreso. Los cálculos puros siguen en Domain.
3. **Scope/lifetime:** `ProviderScope` y `AppDatabase` en raíz; los providers de lista reutilizan stream por container. Estado temporal permanece local; key/family solo para variantes con inputs distintos.
4. **Errores:** listas/reactividad usan `AsyncValue.loading/error/data`; `data([])` es vacío y no equivale a balance cero. Commands conservan excepciones tipadas de negocio (`InvalidTransactionException`, `LastActivePaymentMethodException`, etc.) y las validaciones de dominio. UI muestra texto recuperable para negocio, mensajes genéricos para fallo interno; no filtra SQL/stack trace. No añadir `Either`/Result ni dependencia para envolver exceptions en esta app.
5. **Inyección:** providers de Riverpod son el composition root ligero existente; implementaciones de Drift se esconden detrás de interfaces de dominio. No instanciar `AppDatabase` desde pantalla.
6. **Límites:** conservar carpetas `home`, `dashboard` y `statistics` reales: dashboard es cálculo/resumen consumido por Home; statistics es analítica. No renombrar/mover por la etiqueta genérica «analytics». Categories/Payment Methods conservan entidades propias y Transactions almacena sus IDs.
7. **Dinero y persistencia:** cantidades autoritativas continúan en unidades menores `int`; conversión a `double` solo en formato visual/gráficos, no suma/resta financiera. Ninguna modificación visual/arquitectónica implica schema bump o migración Drift.

### AC-02-5 — demostración estática de carga compartida

No existe pestaña/shell en la versión actual, por tanto no hay una selección de pestaña que dispare carga independiente. El caso observable de dos pantallas consumidoras está cubierto por la misma declaración `transactionsProvider`:

```dart
final transactionsProvider = StreamProvider<List<FinanceTransaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchAll(),
);

// Home: dashboardSummaryProvider.watch(transactionsProvider)
// Movimientos: TransactionsPage.watch(transactionsProvider)
```

Ambos consumidores viven bajo el mismo `ProviderScope` creado antes del router; el provider es compartido por clave y no está declarado `autoDispose`. El stream `watchAll()` se configura desde un solo `StreamProvider` por container, no desde el `build` de cada página. El cambio entre rutas no recrea `ProviderScope` ni `appDatabaseProvider`, así que no crea otro query por página. Esta es una demostración por inspección de código; no se ejecutó prueba dinámica de conteo de consultas. Si P04 añade un shell persistente, las pruebas de reselección/cambio de tab se añaden allí junto a Back y deep links.

### Alcance y aceptación

- [x] AC-02-1: diagrama del recorrido Home/Movimientos, query, stream y comando.
- [x] AC-02-2: ownership de BD, providers compartidos, estado local, routing, domain/data y errores definido.
- [x] AC-02-3: contratos, modelo `amountInCents`, mappers Drift y providers actuales comprobados; no se duplican modelos ni consultas en widgets.
- [x] AC-02-4: no se tocó schemaVersion ni se creó migración.
- [x] AC-02-5: demostración estática de una sola instancia de `transactionsProvider` bajo container raíz; no había pestañas para una prueba dinámica.

**Verificación:** lectura de código (`main.dart`, `app.dart`, router, providers y repositorios de movimientos/categorías/métodos, modelos/validadores y formateo); no se modificó Dart ni se añadieron/ejecutaron pruebas. `git diff --check` valida el diff documental. No hay paquete nuevo; ADR-0001 permanece vigente y P02 no requiere ADR de cambio.

**Rollback:** revertir únicamente la sección P02 de este documento y las actualizaciones de progreso/changelog/matriz/decision log; no hay cambio de app ni de datos que revertir.

**Siguiente sugerida:** P03 — tokens, tema y componentes base. No iniciada.
