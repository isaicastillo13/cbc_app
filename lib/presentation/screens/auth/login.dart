import 'package:flutter/material.dart';
import 'package:cbc_app/core/constants.dart';
import 'package:cbc_app/utils/colors.dart';
import 'package:cbc_app/core/config/routes/routes.dart';
import 'package:cbc_app/data/repositories/auth_repository.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  Future <void> _login() async {
   final user = _userController.text;
    final password = _passwordController.text;
    await _authRepository.fetchCredentials(user, password);
    int code = _authRepository.dataCode;

    if (code == 0) {

      // Aquí puedes manejar la respuesta del login
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso')),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/img/logoGrupoRey.png',
                  width: wLogo,
                  height: hLogo,
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _buildWelcomeText(),
              ),
              Align(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _builduserField(),
                      const SizedBox(height: 16.0),
                      _buildPasswordField(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _buildButtons(context),
              ),
            ],
          ),

        ),
      ),
    );
  }

  /// Texto de bienvenida
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
              TextSpan(
                text: 'Iniciar Sesión',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Ingresa tu correo y contraseña para acceder a CBC APP',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: textLarge,
            color: textColor,
          ),
        ),
      ],
    );
  }

  /// Campo de user con validación
  Widget _builduserField() {
    return TextFormField(
      controller: _userController,
      style: const TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: 'user',
        labelStyle: const TextStyle(color: textColor),
        enabledBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: textColor),
          borderRadius: BorderRadius.circular(100),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color:textColor),
          borderRadius: BorderRadius.circular(100),
        ),
        prefixIcon: const Icon(Icons.person, color: textColor),
      ),
      // keyboardType: TextInputType.emailAddress,
      
    );
  }

  /// Campo de Contraseña con validación
  Widget _buildPasswordField() {
    bool _obscureText = true;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return TextFormField(
          controller: _passwordController,
      style: const TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: const TextStyle(color: textColor),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: textColor),
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: textColor),
              borderRadius: BorderRadius.circular(100),
            ),
            prefixIcon: const Icon(Icons.lock, color: textColor),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: textColor,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          obscureText: _obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingresa tu contraseña';
            } else if (value.length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            }
            return null;
          },
        );
      },
    );
  }

  /// Botones de acción (Login + Registro)
  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        _buildButton(
          text: 'Iniciar Sesión',
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Aquí puedes manejar el inicio de sesión
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Iniciando sesión...')),
              );

              await _login();
            }
          },
          isPrimary: true,
        ),
        const SizedBox(height: 16),
        _buildButton(
          text: '¿No tienes cuenta? Regístrate',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
          isPrimary: false,
        ),
      ],
    );
  }

  /// Botón reutilizable con efecto de presionado
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(textColor),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.pressed)) {
                      return secondaryColor.withOpacity(0.8);
                    }
                    return secondaryColor;
                  },
                ),
                minimumSize:
                    WidgetStateProperty.all(const Size(double.infinity, 48)),
              ),
              child: Text(text),
            )
          : TextButton(
              onPressed: onPressed,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.pressed)) {
                      return textColor.withOpacity(0.6);
                    }
                    return textColor;
                  },
                ),
              ),
              child: Text(text),
            ),
    );
  }
}
