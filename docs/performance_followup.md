# Pendientes para continuar el refactor de rendimiento

Este archivo conserva trabajo que requiere otra sesión o un entorno distinto. Los cambios implementados están resumidos en [performance_review.md](performance_review.md).

## Siguiente sesión

- [ ] **Navbar Sumi-e — primero.** Abrir Historial en otro emulador o dispositivo y guardar una captura visual. Confirmar que el sello bermellón no se superpone al icono y que el icono seleccionado mide el 75%. En el emulador actual la captura ADB sale negra con Impeller y Skia, aunque la actividad está en primer plano, el árbol semántico está completo y `FLAG_SECURE` está desactivado; tampoco hay ventana del emulador disponible para captura de escritorio. El intento con Skia fue una ejecución de perfil con `--no-enable-impeller`; no se pudo validar visualmente en este equipo.
- [x] Ejecutar `flutter test` completo después del último test de navegación y del cambio de fuentes locales. Resultado: 202 pruebas pasaron.
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

- [x] Actualizar [performance_review.md](performance_review.md) con la suite completa (202 pruebas), builds tras las fuentes locales y el límite conocido de captura ADB. Añadir nuevos resultados cuando se completen los perfiles pendientes.
