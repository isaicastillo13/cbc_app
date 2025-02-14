import 'package:flutter/material.dart';

// Definir colores personalizados
const Color primaryColor = Color(0xFFEB3D43);
const Color secondaryColor = Color(0xFF474747);
const Color backgroundColor = Color(0xFFF4F4F4);
const Color textColor = Color(0xFFF6F6F6); 
// Si quieres definir MaterialColor para usar en ThemeData
const MaterialColor customPrimarySwatch = MaterialColor(
  0xFFEB3D43,
  <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFEB3D43), // Color principal
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  },
);
