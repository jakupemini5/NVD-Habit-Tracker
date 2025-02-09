import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_history_entry.dart';
import 'package:lottie/lottie.dart';
import 'package:habit_tracker/src/models/habit_model.dart';
import 'package:habit_tracker/src/widgets/habbit_card.dart';
import 'package:habit_tracker/src/widgets/my_app_bar.dart';

class HabitDetailScreen extends StatefulWidget {
  final HabitModel habit;

  HabitDetailScreen({required this.habit});

  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late TextEditingController _targetNumberController;
  bool _showAnimation = false;
  List<String> _selectedDays = [];
  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    int initialNumber = widget.habit.history.isNotEmpty
        ? widget.habit.history.map((e) => e.numberReached).reduce((a, b) => a > b ? a : b)
        : 0;
    _targetNumberController = TextEditingController(text: initialNumber.toString());
    if (widget.habit.type == HabitType.Weekly) {
      _selectedDays = List.from(widget.habit.daysOfWeek ?? []);
    }
  }

  void _updateNumberReached(int change) {
    setState(() {
      // Find today's history entry
      DateTime today = DateTime.now();
      HabitHistoryEntry? todayEntry = widget.habit.history.firstWhere(
        (entry) => entry.date.year == today.year &&
                   entry.date.month == today.month &&
                   entry.date.day == today.day,
        orElse: () => HabitHistoryEntry(date: today, numberReached: 0),
      );

      // Update the current number reached
      int current = todayEntry.numberReached;
      int newValue = (current + change).clamp(0, 999); // Prevent negative values
      todayEntry.numberReached = newValue;

      // Create or update the history entry
      if (todayEntry.numberReached != 0 && !widget.habit.history.contains(todayEntry)) {
        widget.habit.addHistoryEntry(newValue);
      } else {
        int index = widget.habit.history.indexWhere(
          (entry) => entry.date.year == today.year &&
                     entry.date.month == today.month &&
                     entry.date.day == today.day,
        );
        widget.habit.history[index] = todayEntry;
      }

      _targetNumberController.text = newValue.toString();

      // Save to Firestore
      _saveToFirestore();

      // Check if target is met
      if (newValue >= widget.habit.targetNumber!) {
        _triggerSuccessAnimation();
      }
    });
  }

  void _triggerSuccessAnimation() {
    setState(() {
      _showAnimation = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showAnimation = false;
      });
    });
  }

  void _saveToFirestore() {
    FirebaseFirestore.instance.collection('habits').doc(widget.habit.habitId).update({
      'history': widget.habit.history.map((entry) => entry.toJson()).toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppBar(title: widget.habit.name),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'habit_${widget.habit.name}',
              child: HabitCard(habit: widget.habit),
            ),
            SizedBox(height: 20),

            // Target Number Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white),
                  onPressed: () => _updateNumberReached(-1),
                ),
                Text(
                  _targetNumberController.text,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => _updateNumberReached(1),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Success Animation
            if (_showAnimation)
              Center(
                child: Lottie.network(
                  'https://assets5.lottiefiles.com/packages/lf20_x62chJ.json', // Use a Lottie animation URL
                  width: 150,
                  height: 150,
                ),
              ),
            SizedBox(height: 10),

            // Habit History
            Expanded(
              child: ListView.builder(
                itemCount: widget.habit.history.length,
                itemBuilder: (context, index) {
                  final entry = widget.habit.history[index];
                  return ListTile(
                    title: Text(
                      "${entry.date}: ${entry.numberReached}",
                      style: TextStyle(color: Colors.white),
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
