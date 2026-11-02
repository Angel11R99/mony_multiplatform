const financeColorNames = <int, String>{
  0xFFEF4444: 'rojo',
  0xFFEC4899: 'rosa',
  0xFF9333EA: 'morado',
  0xFF7C3AED: 'violeta',
  0xFF3B82F6: 'azul',
  0xFF0891B2: 'cian',
  0xFF0D9488: 'turquesa',
  0xFF16A34A: 'verde',
  0xFFEAB308: 'amarillo',
  0xFFD97706: 'ámbar',
  0xFFEA580C: 'naranja',
  0xFF71717A: 'gris',
};

String financeColorName(int colorArgb) =>
    financeColorNames[colorArgb] ?? 'personalizado';
