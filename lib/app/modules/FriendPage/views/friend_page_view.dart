import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:payplus_mobile/app/modules/ChatList/views/chat_list_view.dart';

import '../controllers/friend_page_controller.dart';
import '../../../theme/app_theme.dart';

class FriendPageView extends StatefulWidget {
  const FriendPageView({Key? key}) : super(key: key);

  @override
  State<FriendPageView> createState() => _FriendPageViewState();
}

class _FriendPageViewState extends State<FriendPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<FriendPageController>();
  final TextEditingController _searchController = TextEditingController();

  // Warna tema untuk PayPlus
  final Color primaryPurple =
      const Color(0xFF8217FF); // Warna ungu yang lebih pekat
  final Color softYellow =
      const Color(0xFFFFF0A0); // Warna kuning pudar PayPlus
  final Color brightYellow =
      const Color(0xFFFFD700); // Warna kuning kuat/vibrant
  final Color onlineGreen =
      const Color(0xFF4CAF50); // Warna hijau untuk online status

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.tabIndex.value = _tabController.index;
        setState(() {}); // Memperbarui UI ketika tab berubah
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            _buildSearchBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFriendsList(), // Tab 1 - Friends List
                  ChatListView(), // Tab 2 - Chat List
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() => _buildAddFriendButton()),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: primaryPurple),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                Icons.groups_rounded,
                color: brightYellow,
                size: 26,
              ),
              const SizedBox(width: 8),
              Text(
                'PayPlus Friend',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 40), // Balance untuk tombol back di kiri
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: primaryPurple.withOpacity(0.2),
              width: 1), // Border ungu tipis
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
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari teman...',
                    hintStyle: TextStyle(
                        color: primaryPurple
                            .withOpacity(0.4)), // Hint text ungu transparan
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  style: TextStyle(
                      color: primaryPurple.withOpacity(0.8),
                      fontSize: 14), // Text color ungu
                  cursorColor: primaryPurple, // Cursor ungu
                ),
              ),
            ),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: softYellow, // Kembali menggunakan kuning pudar
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.search,
                  color: primaryPurple, // Icon ungu
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 50,
      decoration: BoxDecoration(
        color: primaryPurple
            .withOpacity(0.05), // Background ungu sangat transparan
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: softYellow
                .withOpacity(0.6)), // Kembali menggunakan border kuning pudar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.animateTo(0);
                setState(() {}); // Tambahkan setState saat tab diklik
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _tabController.index == 0
                      ? primaryPurple // Tab aktif ungu solid
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Teman',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: _tabController.index == 0
                          ? softYellow
                          : primaryPurple, // Kembali menggunakan teks kuning pudar jika aktif
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.animateTo(1);
                setState(() {}); // Tambahkan setState saat tab diklik
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _tabController.index == 1
                      ? primaryPurple // Tab aktif ungu solid
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Chat',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: _tabController.index == 1
                          ? softYellow
                          : primaryPurple, // Kembali menggunakan teks kuning pudar jika aktif
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.friends.length,
          itemBuilder: (context, index) {
            final friend = controller.friends[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                    color: softYellow.withOpacity(
                        0.3)), // Kembali menggunakan border kuning pudar
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: softYellow.withOpacity(
                          0.3), // Kembali menggunakan background kuning pudar
                      child: Text(
                        _getInitials(friend.name),
                        style: TextStyle(
                          color: primaryPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (friend.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: onlineGreen, // Ubah ke warna hijau
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(
                  friend.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryPurple.withOpacity(0.9), // Warna teks ungu
                  ),
                ),
                subtitle: Text(
                  'Telepon: ${friend.phone}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color:
                        primaryPurple.withOpacity(0.6), // Warna teks ungu tipis
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: softYellow.withOpacity(
                        0.2), // Kembali menggunakan background kuning pudar
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.chat,
                    color: primaryPurple,
                    size: 20,
                  ),
                ),
                onTap: () {
                  // View friend details
                },
              ),
            );
          },
        ));
  }

  // Fungsi untuk mendapatkan inisial dari nama
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Widget _buildAddFriendButton() {
    return controller.tabIndex.value == 0
        ? Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton.extended(
              onPressed: () => _showAddFriendDialog(),
              backgroundColor: softYellow, // Kembali menggunakan kuning pudar
              label: Row(
                children: [
                  Icon(Icons.person_add, color: primaryPurple), // Icon ungu
                  const SizedBox(width: 8),
                  Text(
                    'Tambah Teman',
                    style: TextStyle(color: primaryPurple), // Teks ungu
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  void _showAddFriendDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Tambah Teman',
            style: TextStyle(
                color: primaryPurple,
                fontWeight: FontWeight.bold)), // Judul ungu
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                hintText: 'Masukkan nama teman',
                labelStyle: TextStyle(color: primaryPurple), // Label ungu
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          softYellow), // Kembali menggunakan garis kuning pudar
                ),
              ),
              cursorColor: primaryPurple,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                hintText: 'Masukkan nomor telepon teman',
                labelStyle: TextStyle(color: primaryPurple), // Label ungu
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          softYellow), // Kembali menggunakan garis kuning pudar
                ),
              ),
              cursorColor: primaryPurple,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                Get.snackbar('Error', 'Nama tidak boleh kosong');
                return;
              }

              // Add friend logic
              controller.addFriend(
                nameController.text.trim(),
                phoneController.text.trim(),
              );

              Get.back(); // Close dialog
              Get.snackbar(
                'Berhasil',
                'Teman berhasil ditambahkan!',
                backgroundColor: softYellow
                    .withOpacity(0.2), // Kembali menggunakan latar kuning pudar
                colorText: primaryPurple, // Teks ungu
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  softYellow, // Kembali menggunakan tombol kuning pudar
              foregroundColor: primaryPurple, // Teks ungu
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
