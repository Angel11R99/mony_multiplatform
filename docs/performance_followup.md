# Pendientes para continuar el refactor de rendimiento

Este archivo conserva trabajo que requiere otra sesión o un entorno distinto. Los cambios implementados están resumidos en [performance_review.md](performance_review.md).

## Siguiente sesión

- [ ] **Navbar Sumi-e — primero.** Abrir Historial en un emulador o dispositivo y guardar una captura visual para revisar el lavado de tinta y el trazo sin panel rectangular ni cuadro rojo. Confirmar también la escala efectiva del icono seleccionado (22,5 px, el 75% de una base de 30 px) y su elevación de 2,5 px. El test de navegación verifica esos valores; falta la confirmación visual. En el emulador anterior ADB produjo una superficie negra con Impeller y Skia, aunque la actividad estaba en primer plano, el árbol semántico estaba completo y `FLAG_SECURE` estaba desactivado. No hay dispositivo Android conectado ahora.
- [x] Ejecutar `flutter test --no-pub` completo después del lote de catch-up recurrente. Resultado: 203 pruebas pasaron; `flutter analyze --no-pub` también pasó con Flutter 3.44.4 / Dart 3.12.2. Para regenerar el hook de `objective_c` con ese SDK se resolvieron temporalmente cinco dependencias transitivas a versiones compatibles con Dart 3.12.2 y se restauró `pubspec.lock`; repetir con la resolución bloqueada de Dart 3.13.7 queda pendiente.
- [ ] **Perfiles de pantallas — después de la captura.** Cargar un conjunto de datos reproducible y no sensible; medir Historial, Presupuesto y Estadísticas en Android con latencia, cuadros durante desplazamiento y contraste de importes. Las verificaciones actuales en emulador usaron una base vacía y no cubren esos resultados.
- [ ] **Copias y exportaciones.** Medir tiempo y memoria pico de exportar/restaurar una copia cifrada próxima al límite de 47 MiB; guardar método y resultados para poder comparar cambios.
- [ ] **Dispositivo físico.** Repetir fluidez y consumo de memoria en una sesión prolongada de Android; no hay dispositivo conectado en el entorno actual.
- [ ] Generar el Android App Bundle release con firma local y comparar el tamaño de descarga por dispositivo. Los APK de perfil separados miden 62.6–72.2 MiB y contienen los runtimes de depuración junto con bibliotecas nativas de OCR/código de barras; estas cifras no predicen el tamaño de distribución.

## Orden sugerido para retomar

1. Cerrar la revisión visual del navbar en una superficie que permita capturas.
2. Preparar datos de prueba reproducibles y perfilar las tres pantallas principales.
3. Medir el flujo de copias y exportaciones cerca del límite de tamaño.
4. Repetir los perfiles en hardware físico y completar el tamaño de distribución release.
5. Resolver las compilaciones específicas de plataforma y volver a actualizar [performance_review.md](performance_review.md) con resultados observados.

## Entornos de compilación pendientes

- [ ] Windows: habilitar Developer Mode para symlinks e instalar en Visual Studio el workload Desktop C++ con MSVC v142, herramientas CMake y Windows 10 SDK; luego ejecutar `flutter build windows --profile`.
- [ ] Android release: configurar la firma local (`MONY_RELEASE_*` o `android/key.properties`) y ejecutar el build release.
- [ ] iOS/macOS: compilar desde macOS con Xcode instalado.
- [ ] Revisar cuando se actualicen los plugins los avisos de `cryptography_flutter`, `file_saver` y `home_widget` sobre su configuración propia de Kotlin Gradle Plugin.

## Cierre

- [x] Actualizar [performance_review.md](performance_review.md) con la suite completa (203 pruebas), builds tras las fuentes locales, el límite conocido de captura ADB y el lote de recurrencias atrasadas. Añadir nuevos resultados cuando se completen los perfiles pendientes.
