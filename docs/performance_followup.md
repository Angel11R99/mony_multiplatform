# Pendientes para continuar el refactor de rendimiento

Este archivo conserva trabajo que requiere otra sesión o un entorno distinto. Los cambios implementados están resumidos en [performance_review.md](performance_review.md).

## Siguiente sesión

- [x] **Auditar inicialización de fechas del arranque.** En isolates limpios del host, `intl` registró 120 locales en 6,74 ms y Flutter localizations 98 en 5,14 ms. La diferencia es pequeña y no mide primer cuadro; se conserva el bootstrap y queda pendiente medirlo en dispositivo.
- [ ] **Navbar Sumi-e — verificación visual pendiente.** El código ya aumenta el icono activo a 42 px y reduce su elevación a 0,039 px. La captura más reciente del usuario aún muestra un cuadro rojo en Historial; no se encontró un badge rojo en el código del navbar y hace falta capturar la app en el AVD para localizar la capa que lo dibuja y confirmar el aspecto final.
- [x] Ejecutar `flutter test --no-pub` completo después del lote de catch-up recurrente. Resultado: 203 pruebas pasaron; `flutter analyze --no-pub` también pasó con Flutter 3.44.4 / Dart 3.12.2. Para regenerar el hook de `objective_c` con ese SDK se resolvieron temporalmente cinco dependencias transitivas a versiones compatibles con Dart 3.12.2 y se restauró `pubspec.lock`; repetir con la resolución bloqueada de Dart 3.13.7 queda pendiente.
- [x] **Historial y Estadísticas — perfil SQLite Android.** Se añadió `integration_test/screen_query_profile_test.dart`, que crea y elimina una base temporal de archivo con 50.000 movimientos y la abre con el isolate de fondo de Drift. En `Medium_Phone` perfil, la primera página de Historial bajó de 8,89 a 2,24 ms al omitir joins que no necesita la vista; el resumen bajó de 17,98 a 16,68 ms. La agregación alternativa de Estadísticas Todo se descartó porque midió 49,62 ms frente a 37,54 ms del SQL anterior. Una corrida de emulador, sin hardware físico.
- [x] **Presupuesto — perfil de agregación SQLite en Android.** Con 50.000 movimientos en SQLite de archivo y el isolate de Drift, la consulta por período/categoría tardó 15,59 ms frente a 257,79 ms al materializar el historial completo y filtrarlo en Dart (~94% menos); los totales y grupos de categoría coincidieron. Una corrida en AVD.
- [x] **Desplazamiento de pantallas en Android AVD.** Dos perfiles de Historial, Presupuesto y Estadísticas con `MonyTheme` de producción y datos poblados: menos de 1 ms de build medio por pantalla; 40/1.327 cuadros superaron 16 ms en rasterizado (3,0%), con variación alta entre corridas. El monitor de integración registró GC y cachés de pintura, pero no RSS ni heap máximo.
- [ ] **Fluidez y memoria en hardware físico.** Repetir los perfiles y medir RSS/heap máximo en Android físico; no hay dispositivo físico conectado en este entorno.
- [x] **Catch-up de recurrencias en Android AVD.** En SQLite de archivo con 50.000 movimientos, 50 series diarias × 180 días (9.000 movimientos) bajaron de 2.184 ms a 292 ms de mediana (~87%) al agrupar la consulta de duplicados y las actualizaciones por series. Una corrida por versión; solo emulador. Se conserva pendiente repetir en hardware físico.
- [x] **Recordatorios — perfil comparativo en el host.** SQLite in-memory de Windows con 10.000 obligaciones, 5.000 pagos y 7.000 candidatos equivalentes: `watchAll().first` tardó 156/160/158 ms (mediana 158 ms); la consulta específica tardó 120/119/125 ms (mediana 120 ms), ~24% menos.
- [x] **Recordatorios — perfil Android AVD.** Con 10.000 obligaciones y 5.000 abonos, la consulta específica tardó 31,64 ms frente a 843,31 ms al materializar todas las obligaciones y filtrar en Dart (~96% menos); ambas rutas dieron los mismos 7.000 candidatos. Mediana de cinco muestras tras calentamiento; falta repetir en hardware físico.
- [x] **Perfil baseline de creación de copia cifrada.** En Windows con `NativeDatabase.memory`, 47.400 movimientos con descripciones de 800 caracteres produjeron un payload de 46 MiB y un archivo cifrado de 61 MiB. La creación tardó 6.274 ms; RSS pasó de 342 MiB a un pico muestreado de 544 MiB (+202 MiB), con muestreo cada 20 ms. Es un perfil sintético del host, no representa Android; el pico puede subestimar asignaciones transitorias entre muestras.
- [x] **Copia cifrada — round-trip Android AVD.** Con 104.001 movimientos, 10.000 obligaciones y 5.000 abonos: 37,4 MiB; creación 12.547 ms y restauración 10.682 ms. Conteos y claves foráneas se conservaron. El muestreo del proceso durante 120 s registró picos de 468,7 MiB PSS y 553,1 MiB RSS cada ~1,2 s; cubre todo el harness y puede perder máximos transitorios. Una corrida en AVD.
- [ ] **Copias y exportaciones — completar perfil físico y memoria aislada.** En Windows el aumento de RSS bajó de 202 a 166 MiB (~18%) al paginar la lectura; el tiempo pasó de 6.274 a 6.425 ms. En AVD, el pico RSS/PSS no se atribuyó a la etapa exacta y la muestra puede perder picos breves. Repetir restauración y perfil de memoria con hardware físico.
- [ ] **Dispositivo físico.** Repetir fluidez y consumo de memoria en una sesión prolongada de Android; no hay dispositivo conectado en el entorno actual.
- [ ] Generar el Android App Bundle release con firma local y comparar el tamaño de descarga por dispositivo. La compilación de perfil separada más reciente produjo APK de 62,4 MB (armeabi-v7a), 68,9 MB (arm64-v8a) y 71,9 MB (x86_64); contiene runtimes de perfil y bibliotecas nativas de OCR/código de barras, por lo que no predice el tamaño de distribución.

## Orden sugerido para retomar

1. Repetir en Android físico los perfiles de desplazamiento, consultas y catch-up, y medir RSS/heap en las etapas de mayor carga.
2. Revisar Estadísticas Todo con varias ejecuciones y perfilar copias/exportaciones cerca del límite de tamaño.
3. Verificar visualmente en el AVD el cuadrito rojo del navbar japonés que aún muestra la captura del usuario.
4. Completar el tamaño de distribución release y resolver las compilaciones específicas de plataforma; registrar los resultados en [performance_review.md](performance_review.md).

## Entornos de compilación pendientes

- [ ] Windows: habilitar Developer Mode para symlinks e instalar en Visual Studio el workload Desktop C++ con MSVC v142, herramientas CMake y Windows 10 SDK; luego ejecutar `flutter build windows --profile`.
- [ ] Android release: configurar la firma local (`MONY_RELEASE_*` o `android/key.properties`) y ejecutar el build release.
- [ ] iOS/macOS: compilar desde macOS con Xcode instalado.
- [ ] Revisar cuando se actualicen los plugins los avisos de `cryptography_flutter`, `file_saver` y `home_widget` sobre su configuración propia de Kotlin Gradle Plugin.

## Cierre

- [x] Actualizar [performance_review.md](performance_review.md) con resultados recientes. La suite completa actual pasó 209 pruebas y `flutter analyze --no-pub` no reportó problemas; el perfil Android cubre consultas de Historial, Estadísticas, Presupuesto y catch-up recurrente.
