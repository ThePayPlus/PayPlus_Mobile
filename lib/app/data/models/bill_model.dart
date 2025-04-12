class Bill {
  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final String category;
  final String icon;

  Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.category,
    this.icon = '',
  });

  bool get isOverdue => DateTime.now().isAfter(dueDate);
  
  bool get isDueTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final dueDateNormalized = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return dueDateNormalized.isAtSameMomentAs(tomorrow);
  }
  
  int get daysOverdue {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }
}