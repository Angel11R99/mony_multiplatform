# P13 — Privacidad, seguridad y manejo de datos

## Threat review
Datos sensibles: movimientos, saldos, categorías, nombres de métodos, preferencias. Revisar persistencia, logs, crash reports, screenshots en app switcher si es pertinente, backup, exportaciones y permisos móviles. Minimizar datos capturados; no añadir SDK externo de analítica sin consentimiento/aprobación.

## Auth local opcional
Evaluar `local_auth` para bloqueo de app **solo tras comprobar soporte por plataforma y requerimiento del producto**; nunca almacenar biometría; fallback a mecanismo de desbloqueo disponible, no bloquear web/escritorio por ausencia. No inventar un sistema de contraseñas casero.

## Drift
Verificar esquema/migraciones, transacciones atómicas, consultas parametrizadas, test con BD temporal aislada. Cualquier migración necesita versionado, test desde versión anterior y copia de seguridad/rollback acordado. Cifrado en reposo requiere diseño específico (no asumir que Drift lo incorpora automáticamente).

## Aceptación
- [ ] AC-13-1: mapa de datos sensibles y superficies de exposición.
- [ ] AC-13-2: ausencia de logs financieros innecesarios.
- [ ] AC-13-3: permisos mínimos en plataformas usadas.
- [ ] AC-13-4: no se cambia esquema ni cifrado de forma opaca.
- [ ] AC-13-5: riesgos residuales documentados con prioridad.
