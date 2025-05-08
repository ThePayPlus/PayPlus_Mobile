class ChatRoom {
  final String id;
  final String name;
  final List<String> participants;
  final DateTime createdAt;
  final DateTime lastActivity;
  final String lastMessage;

  ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    required this.createdAt,
    required this.lastActivity,
    this.lastMessage = '',
  });

  // Factory constructor untuk membuat objek dari Firestore
  factory ChatRoom.fromFirestore(Map<String, dynamic> data, String docId) {
    return ChatRoom(
      id: docId,
      name: data['name'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      lastActivity: data['lastActivity']?.toDate() ?? DateTime.now(),
      lastMessage: data['lastMessage'] ?? '',
    );
  }

  // Konversi ke Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'participants': participants,
      'createdAt': createdAt,
      'lastActivity': lastActivity,
      'lastMessage': lastMessage,
    };
  }
}
