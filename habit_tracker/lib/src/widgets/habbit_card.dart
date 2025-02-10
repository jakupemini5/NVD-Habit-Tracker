import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback? onClick;

  HabitCard({required this.habit, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                habit.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                habit.description,
                style: TextStyle(fontSize: 14, color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(Icons.category, color: Colors.white70, size: 18),
                  SizedBox(width: 5),
                  Text(
                    habit.type.name,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),

              if (habit.targetNumber != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.flag, color: Colors.white70, size: 18),
                    SizedBox(width: 5),
                    Text(
                      'Target: ${habit.targetNumber}',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ],

              if (habit.daysOfWeek != null && habit.daysOfWeek!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                    SizedBox(width: 5),
                    Text(
                      'Days: ${habit.daysOfWeek!.join(', ')}',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ],

              if (habit.dayOfMonth != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.event, color: Colors.white70, size: 18),
                    SizedBox(width: 5),
                    Text(
                      'Day of Month: ${habit.dayOfMonth}',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
