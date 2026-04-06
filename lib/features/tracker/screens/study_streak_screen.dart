import 'package:flutter/material.dart';

class StudyStreakScreen extends StatelessWidget {
  const StudyStreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 50, 25, 40),
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF6A93CB), Color(0xFFAEA1E5)])),
            child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Navigator.pop(context)), const Text("Study Streak", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))]),
          ),
          const Expanded(child: Center(child: Text("Streak Heatmap UI Here"))),
        ],
      ),
    );
  }
}