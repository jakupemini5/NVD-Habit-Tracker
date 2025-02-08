import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onClick;

  HabitCard({required this.habit, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                habit.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(habit.description),
              const SizedBox(height: 10),
              Text('Type: ${habit.type.name}'),
              if (habit.targetNumber != null)
                Text('Target Number: ${habit.targetNumber}'),
              if (habit.daysOfWeek != null)
                Text('Days of Week: ${habit.daysOfWeek!.join(', ')}'),
              if (habit.dayOfMonth != null)
                Text('Day of Month: ${habit.dayOfMonth}'),
            ],
          ),
        ),
      ),
    );
  }
}
