# Política de privacidad de Mony — borrador

> **No publicar sin completar y revisar.** El responsable de Mony debe reemplazar los campos entre corchetes, verificar las prácticas de todos los SDK y servicios, y confirmar los requisitos legales de cada país antes de distribuir la app.

**Vigente desde:** [fecha de publicación]  
**Responsable:** [nombre legal o entidad]  
**Contacto de privacidad:** [correo de contacto]  
**País/domicilio:** [país y domicilio legal]

## Resumen de la aplicación

Mony es una aplicación financiera personal offline-first. No requiere cuenta y no envía la base financiera a un servidor operado por Mony. La información se guarda en la base SQLite local de la aplicación. En Android se desactivó la copia automática de los datos de la aplicación; en iOS los respaldos del dispositivo se rigen por los controles del sistema operativo.

## Información que guarda Mony

En el dispositivo, Mony puede guardar ingresos y gastos, descripciones, fechas, categorías, métodos de pago, presupuestos, ciclos, metas de ahorro, pagos y cobros pendientes, movimientos recurrentes, listas de compras, preferencias y una caché de productos consultados. Los datos de los widgets son un resumen local derivado de esa información.

Mony no integra actualmente cuentas de usuario, publicidad, analítica remota ni un servicio propio de sincronización. Los errores registrados contienen identificadores de evento y tipos de excepción, no el mensaje de error ni los importes.

## Procesamiento y servicios externos

- El texto de tickets se reconoce en el dispositivo mediante el SDK local de reconocimiento de texto.
- Si eliges consultar un código de barras, la app envía ese código a Open Food Facts por HTTPS y guarda la respuesta en una caché local. El proveedor recibe la petición de red y puede procesar metadatos como la dirección IP conforme a su propia política.
- Las notificaciones se programan localmente en el dispositivo.
- Los widgets reciben datos de resumen mediante almacenamiento compartido local de Android/iOS. Los importes pueden quedar visibles en la pantalla de inicio; el usuario puede quitar los widgets y el sistema operativo puede ocultar contenido sensible según sus ajustes.
- Al exportar o compartir CSV, Excel o PDF, el archivo sale del control de Mony y se entrega al destino elegido por el usuario. Esos formatos no se cifran automáticamente.
- La función de copia integral genera un archivo cifrado con AES-256-GCM y una clave derivada de la contraseña elegida por el usuario. Mony no almacena esa contraseña. Sin ella no se puede descifrar la copia.

## Conservación y eliminación

Los datos locales permanecen mientras se conserven en la aplicación o en respaldos gestionados por el sistema operativo. Se pueden editar o eliminar desde los módulos correspondientes. Desinstalar la app elimina sus datos locales según las reglas de la plataforma, pero no elimina archivos exportados, copias cifradas guardadas fuera de la app ni respaldos del dispositivo.

## Seguridad

Mony utiliza el almacenamiento privado de la aplicación, no registra contenido financiero en sus logs y cifra las copias manuales. Los archivos exportados no están cifrados. Ninguna aplicación puede garantizar seguridad en un dispositivo comprometido, desbloqueado o administrado por terceros.

## Menores y cambios de política

Mony no está diseñada específicamente para menores. La política se actualizará junto con la app cuando cambien sus prácticas. La versión vigente debe publicarse en una URL accesible y enlazarse desde las fichas de las tiendas.

## Contacto

Para preguntas, solicitudes o reportes de privacidad: **[correo de contacto]**.
