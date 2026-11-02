# P10 — Calendarios, rangos y reloj

## Flujos
Selector de fecha en crear/editar, rango en filtros, calendario de actividad financiera por día con marcadores/conteos **solo si útil y respaldado por datos**; presets Hoy, Semana, Mes, Año, Personalizado; selector horario únicamente si el modelo registra hora o hay caso de uso explícito.

## Consistencia temporal
Usar fecha/hora del dispositivo correctamente, distinguir fecha civil y timestamp UTC; determinar semana inicial por locale y criterio de negocio; intervalos [inicio, siguienteInicio) para cubrir el último día; no convertir fechas sin hora en UTC arbitrariamente. Zona horaria del usuario cuando aplique y DST si operan usuarios fuera RD. Mostrar `12h/24h` según locale/preferencia, sin duplicar selector sin necesidad.

## Componentes y accesibilidad
Date picker nativo/adaptativo como baseline. Calendar especializado tras P01; navegación mes/año, día seleccionado distinguible de hoy, controles teclado, tamaños táctiles y screen reader. Mostrar estado «sin movimientos» en un día vacío.

## Aceptación
- [ ] AC-10-1: límites de rango incluyen último día sin perder operaciones.
- [ ] AC-10-2: fechas seleccionadas conservadas correctamente en edición.
- [ ] AC-10-3: formatos `es`/`en` y 12/24 comprobados.
- [ ] AC-10-4: selector no falla en web/desktop/iOS/Android disponible.
- [ ] AC-10-5: calendario nunca inventa actividad.
