import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_model.dart';
import 'package:habit_tracker/src/widgets/habit_progress_chart.dart';

class HabitProgressCard extends StatelessWidget {
  final HabitModel habit;

  const HabitProgressCard({
    Key? key,
    required this.habit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300, // Adjust this value as needed
              child: HabitProgressChart(habit: habit),
            ),
            if (habit.targetNumber != null) ...[
              const SizedBox(height: 16),
              Text(
                'Target: ${habit.targetNumber}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}