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
                      onPressed: () {},
                    ),
                    Text(
                      _targetNumberController.text,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {},
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
