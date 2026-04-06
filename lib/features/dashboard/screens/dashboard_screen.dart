import 'package:flutter/material.dart';
import '../widgets/streak_card.dart';
import '../../planner/screens/planner_screen.dart';
import '../../notes/screens/notes_screen.dart';
import '../../tracker/screens/assignment_tracker_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  const StreakCard(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionHeader(context, "Today's Task", "See all", const AssignmentTrackerScreen()),
                  _buildTaskTile("Task 01", const Color(0xFF8EDAE5)),
                  _buildTaskTile("Task 02", const Color(0xFF70A1D7)),
                  _buildTaskTile("Task 03", const Color(0xFF8D86EF)),
                  const SizedBox(height: 20),
                  _buildSectionHeader(context, "Upcoming Deadlines", "View All", const AssignmentTrackerScreen()),
                  _buildDeadlineTile("Deadlines 01"),
                  _buildDeadlineTile("Deadlines 02"),
                  const SizedBox(height: 20),
                  const Text("Quick Access", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAccess(context, Icons.calendar_month, "planner", const PlannerScreen()),
                      _buildQuickAccess(context, Icons.edit_note, "notes", const NotesScreen()),
                      _buildQuickAccess(context, Icons.assignment, "assignment", const AssignmentTrackerScreen()),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String action, Widget target) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)), child: Text(action, style: const TextStyle(color: Colors.teal))),
      ],
    );
  }

  Widget _buildTaskTile(String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      child: Row(children: [const Icon(Icons.circle, size: 6, color: Colors.black26), const SizedBox(width: 15), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))]),
    );
  }

  Widget _buildDeadlineTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(15)),
      child: Row(children: [const Icon(Icons.square, size: 8, color: Colors.blue), const SizedBox(width: 15), Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))]),
    );
  }

  Widget _buildQuickAccess(BuildContext context, IconData icon, String label, Widget target) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
      child: Column(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.black87)), const SizedBox(height: 5), Text(label, style: const TextStyle(fontSize: 12))]),
    );
  }
}