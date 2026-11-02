# P01 — Curaduría pub.dev y matriz de compatibilidad

**Objetivo:** maximizar calidad visual y técnica **minimizando dependencias**. No añadir paquetes por moda.

## Candidatos (no aprobados previamente)
| Necesidad | Comparar | Predeterminado |
|---|---|---|
| Rutas y shell | go_router vs navigator existente | Conservar navegación existente si suficiente |
| Animaciones | flutter_animate, animations, implícitas Flutter | Animaciones nativas primero |
| Temas | flex_color_scheme vs ColorScheme nativo | Tokens y ThemeData primero |
| Iconos | lucide_icons_flutter vs Material/Cupertino | Set único, tree shaking |
| Charts | fl_chart vs librería presente | fl_chart si cumple interactividad |
| Calendario | table_calendar vs CalendarDatePicker | Nativo para selección sencilla |
| Rangos | calendar_date_picker2 vs date picker nativo | Nativo salvo UX insuficiente |
| Gestos | flutter_slidable vs Dismissible | Acción destructiva segura |
| Toasts | toastification vs ScaffoldMessenger | Una solución central |
| Sheets | modal_bottom_sheet vs showModalBottomSheet | Nativo como baseline |
| Skeleton | skeletonizer vs placeholders propios | Evitar tap targets falsos |
| Onboarding | smooth_page_indicator vs nativo | Solo si onboarding realmente existe |
| Biometría | local_auth vs sin auth | Opt-in y fase de seguridad |
| Splash | flutter_native_splash vs splash existente | Solo con necesidad validada |

## Evaluación P01 — 2026-11-02

Versiones consultadas en la API y ficha de pub.dev en la fecha indicada; compatibilidad comparada con Flutter 3.44.4 / Dart 3.12.2 del proyecto. Los links llevan a ficha o licencia del paquete. Los candidatos no agregados se marcaron como diferidos o rechazados. Ningún tamaño se midió: no se descargaron/instalaron candidatos ni se hizo spike. La accesibilidad de los candidatos visuales se deberá probar si se reconsideran; pub.dev no certifica semántica/teclado/tamaño táctil de la integración concreta.

| Necesidad / candidato | Última estable, licencia; mantenedor/actividad | SDK y plataformas declaradas | Dependencias principales / efecto | Ajuste, alternativa, riesgo y estado |
|---|---|---|---|---|
| Rutas — [`go_router`](https://pub.dev/packages/go_router) (ya instalado) | 18.1.2; BSD-3-Clause; publisher `flutter.dev`, versión publicada 2026-10-29; paquete feature-complete, con foco declarado en estabilidad y bugs | Dart ^3.12, Flutter >=3.44; Android/iOS/Linux/macOS/Web/Windows | `collection`, `cupertino_ui`, `flutter_web_plugins`, `logging`, `material_ui`, `meta`; ya está en lock | Coincide con entorno y cubre rutas nombradas, web URL/deep links y detalle anidado usado por la app. Reemplazarlo por Navigator implicaría rehacer rutas existentes sin ganancia suficiente. **approved: conservar versión actual; no actualizar ni migrar en P01.** Sin spike adicional. |
| Animaciones — [`flutter_animate`](https://pub.dev/packages/flutter_animate) | 4.5.2; BSD-3-Clause; publisher `gskinner.com`; última publicación 2024-11-25 (sin publicación reciente al corte) | Dart >=2.17 <4; Flutter >=2; Android/iOS/Linux/macOS/Web/Windows | `flutter_shaders` además de Flutter; runtime y árbol de shaders aumentan superficie de build | P05 decidirá motion; Flutter ya tiene `Animated*`, `TweenAnimationBuilder`, `Hero`. **deferred P05**, por no haber interacción que lo exija hoy y por actividad de publicación baja. Sin spike; tamaño y semántica por integración no medidos. |
| Animaciones — [`animations`](https://pub.dev/packages/animations) | 3.0.0; BSD-3-Clause; publisher `flutter.dev`; publicada 2026-08-19 | Dart ^3.12, Flutter >=3.44; Android/iOS/Linux/macOS/Web/Windows | `material_ui ^1.0.0` aparte de Flutter; más API/dependencia de UI aunque no usada hoy | Framework oficial y compatible, pero las transiciones/motion deben especificarse en P05; nativas bastan como baseline. **deferred P05**; sin spike ni impacto de tamaño medido. |
| Temas — [`flex_color_scheme`](https://pub.dev/packages/flex_color_scheme) | 9.0.0; BSD-3-Clause; publisher `rydmike.com`; publicada 2026-09-15 | Dart >=3.13 y Flutter >=3.47; Android/iOS/Linux/macOS/Web/Windows | `cupertino_ui`, `flex_seed_scheme`, `material_ui`, `meta`; trae framework UI desacoplado | **rejected por incompatibilidad actual** (Flutter del repo 3.44.4/Dart 3.12.2 no satisfacen constraints). Alternativa suficiente: `ThemeData`/`ColorScheme` nativos. Reconsiderar solo con actualización deliberada del SDK y valor medido en P03. |
| Tema de componentes — [`flex_color_scheme` 8.4.0](https://pub.dev/packages/flex_color_scheme/versions/8.4.0) | BSD-3-Clause; publisher `rydmike.com`; 8.4 publicada antes del corte | Compatible con el SDK actual; Android/iOS/Linux/macOS/Web/Windows | `flex_seed_scheme` y dependencias del ecosistema Flutter; resuelto en lock | El rechazo de la fila anterior aplica a la versión 9.0.0. P03 incorporó 8.4.0 tras resolverla con el SDK del repo; se usa para producir `ThemeData` y subtemas Material. **approved P03, fijada en lock.** |
| Navegación circular — [`circle_nav_bar`](https://pub.dev/packages/circle_nav_bar) | 2.2.0; Apache-2.0; uploader no verificado; publicada hace 22 meses al corte | Flutter; Android/iOS/Linux/macOS/Web/Windows | Solo Flutter declarado | El usuario eligió el diseño. P04 usa su barra móvil; se conservan `go_router` y el `NavigationRail` del SDK en escritorio. Riesgo de mantenimiento por antigüedad y uploader no verificado; se añade semántica de selección en la integración. **approved P04 para esta UI; versión lockeada.** |
| Iconos — [`lucide_icons_flutter`](https://pub.dev/packages/lucide_icons_flutter) | 4.0.1; MIT; publisher no verificado `vqhapp.name.vn`; publicada 2026-10-21 | Dart ^3; Android/iOS/Linux/macOS/Web/Windows | Solo Flutter; muchas constantes/icon variants; v4 modulariza pesos para limitar carga de código | Hay Material/Cupertino Icons y el proyecto ya usa Material Icons. Cambiar set afecta consistencia, labels y alcance visual; nuevo paquete no crea valor sin aprobación de diseño. **deferred P03**; importación selectiva podría reducir bundle, pero size/accessibility no medidos. |
| Gráficos — [`fl_chart`](https://pub.dev/packages/fl_chart) | 1.3.0; MIT; publisher `flchart.dev`; publicada 2026-10-21 | Dart >=3.6.2, Flutter >=3.27.4; Android/iOS/Linux/macOS/Web/Windows | `equatable`, `vector_math`; Dart/Flutter, sin plugin nativo declarado | Ya existe gráfico `CustomPainter` en `features/statistics`. Puede aportar charts interactivos en P12; nativo es la alternativa actual. **deferred P12** hasta comparar interacción requerida, semántica textual, zoom/touch y rendimiento con datos reales. Sin spike/size medido. |
| Calendario — [`table_calendar`](https://pub.dev/packages/table_calendar) | 3.3.0; Apache-2.0; uploader no verificado; versión publicada 2026-10-01 | Dart >=3; Android/iOS/Linux/macOS/Web/Windows | `intl >=0.20.3 <0.21.0`, `simple_gesture_detector`; el proyecto fija `intl 0.20.2`, por lo que hay conflicto de resolución en este momento | Tiene UI mensual/eventos, pero P10 aún no demuestra calendario de grilla necesario. `CalendarDatePicker` nativo y mes selector actual son baseline. **deferred P10**; considerar después de alinear intl y definir interacción/accesibilidad. |
| Rangos — [`calendar_date_picker2`](https://pub.dev/packages/calendar_date_picker2) | 4.0.0; Apache-2.0; uploader no verificado; publicada 2026-10-09 | Dart >=2.16, Flutter >=1.17; Android/iOS/Linux/macOS/Web/Windows declaradas | `intl`, `material_ui`; la ficha incluye soporte rango/múltiple; release mayor reciente | No se observó rango multi-fecha necesario. `showDatePicker` nativo cubre selección simple existente. **deferred P10**; revisar el costo de dependencia UI adicional y resolver spike de rangos con keyboard/semantics antes de adoptarlo. |
| Gestos — [`flutter_slidable`](https://pub.dev/packages/flutter_slidable) | 5.2.0; MIT; publisher `romainrastel.com`, Flutter Favorite, publicada 2026-11-01 | Dart ^3.13, Flutter >=3.47; Android/iOS/Linux/macOS/Web/Windows | `material_ui` y Flutter | **rejected por incompatibilidad actual**: requiere Flutter >=3.47/Dart ^3.13. Además acciones destructivas requieren affordance visible/confirmación; alternativa nativa `Dismissible` solo si UX segura. No hay swipe action demandada aún. |
| Toast — [`toastification`](https://pub.dev/packages/toastification) | 3.2.2; BSD-3-Clause; publisher `payamzahedi.com`; publicada 2026-10-25 | Dart >=3; Flutter >=3.38; Android/iOS/Linux/macOS/Web/Windows | `equatable`, `uuid`, `pausable_timer`, `collection`; la ficha también menciona iconos Iconsax Free License | La app ya usa `ScaffoldMessenger` en formularios y operaciones. Centralizar feedback es tarea de P06; paquete añade dependencias y debe respetar focus/semantics/contraste. **deferred P06**, no instalar antes de definir patrón y probarlo. |
| Sheets — [`modal_bottom_sheet`](https://pub.dev/packages/modal_bottom_sheet) | 3.0.0; MIT; publisher `jaimeblasco.com`; última estable publicada 2024-03-12 | Dart >=3.3; Android/iOS/Linux/macOS/Web/Windows | Solo Flutter | El proyecto usa `showModalBottomSheet` en formularios con scroll; no se halló fallo actual que justifique alternativa. **deferred** salvo evidencia de P06/P10; la ficha indica release antigua relativa a candidatos actuales. El tamaño no se midió. |
| Loading — [`skeletonizer`](https://pub.dev/packages/skeletonizer) | 3.0.0; MIT; publisher `codeness.ly`; publicada 2026-09-11 | Dart >=3.7, Flutter >=3.32; Android/iOS/Linux/macOS/Web/Windows | Solo Flutter | **deferred**: estados loading actuales usan indicadores/placeholders Flutter. Skeletonizer requiere contenido de layout; no introducir fixtures financieros falsos ni targets de interacción engañosos. Alternativa: placeholders explícitos; semántica no evaluada. |
| Onboarding — [`smooth_page_indicator`](https://pub.dev/packages/smooth_page_indicator) | 3.0.0; MIT; publisher `codeness.ly`; publicada 2026-08-21 | Dart >=3; Android/iOS/Linux/macOS/Web/Windows | Solo Flutter | No se encontró onboarding en el árbol de rutas/funciones. Indicador nativo o no aplicable. **deferred** hasta que exista flujo onboarding; sin spike y size/accessibility no medidos. |
| Biometría — [`local_auth`](https://pub.dev/packages/local_auth) | 3.0.2; BSD-3-Clause; publisher `flutter.dev`; publicada 2026-07-09 | Dart ^3.10, Flutter >=3.38; Android/iOS/macOS/Windows; sin Web/Linux | `local_auth_android`, `local_auth_darwin`, `local_auth_platform_interface`, `local_auth_windows` | Sin requisito aprobado de autenticación local. Biometría no cifra ni reemplaza control de acceso al archivo de BD; plataformas faltantes necesitan fallback. **deferred P13**, requiere threat model, consentimiento/opt-in y revisión del manejo de secretos. |
| Splash — [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash) | 2.4.8; MIT; publisher verificado `jonhanson.net`; publicada 2026-05-29 | Dart >=3, Flutter >=2.5; Android/iOS/Web (solo donde el generador aplica) | Herramienta dev, pero dependencias de generación: `args`, `image`, `xml`, `yaml`, `path`, `universal_io`, etc. | Ya hay launch assets/config nativos Android, iOS y Web. Este generador edita archivos nativos (styles/manifest/storyboard/Info.plist/web HTML), con riesgo de sobrescribir personalizaciones. **deferred P15**; usar solo con necesidad confirmada y diff inspeccionado. |

### Resultado de selección

- Se conserva `go_router 18.1.2` como decisión de P01; no se cambia su pin.
- Las alternativas que no caben en Flutter/Dart actuales (FlexColorScheme 9 y flutter_slidable 5) quedan rechazadas por incompatibilidad de constraints, no por calidad general.
- Los demás paquetes se difieren hasta su fase funcional/UX indicada. Las necesidades existentes tienen solución nativa o implementada, sin caso de feature suficiente para sumar otra dependencia.
- No se añadió ni actualizó ninguna dependencia en `pubspec.yaml`/`pubspec.lock`; no se generaron cambios de build. No hay APIs/tamaños/licencias de distribución nuevos que incorporar hoy. Para cualquier adopción futura se deberá reevaluar lock, licencia completa de transitivas, web/desktop build y comportamiento accesible.
- Efecto de tamaño: no se instalaron paquetes ni se hizo build diferencial, así que no hay MB medidos. Los candidatos UI descritos son Dart/Flutter sin plugin nativo declarado (no añaden una biblioteca nativa al ABI por sí solos); sí pueden aumentar el código Dart/recursos del bundle. `local_auth` añade implementaciones nativas Android/iOS/macOS/Windows y `flutter_native_splash` es herramienta de generación/build, no runtime. Cualquier delta exacto necesita build de comparación.
- Conteos transitivos completos no se proyectan sin resolver spike real; se registraron las dependencias inmediatas declaradas en pub.dev. Accesibilidad de cada composición no se validó sin integrar/renderizar; no hay afirmación de cumplimiento.

### Seguimiento de dependencias Drift detectadas en P00

El lock resuelve `sqlite3 3.5.2` (rama 3.x) junto a `sqlite3_flutter_libs 0.6.0+eol` y `sqlcipher_flutter_libs 0.7.0+eol` transitivas desde `drift_flutter 0.3.1`. La documentación de Drift/sqlite3 explica que desde `sqlite3` 3.x las dos bibliotecas Flutter ya no se necesitan; `sqlite3_flutter_libs` es ahora una biblioteca vacía de compatibilidad y `sqlcipher_flutter_libs` ya no se usa. Por tanto, las marcas `+eol` no acreditan que SQLCipher se use ni que la BD actual esté cifrada. **Decisión P01:** no cambiar la cadena Drift ni retirar transitivas a mano; sin acción/riesgo runtime observado en el lock actual. Si P13 requiere cifrado de BD y no solo de backups, se necesitará configuración y prueba explícitas, no asumirlo por este paquete transitivo. Fuentes: [nota de migración sqlite3 3.0](https://pub.dev/packages/sqlite3/changelog), [Drift, plataformas nativas](https://drift.simonbinder.eu/platforms/vm/), [Drift, cifrado](https://drift.simonbinder.eu/platforms/encryption/).

## ADR-0001 — Conservar go_router existente

- **Contexto:** la app ya define destinos nombrados, rutas hijas de movimientos/compras/obligaciones, argumentos/query params y errores de ruta en `lib/core/routing/app_router.dart`.
- **Opciones:** conservar go_router; reescribir con Router/Navigator del SDK.
- **Decisión P01:** conservar go_router 18.1.2 sin actualizar ni migrar.
- **Justificación:** satisface rutas actuales y Web URL/deep link; migrar ahora introduce riesgo amplio para navegación/back stack sin necesidad demostrada. El mantenimiento upstream declara el paquete feature-complete, con foco en estabilidad/bugs.
- **Plataformas:** pub.dev declara Android/iOS/Linux/macOS/Web/Windows.
- **Alternativa descartada:** reescritura con APIs base: requeriría migración y cobertura adicional sin beneficio funcional en esta fase.
- **Riesgos:** compatibilidad de rutas/back/deep links aún debe verificarse cuando se audite P04; conservar no reemplaza esas pruebas.
- **Validación:** inspección estática de rutas/uso existentes y constraints de pub.dev (18.1.2; Flutter >=3.44, Dart ^3.12); no hubo spike ni build específico.
- **Fecha/Fase/Reversibilidad:** 2026-11-02, P01; reversible, con costo de migración creciente según rutas/features.

## Evidencia de P01 y cierre

- **Estado al completar la matriz:** PASS_PENDING_APPROVAL; el usuario la aprobó explícitamente el 2026-11-02. Sin dependencias instaladas, retiradas ni actualizadas.
- **Criterios:** AC-01-1 cubierto por la matriz de 15 candidatos del documento; AC-01-2 por `approved` conservar, `deferred` por fase/necesidad y `rejected` por incompatibilidad; AC-01-3 sin diffs de paquete; AC-01-4 licencias, plataformas, restricciones del SDK, dependencias inmediatas y efecto de build anotados.
- **Skills consultadas:** `dart-flutter-patterns` (patrones de mantener dependencias/convenios actuales), `flutter-drift` (dependencias SQLite/SQLCipher y cautela de migraciones). La auditoría P00 ya había consultado las siete skills listadas en su reporte.
- **Fuentes/inspección:** `pubspec.yaml`, `pubspec.lock`, `dart pub deps --style=compact`, código de rutas/tema/estadísticas/pickers/feedback y endpoints/fichas de pub.dev para versión estable, constraints, plataformas, dependencias directas declaradas y licencia.
- **Comandos:** `dart pub deps --style=compact` devuelve lock resuelto; búsquedas `rg` confirmaron `GoRouter`, `CustomPainter`, `showDatePicker`, `showModalBottomSheet`, `ScaffoldMessenger` y ausencia de candidatos en `pubspec.yaml`; consulta de API pub.dev (`Invoke-RestMethod`) obtuvo metadatos latest. No se ejecutó `pub add`, resolución ni build diferencial dado que no hay cambio de dependencias.
- **Pruebas/build:** no aplican a esta entrega documental; P00 registra el baseline. No se hizo spike ni validación de comportamiento candidato.
- **Riesgos/rollback:** necesidades futuras quedan diferidas por fase e incompatibilidades actuales rechazadas; la investigación SQLite resuelve la alerta de P00 como dependencias EOL/no-op con sqlite3 3.x. Revertir matriz/ADR en documentos si se corrige P01. Sin impacto runtime/build generado.
- **Skills y paquete:** cero versiones nuevas resueltas y cero licencias de distribución nuevas introducidas.
- **Siguiente fase:** P02 (arquitectura incremental); no iniciada.

## Registro por candidato
Capturar: nombre; URL pub.dev; versión estable actual; fecha revisión; licencia; maintainer y actividad; SDK mínimo; Android/iOS/web/Windows/macOS/Linux; dependencias transitivas; tamaño aproximado; accesibilidad; riesgos; alternativa nativa; por qué se instala; evidencia de spike; estado `approved/rejected/deferred`.

## Política de instalación
- Nunca resolver versiones a ciegas con snippets antiguos; `flutter pub add` tras verificar versión actual y constraints.
- Instalar solo cuando la fase funcional lo necesita, aunque P01 apruebe candidatos.
- Pin mediante `pubspec.lock` para apps; tratar bumps como cambios revisables.
- Si un paquete está descontinuado o una plataforma no tiene soporte, rechazar o definir fallback documentado.
- No introducir SDKs de telemetría ni terceros para datos financieros sin aprobación explícita.

## Criterios
- [ ] AC-01-1: matriz documentada para todos los candidatos realmente evaluados.
- [ ] AC-01-2: decisiones aprobadas/deferidas/rechazadas con razones y alternativa.
- [ ] AC-01-3: cero dependencias añadidas sin feature ni compatibilidad comprobada.
- [ ] AC-01-4: efectos sobre builds y licencias identificados.
