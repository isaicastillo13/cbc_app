import 'package:flutter/material.dart';
import 'package:cbc_app/core/constants.dart';
import 'package:cbc_app/utils/colors.dart';
import 'package:cbc_app/core/config/routes/routes.dart';



class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Color de fondo
      body: Padding(
        padding: const EdgeInsets.all(16),
        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 16),

              // Logo alineado a la izquierda
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/img/logoGrupoRey.png',
                  width: wLogo,
                  height: hLogo,
                  fit: BoxFit.fill,
                ),
              ),

              // Texto de bienvenida
              Column(
                children: [
                  _buildWelcomeText(),
                  const SizedBox(height: 64),
                  _buildButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget que muestra el texto de bienvenida
  Widget _buildWelcomeText() {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 48,
              color: textColor,
            ),
            children: [
              TextSpan(text: 'CONSULTA TUS '),
              TextSpan(
                text: 'BENEFICIOS ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: 'SIN ESFUERZO'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'En Grupo Rey estamos comprometidos con mejorar la calidad de vida de nuestros colaboradores ofreciendo no solo los mejores productos, sino también beneficios que ayuden a mejorar su calidad de vida.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: textMedium,
            color: textColor,
          ),
        ),
      ],
    );
  }

  /// Widget que construye los botones
  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        _buildButton(
          text: 'Regístrame en CBC APP',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
          isPrimary: true,
        ),
        const SizedBox(height: 16),
        _buildButton(
          text: '¿Ya tienes cuenta en CBC APP? Iniciar sesión',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
          isPrimary: false,
        ),
      ],
    );
  }

  /// Método para construir botones reutilizables
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return isPrimary
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              foregroundColor: textColor, // Color del texto
              backgroundColor: secondaryColor, // Color de fondo
              minimumSize: const Size(double.infinity, 48), // Botón ancho
            ),
            child: Text(text),
          )
        : TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: textColor,
              // 🔥 Agrega cursor de mano
              
            ),
            child: Text(text),
          );
  }
}
