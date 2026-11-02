# P10 — Calendarios, rangos y reloj

## Flujos
Selector de fecha en crear/editar, rango en filtros, calendario de actividad financiera por día con marcadores/conteos **solo si útil y respaldado por datos**; presets Hoy, Semana, Mes, Año, Personalizado; selector horario únicamente si el modelo registra hora o hay caso de uso explícito.

## Consistencia temporal
Usar fecha/hora del dispositivo correctamente, distinguir fecha civil y timestamp UTC; determinar semana inicial por locale y criterio de negocio; intervalos [inicio, siguienteInicio) para cubrir el último día; no convertir fechas sin hora en UTC arbitrariamente. Zona horaria del usuario cuando aplique y DST si operan usuarios fuera RD. Mostrar `12h/24h` según locale/preferencia, sin duplicar selector sin necesidad.

## Componentes y accesibilidad
Date picker nativo/adaptativo como baseline. Calendar especializado tras P01; navegación mes/año, día seleccionado distinguible de hoy, controles teclado, tamaños táctiles y screen reader. Mostrar estado «sin movimientos» en un día vacío.

## Aceptación
- [x] AC-10-1: los rangos usan `dateEpochDay` con ambos extremos inclusivos; presets Hoy/Semana/Mes/Año y el día seleccionado del calendario filtran el día completo.
- [x] AC-10-2: editor inicializa desde la fecha civil existente y guarda año/mes/día sin convertir a UTC.
- [x] AC-10-3: `MonyDateFormatter` usa esqueletos de `intl` para fechas/meses y ofrece hora explícita 12/24; Material y TableCalendar siguen locales `es`/`en` del dispositivo.
- [x] AC-10-4: TableCalendar 3.2.1 declara Android/iOS/Linux/macOS/Web/Windows; selección/rango se mantienen en controles Material.
- [x] AC-10-5: marcadores, conteo y estado «sin movimientos» se derivan del stream real de transacciones.

## Decisiones P10
- Se adoptó `table_calendar 3.2.1`, la versión compatible con el `intl 0.20.2` fijado por Flutter. La latest 3.3.0 pide `intl >=0.20.3`; no se fuerzan overrides ni se cambia la versión fijada por Flutter.
- Fechas financieras son fechas civiles sin hora: `dateToEpochDay` usa componentes año/mes/día y no aplica offset de zona horaria. No se agregó selector horario.
- La semana empieza según `MaterialLocalizations.firstDayOfWeekIndex`; los presets cubren desde ese inicio hasta hoy y sus extremos son inclusivos.
- `intl` inicializa símbolos locales antes de arrancar Flutter; formatos centrales cubren fechas/meses de módulos financieros. La hora tiene función 12/24, aún sin pantalla que la necesite porque el modelo no guarda tiempo.
- No se añade ni modifica esquema. Web build verificado; prueba visual y táctil por target queda para revisión manual del usuario.
