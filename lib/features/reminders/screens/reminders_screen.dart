import 'package:flutter/material.dart';
import '../pomodoro/timer_screen.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
            decoration: const BoxDecoration(color: Color(0xFF004D56)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Reminders", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.timer_outlined, color: Colors.white, size: 30), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TimerScreen()))),
                  ],
                ),
                const SizedBox(height: 25),
                Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15)), child: const Row(children: [Expanded(child: Center(child: Text("List View", style: TextStyle(color: Colors.white))))])),
              ],
            ),
          ),
          Expanded(child: Center(child: Text("Your Reminders List Here"))),
        ],
      ),
    );
  }
}