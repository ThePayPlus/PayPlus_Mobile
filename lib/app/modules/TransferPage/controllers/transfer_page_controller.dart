import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payplus_mobile/services/api_service.dart';

class TransferPageController extends GetxController {
  final searchController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  
  final RxString selectedUser = ''.obs;
  final RxString selectedUserPhone = ''.obs;
  final RxString transferType = 'Normal'.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> friends = <Map<String, dynamic>>[].obs;
  final RxInt transferMethod = 0.obs; // 0 = nomor telepon, 1 = daftar teman
  final RxString currentUserPhone = ''.obs; // Tambahkan variabel untuk menyimpan nomor telepon pengguna saat ini
  
  final List<String> transferTypes = ['Normal', 'Gift'];
  
  @override
  void onInit() {
    super.onInit();
    // Muat daftar teman saat controller diinisialisasi
    fetchFriends();
    // Ambil data profil pengguna saat ini
    getCurrentUserProfile();
  }
  
  // Fungsi untuk mengambil profil pengguna saat ini
  Future<void> getCurrentUserProfile() async {
    try {
      final result = await ApiService.getProfile();
      if (result['success'] && result['data'] != null) {
        currentUserPhone.value = result['data']['phone']?.toString() ?? '';
      }
    } catch (e) {
      print('Error mengambil profil pengguna: ${e.toString()}');
    }
  }
  
  // Fungsi untuk mengambil daftar teman dari API
  Future<void> fetchFriends() async {
    isLoading.value = true;
    try {
      final result = await ApiService.getFriends();
      if (result['success']) {
        if (result['data'] != null && result['data']['friends'] != null) {
          friends.value = List<Map<String, dynamic>>.from(result['data']['friends']);
        } else {
          friends.clear();
        }
      } else {
        Get.snackbar(
          'Error', 
          result['message'] ?? 'Gagal memuat daftar teman',
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fungsi untuk memilih teman dari daftar
  void selectFriend(Map<String, dynamic> friend) {
    // Cek apakah nomor telepon teman sama dengan nomor telepon pengguna saat ini
    if (friend['phone'].toString() == currentUserPhone.value) {
      Get.snackbar(
        'Error', 
        'Anda tidak dapat melakukan transfer ke diri sendiri',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
      return;
    }
    
    selectedUser.value = 'User: ${friend['name']}';
    selectedUserPhone.value = friend['phone'].toString();
    
    Get.snackbar(
      'Sukses', 
      'Pengguna dipilih: ${friend['name']}',
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white
    );
  }
  
  Future<void> searchUser() async {
    if (searchController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Silakan masukkan nama atau nomor telepon',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
      return;
    }
    
    isLoading.value = true;
    try {
      final result = await ApiService.searchUser(searchController.text);
      if (result['success']) {
        // Periksa jika respons bukan JSON
        if (result['data'] != null) { 
          // Coba parse data users dari respons
          try {
            if (result['data']['name'] != null) {
              // Cek apakah pengguna mencari dirinya sendiri
              if (result['data']['phone'].toString() == currentUserPhone.value) {
                Get.snackbar(
                  'Error', 
                  'Anda tidak dapat melakukan transfer ke diri sendiri',
                  backgroundColor: Colors.red.withOpacity(0.7),
                  colorText: Colors.white
                );
                return;
              }
              
              selectedUser.value = 'User: ${result['data']['name']}';
              selectedUserPhone.value = result['data']['phone'].toString();
              
              Get.snackbar(
                'Sukses', 
                'Pengguna ditemukan!',
                backgroundColor: Colors.green.withOpacity(0.7),
                colorText: Colors.white
              );
            } else {
              Get.snackbar(
                'Info', 
                'Tidak ada pengguna yang ditemukan',
                backgroundColor: Colors.orange.withOpacity(0.7),
                colorText: Colors.white
              );
            }
          } catch (e) {
            Get.snackbar(
              'Error', 
              'Format data tidak valid: ${e.toString()}',
              backgroundColor: Colors.red.withOpacity(0.7),
              colorText: Colors.white
            );
          }
        } else {
          Get.snackbar(
            'Info', 
            'Tidak ada data yang ditemukan',
            backgroundColor: Colors.orange.withOpacity(0.7),
            colorText: Colors.white
          );
        }
      } else {
        Get.snackbar(
          'Error', 
          result['message'] ?? 'Gagal mencari pengguna',
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> sendTransfer() async {
    // Validasi input
    if (selectedUserPhone.value.isEmpty) {
      Get.snackbar(
        'Error', 
        'Silakan cari dan pilih penerima',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
      return;
    }
    
    // Validasi transfer ke diri sendiri
    if (selectedUserPhone.value == currentUserPhone.value) {
      Get.snackbar(
        'Error', 
        'Anda tidak dapat melakukan transfer ke diri sendiri',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
      return;
    }
    
    if (amountController.text.isEmpty) {
      Get.snackbar(
        'Error', 
        'Silakan masukkan jumlah',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
      return;
    }
    
    int amount;
    try {
      amount = int.parse(amountController.text);
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Jumlah harus berupa angka',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
      return;
    }
    
    isLoading.value = true;
    try {
      // Panggil API untuk transfer
      final result = await ApiService.transferMoney(
        selectedUserPhone.value,
        amount,
        transferType.value,
        transferType.value == 'Gift' ? notesController.text : null
      );
      
      if (result['success']) {
        Get.snackbar(
          'Sukses', 
          'Transfer sebesar ${amountController.text} berhasil dikirim ke ${selectedUser.value}',
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white
        );
        
        // Reset field setelah transfer berhasil
        searchController.clear();
        amountController.clear();
        notesController.clear();
        selectedUser.value = '';
        selectedUserPhone.value = '';
        searchResults.clear();
      } else {
        Get.snackbar(
          'Error', 
          result['message'] ?? 'Gagal melakukan transfer',
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  @override
  void onClose() {
    searchController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.onClose();
  }
}