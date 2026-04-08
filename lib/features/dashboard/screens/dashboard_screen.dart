import 'package:flutter/material.dart';
import '../../reminders/screens/reminders_screen.dart';
import '../../reminders/pomodoro/timer_screen.dart';
import '../../tracker/screens/study_streak_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) onSeeAllPressed;

  DashboardScreen({super.key, required this.onSeeAllPressed});

  final List<Map<String, dynamic>> allTasks = [
    {"title": "test case", "status": "Overdue", "date": "Today", "color": const Color(0xFF8EDCE6)},
    {"title": "CGP", "status": "Pending", "date": "Today", "color": const Color(0xFF6799C1)},
    {"title": "MAD", "status": "Pending", "date": "Today", "color": const Color(0xFF8E8CD8)},
    {"title": "Final Project", "status": "Pending", "date": "Apr 25", "color": Colors.white},
    {"title": "Lab Exam", "status": "Pending", "date": "May 02", "color": Colors.white},
  ];

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xFF0D2B45);

    final todaysTasks = allTasks.where((t) => t['date'] == 'Today');
    final upcomingDeadlines = allTasks.where((t) => t['date'] != 'Today');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, darkNavy),
            _buildSectionTitle("Daily Goal", null),
            _buildDailyGoalCard(),
            _buildSectionTitle("Today's Task", () => onSeeAllPressed(2)),

            ...todaysTasks.map((task) => _buildTaskItem(task['title'], task['color'])),

            _buildSectionTitle("Upcoming Deadlines", null),

            ...upcomingDeadlines.map((task) => _buildDeadlineItem(task['title'])),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildSectionTitle(String title, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D2B45))),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: const Text("See all",
                  style: TextStyle(color: Color(0xFF2FA2B1), fontWeight: FontWeight.bold, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  // FIXED THIS METHOD: Removed 'const' from BoxDecoration
  Widget _buildHeader(BuildContext context, Color darkNavy) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(25, 60, 25, 40),
    decoration: BoxDecoration( // Removed 'const' here
        color: darkNavy,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)
        )
    ),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text("Good morning, Alex", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Row(children: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RemindersScreen()))),
          IconButton(icon: const Icon(Icons.timer_outlined, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TimerScreen()))),
        ])
      ]),
      const SizedBox(height: 25),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _stat(context, "Study Streak", "7 Days", hasFire: true, isClickable: true),
        _stat(context, "This week", "14.5 hrs"),
      ]),
    ]),
  );

  Widget _stat(BuildContext context, String l, String v, {bool hasFire = false, bool isClickable = false}) => GestureDetector(
    onTap: isClickable ? () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const StudyStreakScreen()));
    } : null,
    child: Container(
      color: Colors.transparent,
      child: Column(children: [
        Text(l, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasFire) const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 24),
            if (hasFire) const SizedBox(width: 4),
            Text(v, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ]),
    ),
  );

  Widget _buildDailyGoalCard() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 25),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: const Color(0xFFF5F7F9), borderRadius: BorderRadius.circular(20)),
    child: Row(children: [
      const CircularProgressIndicator(value: 0.7, color: Color(0xFF0D2B45), backgroundColor: Colors.white),
      const SizedBox(width: 20),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("70% Completed", style: TextStyle(fontWeight: FontWeight.bold)),
        const Text("Keep going! You're almost there", style: TextStyle(color: Colors.grey, fontSize: 11)),
      ])
    ]),
  );

  Widget _buildTaskItem(String title, Color color) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
    child: Row(children: [
      const Icon(Icons.circle, size: 8, color: Colors.black26),
      const SizedBox(width: 15),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _buildDeadlineItem(String title) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF0F0F0))
    ),
    child: Row(children: [
      const Icon(Icons.square, size: 10, color: Color(0xFF0D2B45)),
      const SizedBox(width: 15),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    ]),
  );
}