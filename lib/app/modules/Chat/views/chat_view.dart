import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';

class Message {
  final String id;
  final String text;
  final bool isMe;
  final String senderName;
  final DateTime time;
  final bool isRead;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.senderName,
    required this.time,
    this.isRead = false,
  });
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  final String _chatPartner = 'Sarah Johnson';

  @override
  void initState() {
    super.initState();
    _loadDummyMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDummyMessages() {
    final now = DateTime.now();

    _messages.addAll([
      Message(
        id: '1',
        text: 'Halo Sarah, sudah transfer uang untuk acara besok?',
        isMe: true,
        senderName: 'You',
        time: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: '2',
        text: 'Hai, belum. Bisa tolong ingatkan berapa nominalnya?',
        isMe: false,
        senderName: _chatPartner,
        time: now.subtract(const Duration(hours: 1, minutes: 45)),
      ),
      Message(
        id: '3',
        text: 'Rp. 250.000 untuk sewa tempat',
        isMe: true,
        senderName: 'You',
        time: now.subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      Message(
        id: '4',
        text: 'Oke, saya transfer via PayPlus ya',
        isMe: false,
        senderName: _chatPartner,
        time: now.subtract(const Duration(hours: 1)),
      ),
      Message(
        id: '5',
        text: 'Baik, terima kasih. Jangan lupa simpan bukti transfernya',
        isMe: true,
        senderName: 'You',
        time: now.subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      Message(
        id: '6',
        text: 'Sudah transfer! Saya kirimkan buktinya ya',
        isMe: false,
        senderName: _chatPartner,
        time: now.subtract(const Duration(minutes: 15)),
      ),
      Message(
        id: '7',
        text: 'Ok, sudah kamu transfer uang untuk acara besok?',
        isMe: false,
        senderName: _chatPartner,
        time: now.subtract(const Duration(minutes: 5)),
      ),
    ]);
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _messageController.text.trim(),
        isMe: true,
        senderName: 'You',
        time: DateTime.now(),
      ));

      _messageController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.lightPurple,
              child: Text(
                _chatPartner[0].toUpperCase(),
                style: TextStyle(
                  color: AppTheme.primaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _chatPartner,
                  style: AppTheme.subheadingStyle,
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.primaryPurple),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.payment, color: AppTheme.primaryPurple),
            onPressed: () {
              Get.snackbar(
                'Transfer Uang',
                'Fitur transfer ke teman akan segera tersedia',
                backgroundColor: AppTheme.lightPurple,
                colorText: AppTheme.primaryPurple,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppTheme.primaryPurple),
            onPressed: () {
              // Show options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message);
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions_outlined,
                      color: AppTheme.textLight),
                  onPressed: () {
                    // Show emoji picker
                  },
                ),
                IconButton(
                  icon: Icon(Icons.attach_file, color: AppTheme.textLight),
                  onPressed: () {
                    // Show attachment options
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      hintStyle: TextStyle(color: AppTheme.textLight),
                      border: InputBorder.none,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppTheme.primaryPurple),
                  onPressed: _handleSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.lightPurple,
              child: Text(
                message.senderName[0].toUpperCase(),
                style: TextStyle(
                  color: AppTheme.primaryPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe ? AppTheme.primaryPurple : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe)
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(message.time),
                        style: TextStyle(
                          fontSize: 10,
                          color: message.isMe
                              ? Colors.white.withOpacity(0.7)
                              : AppTheme.textLight,
                        ),
                      ),
                      if (message.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
