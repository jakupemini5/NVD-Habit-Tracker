import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_history_entry.dart';
import 'package:habit_tracker/src/screens/habit/create_habit_screen.dart';
import 'package:habit_tracker/src/models/habit_model.dart';
import 'package:habit_tracker/src/screens/habit/habit_detail_screen.dart';
import 'package:habit_tracker/src/widgets/habbit_card.dart';
import 'package:habit_tracker/src/widgets/rounded_pill_button.dart';
import '../../widgets/my_app_bar.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  final String title = "Habit Tracker";

  @override
  State<HabitsScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoundedPillButton(
              radius: 16,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateHabitScreen()),
                );
              },
              text: "Create Habit",
              icon: Icons.add_circle_rounded,
              backgroundColor: Colors.white70,
              textColor: Colors.black87,
              iconColor: Colors.black87,
              width: 10000,
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('habits')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No habits yet :)",
                        style: TextStyle(
                          color: Color.fromARGB(103, 255, 255, 255),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var habitData = snapshot.data!.docs[index];

                      List<HabitHistoryEntry> history = [];
                      if (habitData['history'] != null) {
                        history = (habitData['history'] as List)
                            .map((entry) => HabitHistoryEntry(
                                  date: DateTime.parse(entry[
                                      'date']), // Convert string to DateTime
                                  numberReached: entry['numberReached'],
                                ))
                            .toList();
                      }

                      HabitModel habit = HabitModel(
                        userId: habitData['userId'],
                        name: habitData['name'],
                        description: habitData['description'],
                        type: HabitType.values.firstWhere(
                            (type) => type.name == habitData['type']),
                        createdAt:
                            (habitData['createdAt'] as Timestamp?)?.toDate(),
                        updatedAt:
                            (habitData['updatedAt'] as Timestamp?)?.toDate(),
                        daysOfWeek: (habitData['daysOfWeek'] as List?)
                            ?.map((e) => e as String)
                            .toList(),
                        dayOfMonth: habitData['dayOfMonth'],
                        targetNumber: habitData['targetNumber'],
                        habitId: habitData.id,
                        history: history
                      );
                      return Hero(
                        tag: 'habit_${habit.name}', // Add this line
                        child: HabitCard(
                          habit: habit,
                          onClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HabitDetailScreen(habit: habit),
                              ),
                            );
                          },
                        ),
                      );
                    },
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
