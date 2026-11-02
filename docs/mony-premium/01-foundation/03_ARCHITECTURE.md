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
