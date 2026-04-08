import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../tracker/screens/assignment_tracker_screen.dart';
import '../../tracker/screens/progress_tracking_screen.dart';
import '../../../models/assignment_model.dart'; // IMPORTANT IMPORT

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Logic for dynamic data
    final recentTasks = globalAssignments
        .where((a) => a.status != AssignmentStatus.done)
        .take(3)
        .toList();

    final upcomingDeadlines = globalAssignments
        .where((a) => a.status != AssignmentStatus.done)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    double progressValue = 0.0;
    if (globalAssignments.isNotEmpty) {
      int completedCount = globalAssignments.where((a) => a.status == AssignmentStatus.done).length;
      progressValue = completedCount / globalAssignments.length;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 60, 25, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0D2B45), Color(0xFF163E5F)],
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Good morning, Alex", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  _buildHeaderStreakCard(context),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  _buildGoalCard(progressValue),
                  const SizedBox(height: 25),
                  _buildSectionHeader(context, "Today's Task", "See all", const AssignmentTrackerScreen()),
                  ...recentTasks.map((t) => _buildTaskTile(t.title, const Color(0xFF8EDAE5))),
                  const SizedBox(height: 25),
                  _buildSectionHeader(context, "Upcoming Deadlines", "View All", const AssignmentTrackerScreen()),
                  ...upcomingDeadlines.take(2).map((a) => _buildDeadlineTile(a.title, DateFormat('MMM d').format(a.dueDate))),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: progress >= 1.0 ? const Color(0xFFE0F2F1) : const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? Colors.teal : const Color(0xFF8E8CD8))
              ),
              Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(progress >= 1.0 ? "Goal Finished!" : "Daily Goal", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(progress >= 1.0 ? "You're all done for today!" : "Keep pushing to finish your tasks.", style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStreakCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withAlpha(25), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("7 Days", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Study Streak", style: TextStyle(color: Colors.white70)),
            ],
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProgressTrackingScreen())),
            child: const Text("View Progress"),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String action, Widget target) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => target)),
            child: Text(action)
        ),
      ],
    );
  }

  Widget _buildTaskTile(String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.black26),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDeadlineTile(String title, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(date, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}