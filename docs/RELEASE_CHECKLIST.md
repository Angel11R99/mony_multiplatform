# Calidad y preparación de publicación

## Estado de la app

- Base local Drift en esquema v9; las migraciones v1–v9 tienen pruebas de migración y preservación de datos.
- CI analiza y prueba en Ubuntu y macOS, compila Android e iOS y crea una build de release de Android con una llave efímera exclusiva de CI. Esa build no se distribuye.
- Android ya no firma release con la llave debug. La build de release exige credenciales propias vía `android/key.properties` o `MONY_RELEASE_*`.
- El módulo de widgets comparte una instantánea local de finanzas; iOS usa `privacySensitive`. Android restringe los widgets a la pantalla de inicio. Los usuarios deben revisar si quieren mostrar importes en su pantalla de inicio.
- Las copias integrales manuales están cifradas. La base SQLite local no usa SQLCipher; depende del almacenamiento privado y la protección del dispositivo que provee cada sistema operativo. Evaluar cifrado completo de base de datos antes de almacenar datos en dispositivos compartidos o administrados.
- La política de privacidad está en `docs/PRIVACY_POLICY_DRAFT.md`; contiene campos sin completar y no está lista para publicar.

## Verificación de cada candidato

- [ ] `flutter pub get`, `flutter analyze` y `flutter test` terminan correctamente.
- [ ] Build Android release AAB con el upload key del responsable; confirmar firma con `apksigner verify --verbose --print-certs`.
- [ ] Build iOS archive con el Team ID, App ID, perfil de distribución y App Group reales; subir primero a TestFlight.
- [ ] Probar upgrade desde la versión anterior con datos reales de prueba y completar las migraciones; comprobar conteos y relaciones antes/después.
- [ ] Crear copia cifrada, moverla a otro dispositivo, restaurarla y verificar categorías, transacciones, pagos parciales, listas, presupuestos, recurrencias y metas. Probar contraseña equivocada y archivo alterado.
- [ ] Probar VoiceOver/TalkBack, navegación por teclado donde aplique, texto al 200 %, contraste, estados de carga/error/vacío, cámara y selección de ticket en Android/iOS.
- [ ] Medir apertura, historial grande, estadísticas, escaneo y renderizado de widgets en dispositivos de gama media; investigar jank, crecimiento de memoria y trabajo pesado en el hilo de UI.
- [ ] Confirmar identificadores definitivos, iconos, capturas, descripciones, soporte y contacto del responsable.
- [ ] Publicar la política de privacidad completa en HTTPS y usar exactamente la misma URL en ambas tiendas.
- [ ] Completar Apple App Privacy y Google Play Data safety con las prácticas observadas de la app y de cada SDK; revisar la petición de código de barras a Open Food Facts.
- [ ] Revisar permisos, texto de cámara/galería, uso de cifrado, clasificación de contenido, export compliance y requisitos vigentes por país.
- [ ] Mantener el upload key fuera del repositorio, respaldarlo de forma segura y habilitar Play App Signing. Nunca usar el keystore temporal de CI para una publicación.
- [ ] Revisar licencia y derechos de los recursos/funciones de la aplicación original antes de distribuir Mony.

## Bloqueos que requieren datos del responsable

El paquete Android y el bundle iOS aún usan identificadores `com.example.*`. Antes de crear las fichas de tienda, el responsable debe elegir y reservar identificadores propios, registrar la aplicación y el App Group en su cuenta Apple, decidir la URL pública de privacidad, proporcionar contacto legal y configurar su llave Android, certificados, perfiles y cuentas de tienda. No se guardan secretos ni se hacen publicaciones desde este repositorio.

Los artefactos creados por el workflow CI están firmados con una llave temporal de pruebas. Sirven para validar el pipeline y no pueden actualizar una aplicación publicada.

## Referencias oficiales

- [Firma de aplicaciones Android y Play App Signing](https://developer.android.com/studio/publish/app-signing.html)
- [Subir app bundles a Play Console](https://developer.android.com/studio/publish/upload-bundle?hl=en)
- [TestFlight](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview/)
- [Privacidad en App Store](https://developer.apple.com/app-store/app-privacy-details/)
- [Data safety de Google Play](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en)
