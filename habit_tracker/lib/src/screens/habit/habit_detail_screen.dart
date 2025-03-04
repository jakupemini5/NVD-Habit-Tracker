import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_history_entry.dart';
import 'package:habit_tracker/src/widgets/habbit_progress_card.dart';
import 'package:lottie/lottie.dart';
import 'package:habit_tracker/src/models/habit_model.dart';
import 'package:habit_tracker/src/widgets/habbit_card.dart';
import 'package:habit_tracker/src/widgets/my_app_bar.dart';
import 'package:habit_tracker/src/widgets/rounded_pill_button.dart';

class HabitDetailScreen extends StatefulWidget {
  final HabitModel habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  HabitDetailScreenState createState() => HabitDetailScreenState();
}

class HabitDetailScreenState extends State<HabitDetailScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _targetNumberController;
  late AnimationController _animationController;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showAnimation = false;
        });
        _animationController.reset();
        _animationController.duration = const Duration(milliseconds: 1500);
      }
    });

    int initialNumber = widget.habit.history.isNotEmpty
        ? widget.habit.history
            .map((e) => e.numberReached)
            .reduce((a, b) => a > b ? a : b)
        : 0;
    _targetNumberController =
        TextEditingController(text: initialNumber.toString());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _targetNumberController.dispose();
    super.dispose();
  }

  void _updateNumberReached(int change) {
    setState(() {
      DateTime today = DateTime.now();
      HabitHistoryEntry? todayEntry = widget.habit.history.firstWhere(
        (entry) =>
            entry.date.year == today.year &&
            entry.date.month == today.month &&
            entry.date.day == today.day,
        orElse: () => HabitHistoryEntry(date: today, numberReached: 0),
      );
      int current = todayEntry.numberReached;
      int newValue = (current + change).clamp(0, 999);
      todayEntry.numberReached = newValue;
      if (todayEntry.numberReached != 0 &&
          !widget.habit.history.contains(todayEntry)) {
        widget.habit.addHistoryEntry(newValue);
      } else {
        int index = widget.habit.history.indexWhere(
          (entry) =>
              entry.date.year == today.year &&
              entry.date.month == today.month &&
              entry.date.day == today.day,
        );
        if (index != -1) {
          widget.habit.history[index] = todayEntry;
        }
      }
      _targetNumberController.text = newValue.toString();
      _saveToFirestore();
      // Check if target is met
      if (newValue == widget.habit.targetNumber! && !_showAnimation) {
        _triggerSuccessAnimation();
      }
    });
  }
  void _triggerSuccessAnimation() {
    setState(() {
      _showAnimation = true;
    });
    debugPrint("Triggering success animation");
    _animationController.forward();
    _animationController.forward();
  }
  void _saveToFirestore() {
    FirebaseFirestore.instance
        .collection('habits')
        .doc(widget.habit.habitId)
        .update({
      'history': widget.habit.history.map((entry) => entry.toJson()).toList(),
    });
  }

  void _deleteHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Habit"),
        content: const Text("Are you sure you want to delete this habit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('habits')
                  .doc(widget.habit.habitId)
                  .delete();
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close detail screen
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppBar(
        title: widget.habit.name,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoundedPillButton(
                  text: "Delete",
                  backgroundColor: const Color.fromARGB(118, 244, 67, 54),
                  onPressed: _deleteHabit,
                  icon: Icons.delete,   
                  radius: 16,
                  width: 360,
                ),
                const SizedBox(height: 20),
                Hero(
                  tag: 'habit_${widget.habit.name}',
                  child: HabitCard(habit: widget.habit),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () => _updateNumberReached(-1),
                    ),
                    Text(
                      _targetNumberController.text,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => _updateNumberReached(1),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                    children: [
                      HabitProgressCard(habit: widget.habit),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showAnimation)
            Container(
              color: Colors.black54,
              child: Center(
                child: Lottie.asset(
                  'assets/animations/success.json',
                  controller: _animationController,
                  width: 400,
                  height: 400,
                  fit: BoxFit.contain,
                  onLoaded: (composition) {
                    _animationController.duration = composition.duration;
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
