enum HabitType {
  Daily,
  Weekly,
}

extension HabitTypeExtension on HabitType {
  String get name {
    switch (this) {
      case HabitType.Daily:
        return "Daily";
      case HabitType.Weekly:
        return "Weekly";
    }
  }
}

class HabitModel {
  String userId;
  String name;
  String description;
  HabitType type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? targetNumber; // For NumberReached type
  List<String>? daysOfWeek; // For Weekly type
  int? dayOfMonth; // For Monthly type
  List<Map<String, dynamic>>? updateHistory; // To track updates

  HabitModel({
    required this.userId,
    required this.name,
    required this.description,
    required this.type,
    this.createdAt,
    this.updatedAt,
    this.targetNumber,
    this.daysOfWeek,
    this.dayOfMonth,
    this.updateHistory,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'type': type.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'targetNumber': targetNumber,
      'daysOfWeek': daysOfWeek,
      'dayOfMonth': dayOfMonth,
      'updateHistory': updateHistory,
    };
  }
}

