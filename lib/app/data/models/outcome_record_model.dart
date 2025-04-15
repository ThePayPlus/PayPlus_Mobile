class OutcomeRecord {
  final int id;
  final double amount;
  final String date;
  final String type; // normal, gift
  final String receiverPhone;
  final String receiverName;
  final String? message;

  OutcomeRecord({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.receiverPhone,
    required this.receiverName,
    this.message,
  });

  factory OutcomeRecord.fromJson(Map<String, dynamic> json) {
    return OutcomeRecord(
      id: json['id'],
      amount: json['amount'].toDouble(),
      date: json['date'],
      type: json['type'],
      receiverPhone: json['receiverPhone'],
      receiverName: json['receiverName'],
      message: json['message'],
    );
  }
}
