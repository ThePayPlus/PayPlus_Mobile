import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_list_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';

class ChatListView extends GetView<ChatListController> {
  const ChatListView({Key? key}) : super(key: key);

  // Warna tema yang konsisten dengan FriendPageView
  final Color primaryPurple = const Color(0xFF8217FF); // Ungu pekat
  final Color softYellow = const Color(0xFFFFF0A0); // Kuning pudar
  final Color brightYellow = const Color(0xFFFFD700); // Kuning kuat/vibrant
  final Color onlineGreen =
      const Color(0xFF4CAF50); // Hijau untuk status online

  @override
  Widget build(BuildContext context) {
    // Register controller
    final controller = Get.put(ChatListController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: primaryPurple,
            ),
          );
        }

        if (controller.chatRooms.isEmpty) {
          return _buildEmptyState();
        }

        return _buildChatList();
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryPurple,
        onPressed: () => Get.toNamed(Routes.FRIEND_PAGE),
        child: const Icon(Icons.add_comment, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: primaryPurple.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada percakapan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryPurple.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai chat dengan teman Anda',
            style: TextStyle(
              fontSize: 14,
              color: primaryPurple.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => Get.toNamed(Routes.FRIEND_PAGE),
            child: const Text('Temukan Teman'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.chatRooms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final chatRoom = controller.chatRooms[index];
        return _buildChatItem(chatRoom, context);
      },
    );
  }

  Widget _buildChatItem(ChatRoom chatRoom, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Arahkan ke halaman chat
        Get.toNamed(Routes.CHAT);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
              color: softYellow
                  .withOpacity(0.3)), // Border kuning pudar yang konsisten
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: softYellow.withOpacity(
                      0.3), // Background kuning pudar yang konsisten
                  child: Text(
                    _getInitials(chatRoom.name),
                    style: TextStyle(
                      color: primaryPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (chatRoom.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: onlineGreen, // Warna hijau untuk status online
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chatRoom.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryPurple.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        _formatDate(chatRoom.lastMessageTime),
                        style: TextStyle(
                          color: primaryPurple.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatRoom.lastMessage,
                          style: TextStyle(
                            color: primaryPurple.withOpacity(0.6),
                            fontWeight: chatRoom.unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chatRoom.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: softYellow.withOpacity(
                                0.2), // Background kuning pudar untuk badge
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            chatRoom.unreadCount.toString(),
                            style: TextStyle(
                              color: primaryPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Kemarin';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Function to get initials from name
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
