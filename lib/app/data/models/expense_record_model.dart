class ExpenseRecord {
  final int id;
  final double amount;
  final String date;
  final String type; // normal, gift
  final String receiverPhone;
  final String receiverName;
  final String? message;

  ExpenseRecord({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.receiverPhone,
    required this.receiverName,
    this.message,
  });

  factory ExpenseRecord.fromJson(Map<String, dynamic> json) {
    return ExpenseRecord(
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
