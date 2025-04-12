import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Image.asset(
          'assets/images/Logo-PayPlus.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600), // max-w-2xl
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const SizedBox(height: 8),
                const Text(
                  'Account Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937), // text-gray-800
                  ),
                ),
                const SizedBox(height: 24),

                // Main Settings Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      Row(
                        children: [
                          // Circle Avatar for Profile Picture
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Profile Picture',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF111827), // text-gray-900
                                ),
                              ),
                              const SizedBox(height: 4),
                              GetX<SettingController>(
                                builder: (controller) => Text(
                                  'Member ${controller.userRole.value}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getRoleColor(
                                        controller.userRole.value),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Full Name
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151), // text-gray-700
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.fullNameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Color(0xFF6366F1)), // indigo-500
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Email
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151), // text-gray-700
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                                color: Color(0xFF6366F1)), // indigo-500
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Change Password Section Divider
                      const Divider(height: 1, thickness: 1),
                      const SizedBox(height: 24),

                      // Change Password Heading
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111827), // text-gray-900
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Current Password
                      const Text(
                        'Current Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151), // text-gray-700
                        ),
                      ),
                      const SizedBox(height: 8),
                      GetX<SettingController>(
                        builder: (controller) => TextFormField(
                          controller: controller.currentPasswordController,
                          obscureText:
                              !controller.isCurrentPasswordVisible.value,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                  color: Color(0xFF6366F1)), // indigo-500
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isCurrentPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed:
                                  controller.toggleCurrentPasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (controller
                                    .newPasswordController.text.isNotEmpty &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // New Password
                      const Text(
                        'New Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151), // text-gray-700
                        ),
                      ),
                      const SizedBox(height: 8),
                      GetX<SettingController>(
                        builder: (controller) => TextFormField(
                          controller: controller.newPasswordController,
                          obscureText: !controller.isNewPasswordVisible.value,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                  color: Color(0xFF6366F1)), // indigo-500
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isNewPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: controller.toggleNewPasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (controller.currentPasswordController.text
                                    .isNotEmpty &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter a new password';
                            }
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Confirm New Password
                      const Text(
                        'Confirm New Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151), // text-gray-700
                        ),
                      ),
                      const SizedBox(height: 8),
                      GetX<SettingController>(
                        builder: (controller) => TextFormField(
                          controller: controller.confirmPasswordController,
                          obscureText:
                              !controller.isConfirmPasswordVisible.value,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                  color: Color(0xFF6366F1)), // indigo-500
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed:
                                  controller.toggleConfirmPasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (controller
                                    .newPasswordController.text.isNotEmpty &&
                                (value == null || value.isEmpty)) {
                              return 'Please confirm your new password';
                            }
                            if (value !=
                                controller.newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Error or success message
                      GetX<SettingController>(
                        builder: (controller) =>
                            controller.errorMessage.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      controller.errorMessage.value,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: controller.isError.value
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Cancel Button
                          GetX<SettingController>(
                            builder: (controller) => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFDC2626), // bg-red-600
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Save Changes Button
                          GetX<SettingController>(
                            builder: (controller) => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF4F46E5), // bg-indigo-600
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to get color based on user role
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'gold':
        return const Color(0xFFEAB308); // text-yellow-500
      case 'silver':
        return const Color(0xFF6B7280); // text-gray-500
      case 'bronze':
        return const Color(0xFFF97316); // text-orange-500
      default:
        return Colors.black;
    }
  }
}
