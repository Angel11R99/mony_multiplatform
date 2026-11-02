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
