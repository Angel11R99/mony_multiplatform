# Recordatorios locales

Mony guarda localmente la preferencia de avisos. El permiso del sistema se solicita únicamente cuando la persona activa **Activar notificaciones** en Ajustes.

## Horarios y sincronización

- Las obligaciones abiertas con fecha reciben un aviso a las 9:00 a. m. del día de vencimiento. Si la fecha ya pasó, el aviso se presenta al sincronizar la app y no se repite indefinidamente.
- Las series recurrentes avisan a las 9:00 a. m. del día anterior a cada movimiento futuro.
- El planificador mantiene hasta 60 avisos próximos. Al editar, pausar o liquidar un elemento, al cambiar el permiso, al iniciar o al reanudar Mony, vuelve a comparar los avisos deseados con los pendientes del sistema, actualiza los que cambiaron y cancela los obsoletos.
- Android usa alarmas inexactas durante inactividad para no pedir el permiso de alarmas exactas. El sistema puede retrasarlas para ahorrar batería; el receptor de reinicio vuelve a registrarlas después de reiniciar el dispositivo.

## Límites de plataforma

- **Android, iOS y macOS:** admiten avisos locales programados. Android puede retrasarlos por ahorro de batería o restricciones del fabricante. iOS conserva como máximo 64 avisos pendientes; Mony reserva un margen y agenda los 60 más próximos. Los modos Concentración, No molestar y los ajustes del sistema también pueden ocultar o silenciar avisos.
- **Web, Windows y Linux:** Mony muestra avisos cuando la app está abierta y sincroniza al iniciar, reanudar, modificar datos y cada cinco minutos. No se promete entrega con la app cerrada. Los navegadores no permiten programar notificaciones; Linux no ofrece una API de programación uniforme y Windows no permite cancelar notificaciones de una app sin identidad MSIX.
- En Web, los navegadores requieren un origen seguro y el permiso se solicita desde una acción explícita. Si el permiso ya fue denegado, debe cambiarse en los ajustes del navegador.

La verificación automatizada cubre la planificación, reprogramación, cancelación, límite de cola y alternativa en primer plano. La entrega del sistema operativo, el reinicio del dispositivo y el ahorro de batería requieren validación manual en dispositivos reales; este entorno no dispone de un Android o iPhone conectado.
