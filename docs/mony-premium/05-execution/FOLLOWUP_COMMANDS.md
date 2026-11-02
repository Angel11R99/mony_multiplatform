# Comandos para continuar con Codex

Después de revisar el reporte de P00:

```
APROBAR P00. Actualiza su estado a APPROVED y ejecuta únicamente P01 según docs/mony-premium/. Comprueba sus criterios, registra evidencias y DETENTE antes de P02.
```

Para cualquier siguiente fase reemplaza `P00` por la **fase completada inmediatamente anterior**. Ej.: aprobar P06 autoriza exclusivamente P07.

Si la fase está bloqueada:
```
CORREGIR P04. Relee su especificación y reporte, corrige solo los criterios pendientes, vuelve a probar, actualiza progreso y DETENTE sin iniciar P05.
```

Para una auditoría sin cambios:
```
REVISAR P08. Verifica la implementación contra todos los AC y el reporte, no modifiques código ni inicies P09.
```

Antes de aprobar, comprueba que `PROGRESS.md` muestre PASS_PENDING_APPROVAL, evidencia, riesgos y resultados de pruebas.
