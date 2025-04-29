import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payplus_mobile/services/api_service.dart';

class FriendPageController extends GetxController {
  final searchController = TextEditingController();
  final friends = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriends();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchFriends() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await ApiService.getFriends();

      if (result['success']) {
        friends.value =
            List<Map<String, dynamic>>.from(result['data']['friends'] ?? []);
      } else {
        errorMessage.value = result['message'] ?? 'Gagal memuat daftar teman';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mencari teman berdasarkan nama
  void searchFriends(String query) {
    // Implementasi pencarian akan ditambahkan nanti
  }

  // Fungsi untuk menambahkan teman baru
  Future<bool> addFriend(String phoneNumber) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await ApiService.addFriend(phoneNumber);

      if (result['success']) {
        await fetchFriends(); // Refresh daftar teman
        return true;
      } else {
        errorMessage.value = result['message'] ?? 'Gagal menambahkan teman';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
