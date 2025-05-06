import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payplus_mobile/app/modules/add_friend_dialog/views/add_friend_dialog_view.dart';
import '../controllers/friend_page_controller.dart';
import '../../../theme/app_theme.dart'; // Menggunakan AppTheme untuk styling

class FriendPageView extends StatelessWidget {
  const FriendPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendPageController());

    return Scaffold(
      backgroundColor:
          AppTheme.background, // Menggunakan background dari AppTheme
      appBar: AppBar(
        title: Text(
          'PayPlus Friend',
          style: AppTheme.headingStyle.copyWith(
              color: AppTheme
                  .primaryPurple), // Menggunakan headingStyle dari AppTheme
        ),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add,
                color: AppTheme
                    .primaryPurple), // Menggunakan primaryPurple dari AppTheme
            onPressed: () => Get.dialog(AddFriendDialog()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                border: Border.all(
                  color: AppTheme.primaryPurple.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari teman...',
                          hintStyle: TextStyle(
                            color: AppTheme.primaryPurple.withOpacity(0.4),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: AppTheme.primaryPurple.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        cursorColor: AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryYellow.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: AppTheme.primaryPurple,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Friend List
          Expanded(
            child: Obx(() {
              // Tampilkan loading indicator
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryPurple,
                  ),
                );
              }

              // Tampilkan pesan error jika ada
              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.fetchFriends,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                        ),
                        child: Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              // Tampilkan pesan jika tidak ada teman
              if (controller.friends.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: AppTheme.primaryPurple.withOpacity(0.5),
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada teman',
                        style: TextStyle(
                          color: AppTheme.primaryPurple.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Get.dialog(AddFriendDialog()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                        ),
                        child: Text('Tambah Teman'),
                      ),
                    ],
                  ),
                );
              }

              // Tampilkan daftar teman
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.friends.length,
                itemBuilder: (context, index) {
                  final friend = controller.friends[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: AppTheme.cardDecoration,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            AppTheme.primaryYellow.withOpacity(0.3),
                        child: Text(
                          _getInitials(friend['name'] ?? ''),
                          style: TextStyle(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        friend['name'] ?? 'Tidak ada nama',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      subtitle: Text(
                        'Phone: ${friend['phone'] ?? 'Tidak ada nomor'}',
                        style: TextStyle(
                          color: AppTheme.primaryPurple.withOpacity(0.6),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Tambahkan fungsi _getInitials
  String _getInitials(String name) {
    if (name.isEmpty) return '';

    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (name.length > 1) {
      return name.substring(0, 2);
    } else {
      return name;
    }
  }
}
