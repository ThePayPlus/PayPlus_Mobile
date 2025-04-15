import 'package:get/get.dart';
import '../../Chat/views/chat_view.dart';
import '../../../routes/app_pages.dart';

class Friend {
  final String id;
  final String name;
  final String imageUrl;
  final String lastMessage;
  final String lastMessageTime;
  final bool isOnline;
  final int unreadCount;
  final String phone;
  final String chatRoomId;

  Friend({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isOnline = false,
    this.unreadCount = 0,
    this.phone = '',
    this.chatRoomId = '',
  });
}

class FriendPageController extends GetxController {
  final RxList<Friend> friends = <Friend>[].obs;
  final RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadFriends();
  }

  void loadFriends() {
    // Data teman yang sesuai dengan chat list
    friends.addAll([
      Friend(
        id: '1',
        name: 'Sarah Johnson',
        imageUrl: 'assets/images/default.png',
        lastMessage: 'Sudah transfer uang untuk acara besok?',
        lastMessageTime: 'Baru saja',
        isOnline: true,
        unreadCount: 2,
        phone: '+628123456789',
        chatRoomId: 'chat1',
      ),
      Friend(
        id: '2',
        name: 'PayPlus Support',
        imageUrl: 'assets/images/default.png',
        lastMessage: 'Transaksi pembayaran Anda berhasil diproses',
        lastMessageTime: '2 jam lalu',
        isOnline: true,
        unreadCount: 0,
        phone: '+628000111222',
        chatRoomId: 'chat_support',
      ),
      Friend(
        id: '3',
        name: 'John Smith',
        imageUrl: 'assets/images/default.png',
        lastMessage: 'Terima kasih atas pembayarannya',
        lastMessageTime: 'Kemarin',
        phone: '+628234567890',
        chatRoomId: 'chat2',
      ),
      Friend(
        id: '4',
        name: 'Maria Garcia',
        imageUrl: 'assets/images/default.png',
        lastMessage: 'Saya sudah mengirimkan invoice untuk proyek kita',
        lastMessageTime: '2 hari lalu',
        isOnline: true,
        phone: '+628345678901',
        chatRoomId: 'chat3',
      ),
      Friend(
        id: '5',
        name: 'David Wilson',
        imageUrl: 'assets/images/default.png',
        lastMessage: 'Pembayaran telah diterima, terima kasih',
        lastMessageTime: '5 hari lalu',
        unreadCount: 0,
        phone: '+628456789012',
        chatRoomId: 'chat4',
      ),
    ]);
  }

  void addFriend(String name, String phone) {
    // Create a new friend and add to list
    final newId = (friends.length + 1).toString();
    final newFriend = Friend(
      id: newId,
      name: name,
      imageUrl: 'assets/images/default.png',
      lastMessage: '',
      lastMessageTime: '',
      phone: phone,
      chatRoomId: 'chat$newId',
    );

    friends.add(newFriend);
  }

  void startChat(Friend friend) {
    // Navigate to chat screen
    Get.toNamed(Routes.CHAT);
  }
}
