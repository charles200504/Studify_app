import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../reminders/screens/reminders_screen.dart';
import '../../reminders/pomodoro/timer_screen.dart';
import '../../tracker/screens/study_streak_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onSeeAllPressed;

  const DashboardScreen({super.key, required this.onSeeAllPressed});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _streakDays = 0;
  double _totalHoursThisWeek = 0.0;
  double _dailyGoalProgress = 0.0;
  String _userName = "Alex";

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots().listen((snapshot) {
        if (mounted && snapshot.exists) {
          setState(() {
            _userName = snapshot.data()?['name']?.split(' ')[0] ?? "Alex";
          });
        }
      });
    }

    FirebaseFirestore.instance.collection('streak').doc('current').snapshots().listen((snapshot) {
      if (mounted && snapshot.exists && snapshot.data()!.containsKey('activity')) {
        List<dynamic> data = snapshot.data()!['activity'];
        setState(() {
          _streakDays = data.where((e) => e == true).length;
        });
      }
    });

    FirebaseFirestore.instance.collection('pomodoro').doc('stats').snapshots().listen((snapshot) {
      if (mounted && snapshot.exists) {
        int minutes = snapshot.data()!['minutes'] ?? 0;
        setState(() {
          _totalHoursThisWeek = minutes / 60.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xFF0D2B45);

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('assignments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: darkNavy));

          final now = DateTime.now();
          final allDocs = snapshot.data!.docs;

          int doneTasks = 0;
          final List<Map<String, dynamic>> todaysTasks = [];
          final List<Map<String, dynamic>> upcomingDeadlines = [];

          for(var rawDoc in allDocs) {
            try {
              final doc = rawDoc.data() as Map<String, dynamic>? ?? {};
              
              // Handle status
              final status = doc['status'];
              if (status == 1 || status == "1" || status == 1.toString()) {
                doneTasks++;
              }

              // Handle date
              final rawDate = doc['dueDate'];
              DateTime dt = DateTime.now();
              if (rawDate is Timestamp) {
                dt = rawDate.toDate();
              } else if (rawDate is String) {
                dt = DateTime.parse(rawDate);
              }
              
              if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
                todaysTasks.add(doc);
              } else if (dt.isAfter(now.subtract(const Duration(days: 1)))) {
                upcomingDeadlines.add(doc);
              }
            } catch(e) {
              // Ignore malformed docs
            }
          }

          _dailyGoalProgress = allDocs.isEmpty ? 0.0 : (doneTasks / allDocs.length);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, darkNavy),
                _buildSectionTitle("Daily Goal", null),
                _buildDailyGoalCard(),
                _buildSectionTitle("Today's Task", () => widget.onSeeAllPressed(2)),

                ...todaysTasks.map((task) => _buildTaskItem(task['title']?.toString() ?? "Untitled", const Color(0xFF8EDCE6))),

                _buildSectionTitle("Upcoming Deadlines", null),

                ...upcomingDeadlines.map((task) => _buildDeadlineItem(task['title']?.toString() ?? "Untitled")),

                const SizedBox(height: 30),
              ],
            ),
          );
        }
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
        Text("Good morning, $_userName", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Row(children: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RemindersScreen()))),
          IconButton(icon: const Icon(Icons.timer_outlined, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TimerScreen()))),
        ])
      ]),
      const SizedBox(height: 25),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _stat(context, "Study Streak", "$_streakDays Days", hasFire: true, isClickable: true),
        _stat(context, "This week", "${_totalHoursThisWeek.toStringAsFixed(1)} hrs"),
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
      CircularProgressIndicator(value: _dailyGoalProgress, color: const Color(0xFF0D2B45), backgroundColor: Colors.white),
      const SizedBox(width: 20),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${(_dailyGoalProgress * 100).toStringAsFixed(0)}% Completed", style: const TextStyle(fontWeight: FontWeight.bold)),
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
