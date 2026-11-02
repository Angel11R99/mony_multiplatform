# P13 — Privacidad, seguridad y manejo de datos

**Estado:** APPROVED bajo la autorización persistente del usuario  
**Fecha:** 2026-11-02  
**Base:** P12 `7333bbe` (código), `82bb12b` (documentación)  
**Siguiente:** P14 — pruebas, accesibilidad y rendimiento

## Cambios ejecutados

- Se integró `screenshot_shield` 0.2.0 desde pub.dev para ocultar/difuminar la vista del app switcher al dejar Mony en Android, iOS y Windows. Capturas normales siguen disponibles; no se activó captura/detección ni se pide permiso de galería para esa función. El plugin es reciente, subido por publisher no verificado y iOS usa integración de UIKit para este comportamiento; la ficha, licencia MIT, plataformas y riesgos quedaron registrados en la matriz de dependencias.
- El manifest merge Android elimina `DETECT_SCREEN_CAPTURE`, `DETECT_SCREEN_RECORDING` y `READ_EXTERNAL_STORAGE` declarados por el plugin, pues no usamos esas funciones.
- La consulta de códigos de barras a Open Food Facts ahora empieza desactivada. El usuario debe activar la opción y pulsar búsqueda para enviar el EAN/UPC; se documenta que el servicio verá también la IP.
- La pantalla Privacidad ahora aclara que SQLite no está cifrada por Mony; Android desactiva backup automático en la nube, mientras iOS/iPadOS puede incluir datos de la app en sus copias del dispositivo. Explica la máscara del app switcher, el alcance de widgets y la diferencia entre backup cifrado y exportaciones sin cifrar.
- El mapa de datos, usos, retención, permisos, canales externos y controles se detalla en `04-quality/14_SECURITY_PRIVACY.md`.

## Revisión del estado existente

- Movimientos, catálogos, presupuestos, pagos y resto de datos financieros: SQLite local vía Drift. No hay cifrado a nivel de BD ni bloqueo de app; no se instaló biometría, pues no hay requisito de autenticación local y biometría no cifraría SQLite.
- Copias portables: envoltura AES-256-GCM y PBKDF2-HMAC-SHA256 de 600.000 iteraciones; contraseña requerida de 12+ caracteres, tamaño limitado, schema version verificada y restauración transaccional con `foreign_key_check`.
- Exportaciones CSV/XLSX/PDF: contenido en claro, elegido explícitamente por el usuario y guardado/compartido por file picker/share sheet.
- OCR de tickets: Google ML Kit corre localmente. Escaneo de código usa Open Food Facts solamente con opción activada y búsqueda manual.
- Widgets: JSON con saldos y listas reducidas a cinco entradas; guardado en las preferencias/app group locales para extensiones del propio dispositivo. iOS widgets ya usan `.privacySensitive()`; widgets de inicio pueden quedar a la vista.
- Logs: únicamente evento estable y `runtimeType`, sin mensaje, stack ni contenido financiero. No hay Firebase Analytics, Sentry u otro SDK de telemetría/crash reporting.
- Permisos Android revisados: `CAMERA`, `INTERNET`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE`, `POST_NOTIFICATIONS`; cámara es hardware opcional. Uso de picker sin permiso general de almacenamiento. iOS describe cámara y galería en `Info.plist`.
- No se modificó esquema Drift (schemaVersion 9), migraciones ni cifrado de la base.

## Verificación

- `flutter pub get` — OK; lock y registrantes generados para plugins.
- `dart format` — OK.
- `flutter analyze` — OK, sin issues.
- `flutter build web --release` — OK, incluye dry run Wasm exitoso.
- `git diff --check` — OK.
- `flutter build apk --debug` — no llegó a compilar: el Android SDK local contiene NDK `28.2.13676358` sin `source.properties` (fallo de instalación local previa); no se alteró ni borró ese SDK. Por este bloqueo no se pudo inspeccionar manifest merger final ni validar Android en runtime.
- Tests existentes no ejecutados. No se puede compilar/verificar el target iOS en este host Windows.

## Riesgos residuales priorizados

1. **Alto:** SQLite no cifrada por Mony y no hay bloqueo de app; quien acceda al dispositivo desbloqueado o a una copia extraída puede leer datos. Solución futura requeriría una decisión de producto, key management, migración/recovery y evaluación de soporte multiplataforma; no se improvisó en esta fase.
2. **Alto:** datos locales de iOS/iPadOS pueden entrar en respaldo del sistema; Android `allowBackup=false` no garantiza bloquear toda transferencia dispositivo-a-dispositivo en todos los fabricantes. La copia exportada por Mony, con contraseña, sigue siendo la ruta portable cifrada.
3. **Medio:** widgets y exportaciones pueden exponer importes, nombres y contrapartes a la pantalla o destinos elegidos. Android no tiene redacción equivalente ya configurada; quitar widgets y proteger dispositivo reduce, pero no elimina todos los escenarios.
4. **Medio:** `screenshot_shield` 0.2.0 es joven y publisher no verificado; el app switcher debe probarse en Android/iOS reales y reevaluarse antes de publicar. No equivale a impedir capturas ordinarias ni protege de dispositivo comprometido.
5. **Bajo:** al activar catálogo, el código de barras y metadatos de conexión llegan a Open Food Facts. Opción apagada por defecto; no se comparten registros financieros.
6. **Pendiente de publicación:** completar responsable, contacto, política legal y declaraciones de privacidad de tiendas según jurisdicciones/plataformas objetivo.

## Prueba manual sugerida

1. Abrir Mony, mostrar balance y una lista reciente; pasar a apps recientes y confirmar que no se ve el contenido. Repetir en Android e iOS.
2. Confirmar que una captura normal sigue siendo posible y que desactivar el bloqueo de red del producto deja la consulta de barras local; habilitarlo solo para verificar el aviso y resultado de catálogo.
3. En iOS, bloquear el dispositivo y revisar la opción del sistema para widgets sensibles; en Android comprobar visibilidad del widget en pantalla de inicio/bloqueo según launcher.
4. Crear/abrir una copia cifrada y exportar un CSV en un destino local controlado para comprobar la distinción de formatos.

La validación visual manual, el APK Android y los casos de plataforma quedan para el usuario/P14; los commits de P13 quedan pendientes hasta su siguiente petición, separados por dependencia/código/documentación.
