import 'package:get/get.dart';

class ChatRoom {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final String avatar;

  ChatRoom({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
    this.avatar = '',
  });
}

class ChatListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<ChatRoom> chatRooms = <ChatRoom>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    isLoading.value = true;

    // Simulasi delay loading
    Future.delayed(const Duration(milliseconds: 800), () {
      chatRooms.value = [
        ChatRoom(
          id: '1',
          name: 'Sarah Johnson',
          lastMessage: 'Sudah kamu transfer uang untuk acara besok?',
          lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
          unreadCount: 2,
          isOnline: true,
        ),
        ChatRoom(
          id: '2',
          name: 'PayPlus Support',
          lastMessage: 'Transaksi pembayaran Anda berhasil diproses',
          lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
          unreadCount: 0,
          isOnline: true,
        ),
        ChatRoom(
          id: '3',
          name: 'John Smith',
          lastMessage: 'Terima kasih atas pembayarannya',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
          unreadCount: 0,
          isOnline: false,
        ),
        ChatRoom(
          id: '4',
          name: 'Maria Garcia',
          lastMessage: 'Saya sudah mengirimkan invoice untuk proyek kita',
          lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
          unreadCount: 0,
          isOnline: true,
        ),
      ];

      isLoading.value = false;
    });
  }
}
