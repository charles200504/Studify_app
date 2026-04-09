import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../planner/screens/planner_screen.dart'; // Import the screen you want to open

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1D3E5E), // Match your dark blue theme
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('streak').doc('current').snapshots(),
            builder: (context, snapshot) {
              int streak = 0;
              if (snapshot.hasData && snapshot.data!.exists && snapshot.data!.data() != null && (snapshot.data!.data() as Map).containsKey('activity')) {
                List<dynamic> data = snapshot.data!['activity'];
                streak = data.where((e) => e == true).length;
              }
              return Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 35),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$streak Days",
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Study Streak",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              );
            }
          ),

          // --- THE FUNCTIONAL BUTTON ---
          ElevatedButton(
            onPressed: () {
              // 1. Check the 'Run' tab in Android Studio for this message!
              print("QA_LOG: View Progress Button Tapped");

              // 2. Navigate to the Planner Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlannerScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0D2B45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              "View Progress",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
