# P15 — Release readiness y handoff

## Checklist técnico
- Versiones Flutter/Dart fijadas y documentadas; lockfile revisado.
- `flutter analyze`, `flutter test`, `flutter build` para targets disponibles; smoke tests de instalación/arranque.
- Platform permissions, signing y distribución según infraestructura real (no inventar cuentas stores).
- Iconos, splash, accesibilidad, privacidad, fallbacks y mensajes.
- Comportamiento de actualización con BD previa (si hubo migraciones): backup, integridad y recuperación.
- Notas de release, lista de cambios y deuda conocida.

## UAT por escenarios
Usuario nuevo sin datos; usuario con registros; registro ingreso/gasto; editar y borrar; cambiar pestañas y volver; filtros por año/mes; fechas y formatos; modalidades dark/light; cambiar ancho de ventana; errores de base de datos simulados; gráficos exactos.

## Aceptación
- [ ] AC-15-1: matriz final con PASS/BLOCKED/NOT TESTED, nunca PASS supuesto.
- [ ] AC-15-2: todos los criterios de P00–P14 trazables.
- [ ] AC-15-3: instrucciones de rollback y release notes.
- [ ] AC-15-4: documentación de mantenimiento y decisiones.
- [ ] AC-15-5: aprobación del usuario para dar plan por terminado.
