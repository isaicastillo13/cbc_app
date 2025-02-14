import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class AuthRepository {
  final String baseUrl = 'https://web.smrey.net:447/api';

    /// 🔹 Variables globales
  String usr = '';
  String key = '';

  String user = '';
  String password = '';

  

  /// 🔥 Método para obtener credenciales desde archivos remotos
  /// 🔥 Leer archivos locales en `assets`
  Future<void> fetchCredentials(String user, String pass) async {
    try {
      // Leer los archivos locales
      final userContent = await rootBundle.loadString('assets/user.txt');
      final keyContent = await rootBundle.loadString('assets/key.txt');

      // Eliminar espacios en blanco y asignar valores
      usr = userContent.trim();
      key = keyContent.trim();

      user = user;
      password = pass;

      // Ahora puedes usarlos para autenticarte
       await authenticate(user, password);
    } catch (error) {
      // print('Error al leer archivos: $error');
    }
  }

  /// 🔹 Método para autenticar y obtener un token
  Future<String?> authenticate(String user, String pass) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"Username": user, "Password": pass}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await validarUsuario(data['detail']['token'], user, pass);
        // return data['detail']['token']; // 🔥 Devuelve el token
      } else {
        throw Exception("Error en la autenticación: ${response.body}");
      }
    } catch (e) {
      // print('Error en authenticate: $e');
      return null;
    }
    return null;
  }

  /// 🔹 Método para validar usuario con token
  Future<Map<String, dynamic>?> validarUsuario(String token, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ValidateUser'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"userName": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 0) {
          // Guardamos datos en SharedPreferences en lugar de sessionStorage
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("num_Empleado", data['detail']['employeeid']);
          await prefs.setBool("is_Active", data['detail']['isActive']);
          await prefs.setString("sistemas", jsonEncode(data['detail']['systems']));
          await prefs.setString("usr", username);
          await prefs.setString("code", password);
          await prefs.setBool("is_validated", true);
          return data;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      // print("Error en validarUsuario: $e");
      return null;
    }
  }

  /// 🔹 Obtener perfiles del usuario
  Future<void> obtenerPerfiles(String username, String token) async {
    try {
      final response = await http.post(
        Uri.parse("https://revista.smrey.net:472/InfoForm.svc/getuserprofile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Basic $token"
        },
        body: jsonEncode({"PuserName": username}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("profile_id", data[0]['Pid']);

          // Redirección basada en la URL previa
          String? lastUrl = prefs.getString("lasturl");
          if (lastUrl != null) {
            prefs.remove("lasturl");
            // Aquí manejar la redirección con Navigator.pushNamed()
          } else {
            // Redirigir al home
          }
        }
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      // print("Error al obtener perfiles: $e");
    }
  }
}