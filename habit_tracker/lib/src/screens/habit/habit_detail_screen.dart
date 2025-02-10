import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_history_entry.dart';
import 'package:habit_tracker/src/widgets/habbit_progress_card.dart';
import 'package:habit_tracker/src/widgets/habit_progress_chart.dart';
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

class _HabitDetailScreenState extends State<HabitDetailScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _targetNumberController;
  late AnimationController _animationController;
  bool _showAnimation = false;
  List<String> _selectedDays = [];
  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showAnimation = false;
        });
        _animationController.reset();
      }
    });

    int initialNumber = widget.habit.history.isNotEmpty
        ? widget.habit.history.map((e) => e.numberReached).reduce((a, b) => a > b ? a : b)
        : 0;
    _targetNumberController = TextEditingController(text: initialNumber.toString());
    if (widget.habit.type == HabitType.Weekly) {
      _selectedDays = List.from(widget.habit.daysOfWeek ?? []);
    }
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

      if (todayEntry.numberReached != 0 && !widget.habit.history.contains(todayEntry)) {
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

    if (_animationController == null) {
    debugPrint("AnimationController is not initialized yet!");
  } else {
    debugPrint("Triggering success animation");
    _animationController.forward();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppBar(title: widget.habit.name),
      body: Stack(
        children: [
          Padding(
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

                // Habit History
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
          // Success Animation Overlay
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