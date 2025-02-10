import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:habit_tracker/src/widgets/rounded_pill_button.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 40.0, sigmaY: 40.0), // Adjust blur intensity
        child: AppBar(
          backgroundColor:
              Colors.black.withOpacity(0.0), // Semi-transparent black
          elevation: 0, // Remove shadow
          title: Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(200, 255, 255, 255),
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          actions: [
            RoundedPillButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              text: "Profile",
              icon:  Icons.account_circle_outlined,
              backgroundColor: Colors.white24,
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Set the height for the app bar
}
