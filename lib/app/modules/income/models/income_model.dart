class Income {
  final int id;
  final String amount;
  final String senderPhone;
  final String senderName;
  final String type;
  final String date;
  final String? message;

  Income({
    required this.id,
    required this.amount,
    required this.senderPhone,
    required this.senderName,
    required this.type,
    required this.date,
    this.message,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'] ?? 0,
      amount: json['amount'] ?? "0",
      senderPhone: json['sender_phone'] ?? "",
      senderName: json['sender_name'] ?? 'Unknown',
      type: json['type'] ?? 'normal',
      date: json['date'] ?? DateTime.now().toIso8601String().split('T')[0],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'sender_phone': senderPhone,
      'sender_name': senderName,
      'type': type,
      'date': date,
      'message': message,
    };
  }
}
