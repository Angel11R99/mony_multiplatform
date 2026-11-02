# P07 — Home Dashboard financiero

## Jerarquía de contenido
1. Header compacto Mony + acciones justificadas (ajustes/perfil si existen).
2. Balance total con moneda visible y fecha de actualización válida.
3. Dos indicadores: Ingresos y Gastos del período seleccionado.
4. Resumen gráfico simple y/o tendencia solo cuando el origen de datos sea fiable.
5. Movimientos recientes (3–5) + «Ver todos».
6. Acciones rápidas «Añadir ingreso» y «Añadir gasto», vinculadas a flujos reales.

## Precisión
Especificar fórmula de balance en función de los modelos existentes, ámbito de cuentas, transferencias y saldo inicial. **No sumar entradas duplicadas, no mezclar monedas sin tipo de cambio**. Si hay múltiples monedas y no hay conversión confiable, presentar agrupación por moneda en lugar de total agregado incorrecto.

## Estados
Primera instalación: empty state con CTA, no cifras falsas. Loading con tamaño estable. Error con Retry y causa útil sin revelar información. Datos parciales con señales claras. Pull-to-refresh solo si hay necesidad real; no inflar interfaz.

## Aceptación
- [ ] AC-07-1: balance y sumas validados con fixtures deterministas.
- [ ] AC-07-2: cero registros = estado vacío sin valores demostrativos engañosos.
- [ ] AC-07-3: action CTA navega al formulario verdadero.
- [ ] AC-07-4: datos sincronizados tras crear/editar/eliminar movimiento.
- [ ] AC-07-5: offline, loading, error y contenido largo probados.
