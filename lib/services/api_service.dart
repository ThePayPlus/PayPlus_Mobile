import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for the backend API
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Token storage key
  static const String tokenKey = 'auth_token';

  // Headers for API requests
  static Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // Method to set auth token in headers
  static Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    _headers['Authorization'] = 'Bearer $token';
  }

  // Method to get auth token from storage
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Method to clear auth token (for logout)
  static Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    _headers.remove('Authorization');
  }

  // Login method
  static Future<Map<String, dynamic>> login(
      String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // If login successful, store the token
        if (data['data'] != null && data['data']['token'] != null) {
          print('Token ditemukan: ${data['data']['token']}');
          await setAuthToken(data['data']['token']);
        }
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      print('Error login: ${e.toString()}');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Register method
  static Future<Map<String, dynamic>> register(
      String name, String phone, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Method to check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Metode untuk mendapatkan daftar teman
  static Future<Map<String, dynamic>> getFriends() async {
    try {
      final token = await getAuthToken();
      if (token == null) {
        return {'success': false, 'message': 'Anda belum login'};
      }

      _headers['Authorization'] = 'Bearer $token';

      final response = await http.get(
        Uri.parse('$baseUrl/friends'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memuat daftar teman'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Metode untuk menambahkan teman
  static Future<Map<String, dynamic>> addFriend(String friendPhone) async {
    try {
      final token = await getAuthToken();
      if (token == null) {
        return {'success': false, 'message': 'Anda belum login'};
      }

      _headers['Authorization'] = 'Bearer $token';

      final response = await http.post(
        Uri.parse('$baseUrl/friends/add'),
        headers: _headers,
        body: jsonEncode({
          'friendPhone': friendPhone,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal menambahkan teman'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Metode untuk logout
  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = await getAuthToken();
      if (token == null) {
        return {'success': false, 'message': 'Anda belum login'};
      }

      _headers['Authorization'] = 'Bearer $token';

      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _headers,
      );

      await clearAuthToken();

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Logout berhasil'};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Logout gagal'};
      }
    } catch (e) {
      await clearAuthToken(); // Tetap hapus token lokal meskipun ada error
      return {'success': true, 'message': 'Logout berhasil (lokal)'};
    }
  }

  // Metode untuk mendapatkan profil pengguna
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getAuthToken();
      if (token == null) {
        return {'success': false, 'message': 'Anda belum login'};
      }

      _headers['Authorization'] = 'Bearer $token';

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memuat profil'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
