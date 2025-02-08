import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_model.dart';

class HabitDetailScreen extends StatefulWidget {
  final HabitModel habit;

  HabitDetailScreen({required this.habit});

  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  TextEditingController _targetNumberController = TextEditingController();
  TextEditingController _daysOfWeekController = TextEditingController();
  TextEditingController _dayOfMonthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.habit.type == HabitType.NumberReached) {
      _targetNumberController.text = widget.habit.targetNumber?.toString() ?? '';
    }
    if (widget.habit.type == HabitType.Weekly) {
      _daysOfWeekController.text = widget.habit.daysOfWeek?.join(', ') ?? '';
    }
    if (widget.habit.type == HabitType.Monthly) {
      _dayOfMonthController.text = widget.habit.dayOfMonth?.toString() ?? '';
    }
  }

  Future<void> _updateHabit() async {
    try {
      if (widget.habit.type == HabitType.NumberReached) {
        widget.habit.targetNumber = int.tryParse(_targetNumberController.text);
      }
      if (widget.habit.type == HabitType.Weekly) {
        widget.habit.daysOfWeek = _daysOfWeekController.text.split(',').map((e) => e.trim()).toList();
      }
      if (widget.habit.type == HabitType.Monthly) {
        widget.habit.dayOfMonth = int.tryParse(_dayOfMonthController.text);
      }

      widget.habit.updatedAt = DateTime.now();
      widget.habit.updateHistory = (widget.habit.updateHistory ?? [])..add({
        'updatedAt': widget.habit.updatedAt,
        'targetNumber': widget.habit.targetNumber,
        'daysOfWeek': widget.habit.daysOfWeek,
        'dayOfMonth': widget.habit.dayOfMonth,
      });

      await FirebaseFirestore.instance
          .collection('habits')
          .doc(widget.habit.userId)
          .update(widget.habit.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit updated successfully!')),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating habit: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.habit.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${widget.habit.description}'),
            SizedBox(height: 10),
            Text('Type: ${widget.habit.type.name}'),
            if (widget.habit.type == HabitType.NumberReached)
              TextField(
                controller: _targetNumberController,
                decoration: InputDecoration(labelText: 'Target Number'),
                keyboardType: TextInputType.number,
              ),
            if (widget.habit.type == HabitType.Weekly)
              TextField(
                controller: _daysOfWeekController,
                decoration: InputDecoration(labelText: 'Days of the Week (comma separated)'),
              ),
            if (widget.habit.type == HabitType.Monthly)
              TextField(
                controller: _dayOfMonthController,
                decoration: InputDecoration(labelText: 'Day of the Month'),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateHabit,
              child: Text('Update Habit'),
            ),
            SizedBox(height: 20),
            Text('Update History:'),
            Expanded(
              child: ListView.builder(
                itemCount: widget.habit.updateHistory?.length ?? 0,
                itemBuilder: (context, index) {
                  var history = widget.habit.updateHistory![index];
                  return ListTile(
                    title: Text('Updated at: ${history['updatedAt']}'),
                    subtitle: Text(
                      'Target Number: ${history['targetNumber']}, '
                      'Days of Week: ${history['daysOfWeek']}, '
                      'Day of Month: ${history['dayOfMonth']}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
