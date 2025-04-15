class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  // Factory constructor untuk membuat objek dari Firestore
  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String docId) {
    return ChatMessage(
      id: docId,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      receiverId: data['receiverId'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  // Konversi ke Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}
