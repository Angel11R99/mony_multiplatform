# Pendientes para continuar el refactor de rendimiento

Este archivo conserva trabajo que requiere otra sesión o un entorno distinto. Los cambios implementados están resumidos en [performance_review.md](performance_review.md).

## Siguiente sesión

- [x] **Auditar inicialización de fechas del arranque.** En isolates limpios del host, `intl` registró 120 locales en 6,74 ms y Flutter localizations 98 en 5,14 ms. La diferencia es pequeña y no mide primer cuadro; se conserva el bootstrap y queda pendiente medirlo en dispositivo.
- [x] **Navbar Sumi-e — captura y corrección visual.** En el AVD `Medium_Phone`, capturas ADB de Inicio e Historial muestran los ocho iconos sobre el fondo claro; Historial ya no presenta el cuadro rojo. Se corrigió el contraste de iconos inactivos y el activo quedó en 36 px, con elevación de 0,156 px (75% menor que el ajuste anterior). Se conservan el lavado de tinta y el trazo inferior animado.
- [x] Ejecutar `flutter test --no-pub` completo después del lote de catch-up recurrente. Resultado: 203 pruebas pasaron; `flutter analyze --no-pub` también pasó con Flutter 3.44.4 / Dart 3.12.2. Para regenerar el hook de `objective_c` con ese SDK se resolvieron temporalmente cinco dependencias transitivas a versiones compatibles con Dart 3.12.2 y se restauró `pubspec.lock`; repetir con la resolución bloqueada de Dart 3.13.7 queda pendiente.
- [x] **Historial y Estadísticas — perfil SQLite Android.** Se añadió `integration_test/screen_query_profile_test.dart`, que crea y elimina una base temporal de archivo con 50.000 movimientos y la abre con el isolate de fondo de Drift. En `Medium_Phone` perfil, la primera página de Historial bajó de 8,89 a 2,24 ms al omitir joins que no necesita la vista; el resumen bajó de 17,98 a 16,68 ms. La agregación alternativa de Estadísticas Todo se descartó porque midió 49,62 ms frente a 37,54 ms del SQL anterior. Una corrida de emulador, sin hardware físico.
- [ ] **Presupuesto y fluidez de pantallas.** Medir Presupuesto con datos equivalentes y registrar cuadros/memoria durante desplazamiento de Historial, Presupuesto y Estadísticas; aún no hay perfil de presentación con listas pobladas.
- [ ] **Catch-up de recurrencias en Android.** Repetir en perfil la carga de 50 series diarias con 180 fechas atrasadas. En SQLite in-memory del host, el lote tardó 309–315 ms frente a 328–336 ms en el baseline secuencial; la mejora observada fue pequeña y todavía no confirma un beneficio en dispositivo.
- [x] **Recordatorios — perfil comparativo en el host.** SQLite in-memory de Windows con 10.000 obligaciones, 5.000 pagos y 7.000 candidatos equivalentes: `watchAll().first` tardó 156/160/158 ms (mediana 158 ms); la consulta específica tardó 120/119/125 ms (mediana 120 ms), ~24% menos.
- [ ] **Recordatorios — perfil Android.** Repetir la conciliación con datos poblados en un dispositivo para confirmar la mejora; la medición actual es del host y no modela el costo de Android.
- [x] **Perfil baseline de creación de copia cifrada.** En Windows con `NativeDatabase.memory`, 47.400 movimientos con descripciones de 800 caracteres produjeron un payload de 46 MiB y un archivo cifrado de 61 MiB. La creación tardó 6.274 ms; RSS pasó de 342 MiB a un pico muestreado de 544 MiB (+202 MiB), con muestreo cada 20 ms. Es un perfil sintético del host, no representa Android; el pico puede subestimar asignaciones transitorias entre muestras.
- [ ] **Copias y exportaciones — completar perfil.** La creación ya lee las tablas en páginas de 500 filas y genera el envelope UTF-8 sin crear primero otro string JSON. En una ejecución por versión del perfil de Windows, el aumento de RSS bajó de 202 a 166 MiB (~18%); el tiempo pasó de 6.274 a 6.425 ms. Aún deben medirse restauración y dispositivo, y evaluarse las representaciones completas que todavía requiere el cifrado v1.
- [ ] **Dispositivo físico.** Repetir fluidez y consumo de memoria en una sesión prolongada de Android; no hay dispositivo conectado en el entorno actual.
- [ ] Generar el Android App Bundle release con firma local y comparar el tamaño de descarga por dispositivo. La compilación de perfil separada más reciente produjo APK de 62,4 MB (armeabi-v7a), 68,9 MB (arm64-v8a) y 71,9 MB (x86_64); contiene runtimes de perfil y bibliotecas nativas de OCR/código de barras, por lo que no predice el tamaño de distribución.

## Orden sugerido para retomar

1. Preparar datos de prueba reproducibles para Presupuesto y medir cuadros durante desplazamiento en las tres pantallas principales.
2. Repetir el perfil de Historial/Estadísticas en hardware Android físico y revisar la consulta de Estadísticas Todo con varias ejecuciones.
3. Medir el flujo de copias y exportaciones cerca del límite de tamaño.
4. Completar el tamaño de distribución release y resolver las compilaciones específicas de plataforma; registrar los resultados en [performance_review.md](performance_review.md).

## Entornos de compilación pendientes

- [ ] Windows: habilitar Developer Mode para symlinks e instalar en Visual Studio el workload Desktop C++ con MSVC v142, herramientas CMake y Windows 10 SDK; luego ejecutar `flutter build windows --profile`.
- [ ] Android release: configurar la firma local (`MONY_RELEASE_*` o `android/key.properties`) y ejecutar el build release.
- [ ] iOS/macOS: compilar desde macOS con Xcode instalado.
- [ ] Revisar cuando se actualicen los plugins los avisos de `cryptography_flutter`, `file_saver` y `home_widget` sobre su configuración propia de Kotlin Gradle Plugin.

## Cierre

- [x] Actualizar [performance_review.md](performance_review.md) con resultados recientes. La suite completa actual pasó 208 pruebas y `flutter analyze --no-pub` no reportó problemas; se añadieron un perfil Android de consultas de Historial/Estadísticas y la documentación de dependencias necesarias.
