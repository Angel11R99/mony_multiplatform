# Contrato operativo para Codex

## Prioridad de instrucciones
1. Solicitud explícita actual del usuario y seguridad de los datos.
2. Este contrato, el README y el prompt maestro.
3. La especificación de la fase activa y sus pruebas de aceptación.
4. Instrucciones de skills instaladas que sean aplicables.
5. Recomendaciones de paquetes externos.

## Protocolo obligatorio por fase
1. **PRECHECK**: leer progreso, fase activa, dependencias y ADR; verificar árbol limpio o registrar cambios preexistentes; detectar bloqueos.
2. **DISCOVER**: inspeccionar código relevante y documentación SKILL.md de las skills pertinentes. No asumir que el lock es la única vía para invocarlas; si falta una skill, informar y seguir con documentación nativa, sin inventar instrucciones.
3. **PLAN**: enumerar archivos potenciales, paquetes, riesgos, criterios de aceptación y tests; no tocar datos aún.
4. **IMPLEMENT**: cambios acotados solo a fase autorizada. Preferir diffs pequeños, commits atómicos si Git está disponible (no hacer commit sin petición o convención existente).
5. **VERIFY**: ejecutar los controles posibles, inspeccionar visualmente si aplica, comprobar que las pruebas fallan en escenarios negativos pertinentes.
6. **REPORT**: resumen de decisión y evidencia, riesgos y regresiones.
7. **STOP**: pedir `APROBAR Pxx` o `CORREGIR Pxx`. No autoaprobarse ni ejecutar Pxx+1.

## Puertas de calidad (fallo = bloqueo)
- Build, análisis o pruebas antes funcionales se rompen.
- Se pierden datos o una acción destructiva no tiene confirmación.
- Se introduce dependencia incompatible, abandonada o sin justificación.
- iOS/web/desktop carecen de fallback cuando una feature requiere plataforma nativa.
- Hay componentes no accesibles, desbordamientos graves o navegación Back rota.
- Los indicadores monetarios muestran cifras inventadas como reales.

## Reporte obligatorio
`Fase`, `Estado (PASS/BLOCKED)`, `Qué cambió`, `Qué NO cambió`, `Skills consultadas`, `Paquetes (versiones y enlaces)`, `Decisiones/ADR`, `Archivos modificados`, `Comandos ejecutados y salidas resumidas`, `Tests manuales`, `Criterios AC marcados`, `Riesgos`, `Rollback`, `Siguiente fase sugerida (sin ejecutarla)`.

## Semántica de comandos del usuario
- `INICIAR Pxx`: iniciar únicamente fase identificada si precondiciones cumplidas.
- `APROBAR Pxx`: acepta entregable Pxx y autoriza comenzar **solo la fase inmediatamente siguiente**, nunca varias.
- `CORREGIR Pxx`: reparar únicamente Pxx, revalidar y detenerse.
- `REVISAR Pxx`: auditoría sin cambios de código.
- `DETENER`: detener implementación y preservar estado.

No atribuir resultados a herramientas no ejecutadas. No actualizar `PROGRESS.md` como PASS solo porque compila una ruta feliz.
