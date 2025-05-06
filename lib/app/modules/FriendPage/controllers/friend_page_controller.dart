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
        // Perbaikan: Penanganan data yang lebih baik
        if (result['data'] != null && result['data']['friends'] != null) {
          friends.value =
              List<Map<String, dynamic>>.from(result['data']['friends']);
        } else if (result['data'] != null) {
          // Jika struktur data berbeda (mungkin langsung array)
          try {
            friends.value = List<Map<String, dynamic>>.from(result['data']);
          } catch (e) {
            errorMessage.value = 'Format data tidak sesuai: ${e.toString()}';
          }
        } else {
          friends.value = [];
        }
      } else {
        errorMessage.value = result['message'] ?? 'Gagal memuat daftar teman';
      }
    } catch (e) {
      // Perbaikan: Tambahkan penanganan khusus untuk error format
      if (e.toString().contains('text/html') || e.toString().contains('format yang tidak valid')) {
        errorMessage.value = 'Server sedang bermasalah. Silakan coba lagi nanti.';
      } else {
        errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mencari teman berdasarkan nama
  void searchFriends(String query) {
    if (query.isEmpty) {
      fetchFriends(); // Refresh daftar teman jika query kosong
      return;
    }

    // Filter daftar teman berdasarkan nama atau nomor telepon
    final filteredFriends = friends.where((friend) {
      final name = friend['name']?.toString().toLowerCase() ?? '';
      final phone = friend['phone']?.toString() ?? '';
      final searchLower = query.toLowerCase();

      return name.contains(searchLower) || phone.contains(query);
    }).toList();

    // Update daftar teman yang ditampilkan
    friends.value = filteredFriends;
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
