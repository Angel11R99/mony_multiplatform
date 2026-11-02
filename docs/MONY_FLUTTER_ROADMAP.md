# Mony — Roadmap de migración a Flutter (Android + iOS)

**Repositorio de referencia:** https://github.com/Angel11R99/Mony  
**Objetivo:** reconstruir funcionalmente Mony en Flutter para Android e iOS, conservando la experiencia offline-first y la información local del usuario.

> Alcance basado en las funciones publicadas en el README del repositorio. Antes de cada módulo, inspeccionar el código Kotlin, sus entidades, reglas de negocio, pantallas y pruebas. La paridad exacta requiere una auditoría de código adicional.

## Principios de implementación

- Flutter y Dart, con arquitectura feature-first y separación `presentation / domain / data`.
- Persistencia local con SQLite (por ejemplo, Drift); sin cuenta ni backend obligatorio.
- Estado predecible con Riverpod o Bloc; elegir uno y mantener consistencia.
- Navegación declarativa con go_router.
- Dinero con cantidades enteras en unidades menores o tipo decimal seguro; nunca `double` para cálculos monetarios.
- Zona horaria, fechas de ciclo, redondeos, descuentos y recargos probados explícitamente.
- Accesibilidad, internacionalización, diseño adaptable, Material y Cupertino cuando corresponda.
- Migraciones de esquema, respaldo y restauración antes de manejar datos reales.
- Cada módulo termina con pruebas unitarias, de widgets y, cuando aplique, integración en Android e iOS.

## Módulos: de menor a mayor dificultad aproximada

### 01. Base Flutter y arquitectura — Baja
**Objetivo:** establecer un proyecto compilable en Android e iOS.  
**Implementar:** estructura de carpetas, configuración por entornos, enrutamiento, inyección de dependencias, manejo de errores, logging sin datos sensibles, CI y pruebas iniciales.  
**Aceptación:** ambas plataformas ejecutan la app y navegan por pantallas de ejemplo.

### 02. Apariencia y preferencias — Baja
**Implementar:** tema claro/oscuro/sistema, colores configurables, moneda inicial DOP/RD$, formato de importes, preferencias persistidas.  
**Dependencias:** 01.  
**Aceptación:** preferencias sobreviven reinicios y se ven correctamente en ambas plataformas.

### 03. Categorías personalizables — Baja
**Implementar:** alta, edición, archivado y selección de categorías de ingresos/gastos, iconos y colores; proteger referencias históricas.  
**Dependencias:** 01–02.  
**Aceptación:** categorías persistentes, validación de duplicados y comportamiento definido al archivar.

### 04. Métodos de pago — Baja
**Implementar:** catálogo de métodos, selección predeterminada, edición y uso futuro en movimientos y compras.  
**Dependencias:** 01–03.  
**Aceptación:** método predeterminado y referencias estables.

### 05. Ingresos y gastos — Media
**Implementar:** crear, editar, duplicar y eliminar movimientos; importe, fecha, categoría, método de pago y notas según el modelo original. Validaciones y transacciones de base de datos.  
**Dependencias:** 03–04.  
**Aceptación:** saldos correctos y persistencia tras reinicio; pruebas de precisión monetaria.

### 06. Historial, búsqueda y filtros — Media
**Implementar:** listado paginado, detalle, búsqueda, filtros por fecha/categoría/tipo y ordenamiento.  
**Dependencias:** 05.  
**Aceptación:** filtros combinables y resultados consistentes con datos locales.

### 07. Dashboard financiero — Media
**Implementar:** resumen de ingresos, gastos, balance, movimientos recientes y accesos rápidos.  
**Dependencias:** 05–06.  
**Aceptación:** indicadores actualizados después de cualquier cambio de movimiento.

### 08. Metas de ahorro — Media
**Implementar:** crear metas, objetivos monetarios, progreso y seguimiento; definir explícitamente cómo se registran aportes y retiros según el código original.  
**Dependencias:** 05.  
**Aceptación:** progreso correcto sin contabilización duplicada.

### 09. Presupuestos por mes o ciclo — Media-alta
**Implementar:** límites, períodos, asignaciones por categoría, consumo y saldo disponible, cierre manual/automático.  
**Dependencias:** 03, 05, 07.  
**Aceptación:** límites de período, cambios de mes y cierres probados.

### 10. Estadísticas financieras — Media-alta
**Implementar:** gráficos por período y categoría, comparaciones de ingresos/gastos, evolución y alertas visuales de límites.  
**Dependencias:** 05, 09.  
**Aceptación:** agregaciones verificadas contra consultas de base de datos.

### 11. Listas de compras — Media-alta
**Implementar:** listas, productos, cantidades, precios, descuentos, recargos, subtotales, totales y métodos de pago. Vincular movimientos solo si el modelo original lo requiere.  
**Dependencias:** 04–05.  
**Aceptación:** totales exactos con combinaciones de descuentos y recargos.

### 12. Pagos y cobros pendientes — Media-alta
**Implementar:** obligaciones, vencimientos, estados, abonos y liquidación; reglas para su impacto en movimientos.  
**Dependencias:** 05.  
**Aceptación:** no se duplican pagos ni se alteran saldos indebidamente.

### 13. Movimientos recurrentes — Alta
**Implementar:** reglas de repetición, próxima ejecución, pausas, edición de serie, generación idempotente y recuperación tras días sin abrir la app.  
**Dependencias:** 05, 12.  
**Aceptación:** sin duplicados al reiniciar o cruzar cambios de mes y horario.

### 14. Recordatorios y notificaciones — Alta
**Implementar:** permisos, programación local, avisos de vencimientos y recurrencias, cancelación y reprogramación. Revisar limitaciones de ejecución en segundo plano de iOS y Android.  
**Dependencias:** 12–13.  
**Aceptación:** notificaciones verificadas en dispositivos reales; funcionamiento degradado documentado cuando el SO restringe tareas.

### 15. Exportación de datos — Alta
**Implementar:** PDF, XLSX y CSV, rangos de fechas, selección de información, compartir/guardar archivos y manejo seguro de permisos.  
**Dependencias:** 06, 09–12.  
**Aceptación:** archivos válidos, cifras correctas, UTF-8 y compatibilidad con Excel.

### 16. Códigos de barras — Alta
**Implementar:** cámara, permisos, lectura, entrada manual, consulta opcional de productos por internet y caché local.  
**Dependencias:** 11.  
**Aceptación:** lectura estable en Android/iOS y uso manual sin conexión.

### 17. Escaneo de tickets y OCR — Muy alta
**Implementar:** captura/importación de imágenes, OCR en dispositivo cuando sea viable, extracción de comercio, fecha, conceptos y totales, revisión manual y prevención de registros duplicados.  
**Dependencias:** 05, 11, 16.  
**Aceptación:** el usuario confirma los datos antes de guardar; pruebas con tickets reales y formatos variados.

### 18. Widgets de inicio — Muy alta
**Implementar:** inventario y réplica de los 11 widgets mencionados por Mony, priorizando los más útiles. Integración Flutter con Android App Widgets y iOS WidgetKit mediante código nativo y datos compartidos.  
**Dependencias:** 07, 09–14.  
**Aceptación:** actualizaciones confiables dentro de los límites del sistema, privacidad en pantalla bloqueada y acciones rápidas probadas.

### 19. Calidad, seguridad y publicación — Alta (transversal)
**Implementar:** pruebas de regresión, migraciones de esquema, copias de seguridad/restauración, accesibilidad, rendimiento, cifrado o protección adecuada de datos, políticas de privacidad, firma, TestFlight y Play Console.  
**Dependencias:** todos los módulos.  
**Aceptación:** builds release firmadas, sin pérdida de datos y checklist de tiendas completo.

## Hitos sugeridos

| Hito | Módulos | Resultado |
|---|---|---|
| MVP 1 | 01–07 | App usable para registrar y consultar finanzas |
| MVP 2 | 08–11 | Ahorro, presupuestos, analítica y compras |
| Beta | 12–15 | Obligaciones, automatización y exportaciones |
| Avanzado | 16–18 | Escaneo y widgets multiplataforma |
| Release | 19 + regresión | Distribución Android/iOS |

## Auditoría del repositorio antes de programar

1. Enumerar pantallas, rutas, entidades Room, DAO, repositorios, casos de uso, ViewModels y widgets de Android.
2. Crear una matriz **función original → pantalla Flutter → entidad local → pruebas**.
3. Verificar fórmulas de presupuestos, ciclos, saldos, listas y recurrencias con pruebas de caracterización del código Kotlin.
4. Identificar diferencias de plataforma: widgets, tareas en segundo plano, notificaciones, cámara, OCR, exportación y permisos.
5. Decidir si se requiere importar datos existentes desde la app Android original. No asumir que Flutter puede leer automáticamente la base de datos privada de otra aplicación.
6. Revisar la licencia antes de reutilizar o redistribuir código y recursos: el README señala restricciones para derivados y uso comercial.

## Definición de terminado para cada módulo

- Funcionalidad y reglas de negocio documentadas.
- Persistencia y estados vacíos/error cubiertos.
- UI responsive, accesible y coherente en Android/iOS.
- Pruebas unitarias y de widgets; integración cuando corresponda.
- Sin regresiones en módulos previos.
- Actualización de README y registro de decisiones técnicas.

## Referencia

- [Repositorio Mony](https://github.com/Angel11R99/Mony) — README público consultado el 2 de noviembre de 2026.
