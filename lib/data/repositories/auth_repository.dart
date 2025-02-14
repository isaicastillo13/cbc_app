import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class AuthRepository {
  final String baseUrl = 'https://web.smrey.net:447/api';

  /// 🔹 Variables globales
  String usr = '';
  String key = '';

  String username = '';
  String password = '';
  int dataCode = 0;
  // String token = '';

  /// 🔥 Método para obtener credenciales desde archivos remotos y validar usuario
  Future<Map<String, dynamic>?> fetchCredentials(String user, String pass) async {
  try {
    // Leer los archivos locales
    final userContent = await rootBundle.loadString('assets/user.txt');
    final keyContent = await rootBundle.loadString('assets/key.txt');

    usr = userContent.trim();
    key = keyContent.trim();

    username = user;
    password = pass;

    // 🔥 Ahora `authenticate` devuelve `data`, no solo el token
    final data = await authenticate(usr, key);

    return data; // 🔥 Devuelve la data completa después de validar el usuario
  } catch (error) {
    throw Exception('Error al leer archivos: $error');
  }
}


  /// 🔹 Método para autenticar y obtener un token
  Future<Map<String, dynamic>?> authenticate(String usr, String key) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/authenticate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"Username": usr, "Password": key}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['detail']['token']; // Guardar token

      // 🔹 Asegurarse de esperar la validación antes de continuar
      return await validarUsuario(token); // 🔥 Ahora authenticate devuelve la data validada
    } else {
      throw Exception("Error en la autenticación: ${response.body}");
    }
  } catch (e) {
    return null;
  }
}


  /// 🔹 Método para validar usuario con token
  Future<Map<String, dynamic>?> validarUsuario(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ValidateUser'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"userName": username, "password": password}),
      );
        print(response.body);
        final responseData = jsonDecode(response.body);
        dataCode = responseData['code'] as int;


      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['code'] == 0) {
          // Guardamos datos en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("num_Empleado", data['detail']['employeeid']);
          await prefs.setBool("is_Active", data['detail']['isActive']);
          await prefs.setString("sistemas", jsonEncode(data['detail']['systems']));
          await prefs.setString("usr", username);
          await prefs.setString("code", password);
          await prefs.setBool("is_validated", true);
          await obtenerPerfiles(username, token); // 🔥 Obtener perfiles
        }
        
        return null; // 🔥 Devuelve la data completa
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      return null;
    }
  }

  /// 🔹 Obtener perfiles del usuario
  Future<void> obtenerPerfiles(String username, token) async {
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
        }
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("Error al obtener perfiles: $e");
    }
  }
}
