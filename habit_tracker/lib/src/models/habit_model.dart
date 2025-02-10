import 'habit_history_entry.dart';

enum HabitType {
  daily,
  weekly,
}

extension HabitTypeExtension on HabitType {
  String get name {
    switch (this) {
      case HabitType.daily:
        return "Daily";
      case HabitType.weekly:
        return "Weekly";
    }
  }
}

class HabitModel {
  String? habitId;
  String userId;
  String name;
  String description;
  HabitType type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? targetNumber; // For NumberReached type
  List<String>? daysOfWeek; // For Weekly type
  int? dayOfMonth; // For Monthly type
  List<HabitHistoryEntry> history; // Track updates

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
    this.habitId,
    List<HabitHistoryEntry>? history,
    
  })  : history = history ?? [];

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'userId': userId,
      'name': name,
      'description': description,
      'type': type.name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'targetNumber': targetNumber,
      'daysOfWeek': daysOfWeek,
      'dayOfMonth': dayOfMonth,
      'history': history.map((entry) => entry.toJson()).toList(),
    };
  }

  // Add a new history entry
  void addHistoryEntry(int numberReached) {
    history.add(HabitHistoryEntry(date: DateTime.now(), numberReached: numberReached));
  }
}
