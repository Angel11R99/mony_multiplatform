# Pendientes para continuar el refactor de rendimiento

Este archivo conserva trabajo que requiere otra sesión o un entorno distinto. Los cambios implementados están resumidos en [performance_review.md](performance_review.md).

## Siguiente sesión

- [ ] Repetir una captura visual del navbar Sumi-e en otro emulador o dispositivo y confirmar que el sello bermellón queda fuera del icono Historial. En el emulador actual ADB produce una superficie negra tanto con Impeller como con Skia, aunque la actividad está en primer plano, el árbol semántico Flutter está completo y `FLAG_SECURE` está desactivado; el emulador tampoco expone una ventana al control de escritorio.
- [x] Ejecutar `flutter test` completo después del último test de navegación y del cambio de fuentes locales. Resultado: 202 pruebas pasaron.
- [ ] Perfilar con datos poblados en Android el historial, Presupuesto y Estadísticas; registrar latencia y cuadros en desplazamiento, no solo estado vacío.
- [ ] Medir memoria pico y duración de exportar/restaurar una copia cifrada próxima al límite de tamaño configurado (47 MiB).
- [ ] Validar Android en un dispositivo físico, incluyendo consumo de memoria y fluidez prolongada.
- [ ] Generar el Android App Bundle release con firma local y comparar el tamaño de descarga por dispositivo. Los APK de perfil separados miden 62.6–72.2 MiB y contienen los runtimes de depuración junto con bibliotecas nativas de OCR/código de barras; estas cifras no predicen el tamaño de distribución.

## Entornos de compilación pendientes

- [ ] Windows: habilitar Developer Mode para symlinks e instalar en Visual Studio el workload Desktop C++ con MSVC v142, herramientas CMake y Windows 10 SDK; luego ejecutar `flutter build windows --profile`.
- [ ] Android release: configurar la firma local (`MONY_RELEASE_*` o `android/key.properties`) y ejecutar el build release.
- [ ] iOS/macOS: compilar desde macOS con Xcode instalado.
- [ ] Revisar cuando se actualicen los plugins los avisos de `cryptography_flutter`, `file_saver` y `home_widget` sobre su configuración propia de Kotlin Gradle Plugin.

## Cierre

- [x] Actualizar [performance_review.md](performance_review.md) con la suite completa (202 pruebas), builds tras las fuentes locales y el límite conocido de captura ADB. Añadir nuevos resultados cuando se completen los perfiles pendientes.
