import 'package:flutter/material.dart';
import 'package:habit_tracker/src/screens/habit/create_habit_screen.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/rounded_pill_button.dart';

class HabitsScreen extends StatefulWidget {
  HabitsScreen({super.key});

  final String title = "Habbit tracker";

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundedPillButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateHabitScreen()),
                );
              },
              text: "Create Habbit",
              icon:  Icons.add_circle_rounded,
              backgroundColor: Colors.white70,
              textColor: Colors.black87,
              iconColor: Colors.black87,
              width: 360,
            ),
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
    );
  }
}
