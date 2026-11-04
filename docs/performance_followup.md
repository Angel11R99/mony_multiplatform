# Pendientes para continuar el refactor de rendimiento

Este archivo conserva trabajo que requiere otra sesión o un entorno distinto. Los cambios implementados están resumidos en [performance_review.md](performance_review.md).

## Siguiente sesión

- [ ] Repetir una captura visual del navbar Sumi-e en emulador/dispositivo y confirmar que el sello bermellón queda fuera del icono Historial. La captura ADB del emulador actual salió negra, aunque la actividad y el árbol semántico Flutter estaban activos.
- [ ] Ejecutar `flutter test` completo después del último test de navegación (el último resultado completo previo fue 200; el test de navegación añadido después también pasa por separado).
- [ ] Perfilar con datos poblados en Android el historial, Presupuesto y Estadísticas; registrar latencia y cuadros en desplazamiento, no solo estado vacío.
- [ ] Medir memoria pico y duración de exportar/restaurar una copia cifrada próxima al límite de tamaño configurado (47 MiB).
- [ ] Validar Android en un dispositivo físico, incluyendo consumo de memoria y fluidez prolongada.

## Entornos de compilación pendientes

- [ ] Windows: habilitar Developer Mode para symlinks e instalar en Visual Studio el workload Desktop C++ con MSVC v142, herramientas CMake y Windows 10 SDK; luego ejecutar `flutter build windows --profile`.
- [ ] Android release: configurar la firma local (`MONY_RELEASE_*` o `android/key.properties`) y ejecutar el build release.
- [ ] iOS/macOS: compilar desde macOS con Xcode instalado.
- [ ] Revisar cuando se actualicen los plugins los avisos de `cryptography_flutter`, `file_saver` y `home_widget` sobre su configuración propia de Kotlin Gradle Plugin.

## Cierre

- [ ] Actualizar [performance_review.md](performance_review.md) con resultados reproducibles, límites del hardware usado y cualquier regresión encontrada.
