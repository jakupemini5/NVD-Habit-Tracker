import 'package:flutter/material.dart';
import '../../widgets/my_app_bar.dart';

class CreateHabitScreen extends StatefulWidget {
  CreateHabitScreen({super.key});

  final String title = "Habbit tracker";

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      backgroundColor: Colors.black,
      body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
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
