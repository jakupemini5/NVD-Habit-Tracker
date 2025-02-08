import 'package:flutter/material.dart';
import 'package:habit_tracker/src/screens/habit/create_habit_screen.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/rounded_pill_button.dart';

class HabitsScreen extends StatefulWidget {
  HabitsScreen({super.key});

  final String title = "Habit tracker";

  @override
  State<HabitsScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding here
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundedPillButton(
                radius: 16,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateHabitScreen()),
                  );
                },
                text: "Create Habit",
                icon: Icons.add_circle_rounded,
                backgroundColor: Colors.white70,
                textColor: Colors.black87,
                iconColor: Colors.black87,
                width: 360,
              ),
              const SizedBox(height: 20.0), // Add spacing between button and text
              const Text(
                "No habits yet :)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(103, 255, 255, 255),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
