import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payplus_mobile/app/modules/FriendPage/views/friend_request_widget.dart';
import 'package:payplus_mobile/app/modules/add_friend_dialog/views/add_friend_dialog_view.dart';
import '../controllers/friend_page_controller.dart';
import '../../../theme/app_theme.dart';

class FriendPageView extends StatelessWidget {
  const FriendPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendPageController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'PayPlus Friend',
          style: AppTheme.headingStyle.copyWith(color: AppTheme.primaryPurple),
        ),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppTheme.primaryPurple),
            onPressed: () => Get.dialog(AddFriendDialog()),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
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
                      color: AppTheme.textDark.withOpacity(0.2),
                      width: 2,
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
                            ),
                            style: TextStyle(
                              color: AppTheme.textDark,
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
              // Friend list
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryPurple,
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
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

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.friends.length,
                    itemBuilder: (context, index) {
                      final friend = controller.friends[index];
                      return Dismissible(
                        key: Key(friend['id']?.toString() ?? index.toString()),
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.circular(AppTheme.borderRadius),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.circular(AppTheme.borderRadius),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            // Delete action
                            return await _showDeleteConfirmationDialog(
                                context, friend);
                          } else if (direction == DismissDirection.startToEnd) {
                            // Edit action
                            _showEditDialog(context, friend);
                            return false; // Don't dismiss the item
                          }
                          return false;
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            // Delete action already handled in confirmDismiss
                          }
                        },
                        child: Container(
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
                                color: AppTheme.textDark,
                              ),
                            ),
                            subtitle: Text(
                              'Phone: ${friend['phone'] ?? 'Tidak ada nomor'}',
                              style: TextStyle(
                                color: AppTheme.textLight,
                              ),
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
        ],
      ),
      // friend request button
      floatingActionButton: Obx(() => FloatingActionButton(
            backgroundColor: AppTheme.primaryPurple,
            onPressed: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  insetPadding: EdgeInsets.all(16),
                  backgroundColor: Colors.white,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    padding: EdgeInsets.all(16),
                    child: FriendRequestWidget(controller: controller),
                  ),
                ),
                barrierDismissible: true,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.group_add, size: 28),
                if (controller.friendRequests.isNotEmpty)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          )),
    );
  }

  // Dialog untuk konfirmasi hapus teman
  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, Map<String, dynamic> friend) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hapus Teman'),
              content: Text(
                  'Apakah Anda yakin ingin menghapus ${friend['name']} dari daftar teman?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    final controller = Get.find<FriendPageController>();
                    controller.deleteFriend(friend['id'].toString());
                    Navigator.of(context).pop(true);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text('Hapus'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // Dialog untuk edit teman
  void _showEditDialog(BuildContext context, Map<String, dynamic> friend) {
    final nameController = TextEditingController(text: friend['name']);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Nama Teman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Batal'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final controller = Get.find<FriendPageController>();
                      controller.updateFriend(
                        friend['id'].toString(),
                        nameController.text,
                        friend['phone']?.toString() ?? '',
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                    ),
                    child: Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
