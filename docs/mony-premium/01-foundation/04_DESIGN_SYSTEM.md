# P03 — Design System y temas

## Identidad
Mony: fintech confiable, minimalista, dark-first, lavanda/morado. **Valores iniciales candidatos** (revisar contraste con herramientas): background `#151218`, surface `#27212F`, primary `#C8A8F4`, income `#75D6AC`, expense `#F08D9B`. No codificar hex dispersos por vistas.

## Sistema de tokens
`ColorScheme` light/dark, `ThemeExtension` para semánticos financieros; tipografía escalable (title/display/body/label), escala de espaciado 4/8/12/16/24/32, radius 8/12/16/24, elevation discreta, borde, estados hover/focus/pressed/disabled, motion durations y curves.

## Biblioteca de componentes
Usar controles Material del SDK directamente (`FilledButton`, `OutlinedButton`, `IconButton`, `TextField`, `FilterChip`) y centralizar su estilo en `FlexColorScheme`; no añadir wrappers que solo reenvían sus propiedades. Mantener widgets Mony cuando expresen semántica financiera o comportamiento compartido (`MonyCard`, `BalanceCard`, `AmountText`, `StatTile`, estados, `SectionHeader`, `ResponsiveContainer`).

## Responsividad y plataforma
Definir breakpoints como tokens justificados, no por dispositivo específico; touch >= 48 dp cuando apropiado; foco visible en desktop; vistas de texto muy grande; SafeArea; color contrast AA para texto salvo excepciones documentadas. Cupertino styling solo si mejora UX sin fragmentar identidad.

## Criterios
- [ ] AC-03-1: dark + light + seguir sistema operando.
- [ ] AC-03-2: sin colores literales repetidos en nuevos módulos.
- [ ] AC-03-3: story/demo de componentes o widget tests para estados.
- [ ] AC-03-4: tamaños y contraste verificados.
- [ ] AC-03-5: no overflow con fuente escalada y anchos objetivo.
