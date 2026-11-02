# P13 — Privacidad, seguridad y manejo de datos

## P13 — revisión de datos y amenazas

| Activo / superficie | Tratamiento actual | Exposición / control |
|---|---|---|
| Movimientos, balances, contrapartes, catálogos y preferencias | SQLite con Drift en almacenamiento de la app; cache de catálogo en preferencias | No existe cifrado de la base por Mony ni autenticación de app. La copia local administrada por iOS/iPadOS puede entrar en el backup del sistema; las opciones del usuario y la protección del dispositivo se aplican aparte. Android pone `allowBackup=false`; algunos fabricantes aún pueden permitir transferencia dispositivo a dispositivo. |
| Diagnósticos | Eventos de identificador fijo y clase de error (`runtimeType`); sin stack, texto ni fila de BD | No se integra SDK de crash-reporting/analytics externo. La salida de `dart:developer` puede verla una sesión de depuración/herramienta local. |
| Consulta Open Food Facts | Se envía código EAN/UPC en una consulta HTTPS al pulsar buscar | Opción de red ahora desactivada inicialmente. Al habilitar y buscar se comparte código e IP con Open Food Facts; no se envían movimientos, recibos ni listas. Respuesta queda en caché local. |
| Widgets | Snapshot acotado a cinco elementos por lista, serializado a preferencias de Android o App Group iOS | Es legible para el widget del propio sistema y visible en pantalla de inicio. iOS declara el contenido `privacySensitive`; Mony difumina la vista de la app al pasar a segundo plano. Quitar widgets reduce exposición visual, pero el snapshot se conserva en el área privada compartida hasta que se reemplace o desinstale la app. |
| Exportar/restaurar | CSV/XLSX/PDF en claro a destino elegido por el usuario; backup JSON cifrado AES-256-GCM/PBKDF2 | El export se comparte explícitamente mediante file picker/share sheet. Backup requiere frase de 12+ caracteres y restaurar confirma que reemplaza todos los datos; transacción y foreign-key check. Una contraseña débil elegida por el usuario sigue siendo riesgo. |
| Capturas y vista reciente | `screenshot_shield` difumina la miniatura reciente Android/iOS/Windows | Capturas normales permitidas. En iOS, el plugin depende de integración UIKit para la vista reciente; verificar en versiones soportadas. No debe considerarse protección contra dispositivo comprometido o captura externa. |

Sin datos financieros enviados a servicios propios; no hay cuenta, sync ni telemetría. La app no promete cifrado de base local. Cifrar Drift/SQLite implicaría seleccionar e integrar un motor/key management y diseñar migración/recovery; no se alteró esquema ni cifrado en P13.

## Auth local opcional
Evaluar `local_auth` para bloqueo de app **solo tras comprobar soporte por plataforma y requerimiento del producto**; nunca almacenar biometría; fallback a mecanismo de desbloqueo disponible, no bloquear web/escritorio por ausencia. No inventar un sistema de contraseñas casero.

## Drift y permisos

Drift usa consultas tipadas; SQL de backup construye identificadores únicamente desde una lista constante de tablas/columnas introspectadas y pasa valores como bindings. El restore valida versión y set de tablas, aplica en transacción y comprueba claves foráneas. P13 no cambia esquema ni migraciones (schemaVersion 9). Tests existentes de backup no se ejecutaron en esta fase.

Permisos Android tras combinar manifests: `CAMERA`, `INTERNET`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE` y `POST_NOTIFICATIONS`, vinculados a escáner, catálogo opcional, recordatorios y notificaciones. Cámara está marcada opcional en hardware. El plugin nuevo declara detección de captura/lectura de imágenes que no se usa y se elimina con reglas de manifest merge. File picker comparte archivos elegidos sin permiso general de almacenamiento. iOS declara cadenas para cámara y galería, invocadas por captura/importación. Android `allowBackup=false`. WidgetKit iOS usa App Group y `.privacySensitive()`.

## Aceptación
- [x] AC-13-1: mapa de activos y superficies arriba; se explica intercambio de código/IP y exposición de widgets/archivos.
- [x] AC-13-2: llamadas revisadas; no se registran contenido de errores, stack traces ni valores financieros; no hay SDK externo de analítica.
- [x] AC-13-3: permisos Android/iOS inventariados; permisos transitivos innecesarios de screenshot_shield eliminados; red de catálogo pasa a opt-in apagado inicialmente.
- [x] AC-13-4: sin cambios de esquema ni cifrado de base; el backup portable explícito sigue cifrado.
- [x] AC-13-5: riesgos residuales priorizados en el reporte P13, incluidos DB sin cifrado, backup iOS, uploader reciente y widget snapshot.

## Fuentes de plataforma/paquete
- Android Auto Backup y límite de `allowBackup=false` en transferencias entre dispositivos: [Android Developers](https://developer.android.com/identity/data/autobackup).
- Datos de la app en iCloud Backup: [Apple Developer](https://developer.apple.com/documentation/foundation/optimizing-your-app-s-data-for-icloud-backup).
- Widgets sensibles en pantalla bloqueada: [Apple WidgetKit](https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension).
- Alcance, licencia y límites del masking: [screenshot_shield en pub.dev](https://pub.dev/packages/screenshot_shield).
