import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/src/models/habit_model.dart';
import 'package:habit_tracker/src/widgets/rounded_pill_button.dart';
import '../../widgets/my_app_bar.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  final String title = "Habit Tracker";

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _targetNumberController = TextEditingController();
  HabitType _selectedType = HabitType.daily;
  final List<String> _selectedDaysOfWeek = [];

  Future<void> _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      try {
        HabitModel newHabit = HabitModel(
          userId: FirebaseAuth.instance.currentUser!.uid.toString(),
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          type: _selectedType,
          createdAt: DateTime.now(),
          targetNumber: int.tryParse(_targetNumberController.text),
          daysOfWeek:
              _selectedType == HabitType.weekly ? _selectedDaysOfWeek : null,
        );

        await FirebaseFirestore.instance.collection('habits').add({
          ...newHabit.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) {
          return; 
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) {
          return; 
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding habit: $e')),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
      filled: true,
      fillColor: Colors.black,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration('Habit Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a habit name';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _buildInputDecoration('Description'),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<HabitType>(
                  value: _selectedType,
                  items: HabitType.values.map((type) {
                    return DropdownMenuItem(
                        value: type, child: Text(type.name));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                  decoration: _buildInputDecoration('Habit Type'),
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _targetNumberController,
                  decoration: _buildInputDecoration('Target Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a target number';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                if (_selectedType == HabitType.weekly)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Days of the Week',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (var day in [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ])
                            FilterChip(
                              label: Text(day,
                                  style: const TextStyle(color: Colors.white)),
                              selected: _selectedDaysOfWeek.contains(day),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedDaysOfWeek.add(day);
                                  } else {
                                    _selectedDaysOfWeek.remove(day);
                                  }
                                });
                              },
                              backgroundColor: Colors.black,
                              selectedColor: Colors.grey,
                            ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: RoundedPillButton(
                    radius: 16,
                    onPressed: _saveHabit,
                    text: "Create Habit",
                    icon: Icons.add_circle_rounded,
                    backgroundColor: Colors.white70,
                    textColor: Colors.black87,
                    iconColor: Colors.black87,
                    width: 360,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
