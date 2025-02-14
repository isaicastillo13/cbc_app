import 'package:flutter/material.dart';
import 'package:cbc_app/core/config/routes/routes.dart';
import 'package:cbc_app/presentation/screens/welcome/welcome_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.welcome, // Ruta inicial
      routes: AppRoutes.getRoutes(), // Usa las rutas desde routes.dart
      theme: ThemeData(
        useMaterial3: true,
      ),
        home: const WelcomePage() 
    );
  }
}
