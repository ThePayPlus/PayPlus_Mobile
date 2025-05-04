import 'package:payplus_mobile/services/api_service.dart';

class SettingsService {
  // Get profile data
  static Future<Map<String, dynamic>> getProfileData() async {
    try {
      final result = await ApiService.getProfile();

      // Additional safety check for data types
      if (result['success'] && result['data'] != null) {
        final data = result['data'];

        // Ensure phone is a string
        if (data['phone'] != null) {
          data['phone'] = data['phone'].toString();
        }
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Error getting profile: ${e.toString()}'
      };
    }
  }

  // Update profile without password change
  static Future<Map<String, dynamic>> updateProfile(
      String name, String email) async {
    try {
      return await ApiService.updateProfile(name, email);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating profile: ${e.toString()}'
      };
    }
  }

  // Change password
  static Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      return await ApiService.changePassword(oldPassword, newPassword);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error changing password: ${e.toString()}'
      };
    }
  }

  // Handle full profile update (optionally including password)
  static Future<Map<String, dynamic>> updateSettings(
      {required String name,
      required String email,
      String? currentPassword,
      String? newPassword}) async {
    try {
      // First update the profile info
      final profileResult = await updateProfile(name, email);

      // If profile update failed, return error
      if (!profileResult['success']) {
        return profileResult;
      }

      // If password fields are provided, update password too
      if (currentPassword != null &&
          newPassword != null &&
          currentPassword.isNotEmpty &&
          newPassword.isNotEmpty) {
        final passwordResult =
            await changePassword(currentPassword, newPassword);

        // If password update succeeded
        if (passwordResult['success']) {
          return {
            'success': true,
            'message': 'Profile and password updated successfully',
            'data': profileResult['data']
          };
        } else {
          // Password update failed
          return passwordResult;
        }
      }

      // Only profile was updated
      return {
        'success': true,
        'message': 'Profile updated successfully',
        'data': profileResult['data']
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating settings: ${e.toString()}'
      };
    }
  }
}
