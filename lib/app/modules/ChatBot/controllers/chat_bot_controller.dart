import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatBotController extends GetxController {
  final chatMessages = <ChatMessage>[].obs;
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Menambahkan pesan selamat datang dari bot
    chatMessages.add(
      ChatMessage(
        text: 'Halo! Saya adalah PayPlus Assistant. Ada yang bisa saya bantu tentang keuangan Anda?',
        isUser: false,
      ),
    );
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Menambahkan pesan pengguna
    chatMessages.add(
      ChatMessage(
        text: text,
        isUser: true,
      ),
    );
    
    messageController.clear();

    // Simulasi respons dari bot (dalam aplikasi nyata, ini akan terhubung ke API)
    Future.delayed(const Duration(seconds: 1), () {
      final botResponse = _generateBotResponse(text);
      chatMessages.add(
        ChatMessage(
          text: botResponse,
          isUser: false,
        ),
      );
    });
  }

  String _generateBotResponse(String userMessage) {
    // Ini hanya simulasi sederhana, dalam aplikasi nyata akan terhubung ke API
    if (userMessage.toLowerCase().contains('saldo')) {
      return 'Untuk memeriksa saldo, silakan buka halaman Beranda dan lihat di bagian atas.';
    } else if (userMessage.toLowerCase().contains('transfer')) {
      return 'Anda dapat melakukan transfer dengan memilih menu Transfer di halaman Beranda, lalu ikuti petunjuk yang diberikan.';
    } else if (userMessage.toLowerCase().contains('investasi')) {
      return 'PayPlus menawarkan berbagai produk investasi dengan imbal hasil menarik. Silakan buka menu Investasi untuk melihat pilihan yang tersedia.';
    } else {
      return 'Terima kasih atas pertanyaan Anda. Saya masih belajar untuk memberikan jawaban yang lebih baik. Ada hal lain yang ingin Anda tanyakan?';
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
