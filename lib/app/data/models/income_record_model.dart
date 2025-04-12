class IncomeRecord {
  final int id;
  final double amount;
  final String date;
  final String type; // normal, gift, topup
  final String senderPhone;
  final String? message;
  final String senderName;

  IncomeRecord({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.senderPhone,
    required this.senderName,
    this.message,
  });

  factory IncomeRecord.fromJson(Map<String, dynamic> json) {
    return IncomeRecord(
      id: json['id'],
      amount: json['amount'].toDouble(),
      date: json['date'],
      type: json['type'],
      senderPhone: json['senderPhone'],
      senderName: json['senderName'],
      message: json['message'],
    );
  }
}
