import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for the backend API
  static const String baseUrl = 'https://localhost:3000/api';

  // Token storage key
  static const String tokenKey = 'auth_token';

  // Headers for API requests
  static final Map<String, String> _headers = {
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

  // Initialize auth token from storage
  static Future<void> initializeAuth() async {
    final token = await getAuthToken();
    if (token != null && token.isNotEmpty) {
      _headers['Authorization'] = 'Bearer $token';
    }
  }

  // Ensure headers have auth token
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getAuthToken();
    if (token != null && token.isNotEmpty) {
      _headers['Authorization'] = 'Bearer $token';
    }
    return _headers;
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
      if (response.statusCode == 200) {
        // If login successful, store the token
        if (data['token'] != null) {
          await setAuthToken(data['token']);
        }
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
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
          'message': data['message'] ?? 'Registration failed'
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

  // Get friends list
  static Future<Map<String, dynamic>> getFriends() async {
    try {
      // Pastikan token sudah ada
      final token = await getAuthToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Anda belum login'};
      }

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

  // Add friend by phone number
  static Future<Map<String, dynamic>> addFriend(String phoneNumber) async {
    try {
      // Pastikan token sudah ada
      final token = await getAuthToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Anda belum login'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/friends/add'),
        headers: _headers,
        body: jsonEncode({
          'phone': phoneNumber,
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

  // Profile methods

  // Get profile data
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      // Check if token exists
      final token = await getAuthToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Authentication required'};
      }

      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Ensure phone is a string
        final processedData = {
          'phone': data['phone'].toString(),
          'name': data['name'],
          'email': data['email'],
          'balance': data['balance'],
        };

        return {'success': true, 'data': processedData};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load profile'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Update profile (name and email only)
  static Future<Map<String, dynamic>> updateProfile(
      String name, String email) async {
    try {
      // Check if token exists
      final token = await getAuthToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Authentication required'};
      }

      final headers = await _getAuthHeaders();

      final response = await http.patch(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update profile'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Change password
  static Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      // Check if token exists
      final token = await getAuthToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Authentication required'};
      }

      final headers = await _getAuthHeaders();

      final response = await http.patch(
        Uri.parse('$baseUrl/change-password'),
        headers: headers,
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password changed successfully'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to change password'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Get income records
  static Future<Map<String, dynamic>> getIncomeRecords() async {
    try {
      // Check if token exists
      final token = await getAuthToken();
      if (token == null || token.isEmpty) {
        return {'success': false, 'message': 'Authentication required'};
      }

      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/income-record'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Data pemasukan berhasil diambil',
          'records': data['records'] ?? []
        };
      } else {
        Map<String, dynamic> data = {};
        try {
          data = jsonDecode(response.body);
        } catch (e) {
          // Jika response body tidak bisa di-decode sebagai JSON
        }

        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengambil data pemasukan'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
