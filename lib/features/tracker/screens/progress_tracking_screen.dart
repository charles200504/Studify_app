import 'package:flutter/material.dart';
import 'study_streak_screen.dart';

class ProgressTrackingScreen extends StatelessWidget {
  const ProgressTrackingScreen({super.key});

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
            child: const Text("Progress Tracking", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildStatCard(context, "Study Streak", "7 Days", "Keep it up!", Icons.local_fire_department, Colors.orange, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const StudyStreakScreen()));
                }),
                const SizedBox(width: 15),
                _buildStatCard(context, "Hours", "5.5h", "This week", Icons.timer, Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String val, String sub, IconData icon, Color col, {VoidCallback? onTap}) {
    return Expanded(child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: col), Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(color: Colors.grey))]))));
  }
}