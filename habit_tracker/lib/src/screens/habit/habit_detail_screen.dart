import 'package:flutter/material.dart';
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
  List<String> _selectedDays = [];
  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _targetNumberController = TextEditingController(text: widget.habit.targetNumber.toString());
    if (widget.habit.type == HabitType.Weekly) {
      _selectedDays = List.from(widget.habit.daysOfWeek ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppBar(title: widget.habit.name),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'habit_${widget.habit.name}', // Add this line
              child: HabitCard(habit: widget.habit),
            ),
          ],
        ),
      ),
    );
  }
}
