// habit_history_entry.dart

class HabitHistoryEntry {
  final DateTime date;
  int numberReached;

  HabitHistoryEntry({required this.date, required this.numberReached});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'numberReached': numberReached,
      };

  factory HabitHistoryEntry.fromJson(Map<String, dynamic> json) {
    return HabitHistoryEntry(
      date: DateTime.parse(json['date']),
      numberReached: json['numberReached'],
    );
  }
}
