import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'study_streak_screen.dart';

class ProgressTrackingScreen extends StatefulWidget {
  const ProgressTrackingScreen({super.key});

  @override
  State<ProgressTrackingScreen> createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  String _currentTimeFilter = "Semester";
  String _currentTab = "Study Sessions";

  int _streakDays = 0;
  double _totalHours = 0.0;
  int _completedAssignments = 0;
  String _productivityStr = "0%";

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('streak').doc('current').snapshots().listen((snapshot) {
      if (mounted && snapshot.exists && snapshot.data()!.containsKey('activity')) {
        List<dynamic> data = snapshot.data()!['activity'];
        int streak = data.where((e) => e == true).length;
        setState(() {
          _streakDays = streak;
        });
      }
    });

    FirebaseFirestore.instance.collection('pomodoro').doc('stats').snapshots().listen((snapshot) {
      if (mounted && snapshot.exists) {
        int minutes = snapshot.data()!['minutes'] ?? 0;
        setState(() {
          _totalHours = minutes / 60.0;
        });
      }
    });

    FirebaseFirestore.instance.collection('assignments').snapshots().listen((snapshot) {
      if (mounted && snapshot.docs.isNotEmpty) {
        int done = snapshot.docs.where((doc) => doc['status'] == 1).length; // 1 is done index
        int total = snapshot.docs.length;
        setState(() {
          _completedAssignments = done;
          if (total > 0) {
            _productivityStr = "${((done / total) * 100).toStringAsFixed(0)}%";
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color tealHeader = Color(0xFF004D56);
    const Color primaryPurple = Color(0xFF8E8CD8);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 50, 20, 30),
              decoration: const BoxDecoration(color: tealHeader),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Progress Tracking",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Clickable Time Filters
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        _buildFilterButton("This Week"),
                        const SizedBox(width: 10),
                        _buildFilterButton("This Month"),
                        const SizedBox(width: 10),
                        _buildFilterButton("Semester"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- 2x2 GRID (All cards are now interactive) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _buildInteractiveCard(
                    icon: Icons.emoji_events_outlined,
                    iconColor: Colors.orange,
                    label: "Study Streak",
                    value: "$_streakDays Days",
                    footer: "Keep it up! 🔥",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const StudyStreakScreen())),
                  ),
                  _buildInteractiveCard(
                    icon: Icons.access_time,
                    iconColor: Colors.blue,
                    label: "Total Hours",
                    value: "${_totalHours.toStringAsFixed(1)}h",
                    footer: "This week",
                    onTap: () => _showDetails(context, "Total Hours"),
                  ),
                  _buildInteractiveCard(
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                    label: "Completed",
                    value: "$_completedAssignments",
                    footer: "Assignments",
                    onTap: () => _showDetails(context, "Completed Assignments"),
                  ),
                  _buildInteractiveCard(
                    icon: Icons.trending_up,
                    iconColor: Colors.purple,
                    label: "Productivity",
                    value: _productivityStr,
                    footer: "Completion rate",
                    onTap: () => _showDetails(context, "Productivity Stats"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- CATEGORY TABS ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTab("Overview", primaryPurple),
                  _buildTab("Assignments", primaryPurple),
                  _buildTab("Study Sessions", primaryPurple),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- STUDY HOURS CHART ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Weekly Study Hours",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF102A43))),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(0.4, primaryPurple, "Mon"),
                        _buildBar(0.7, primaryPurple, "Tue"),
                        _buildBar(0.2, primaryPurple, "Wed"),
                        _buildBar(0.5, primaryPurple, "Thu"),
                        _buildBar(0.9, primaryPurple, "Fri"),
                        _buildBar(0.3, primaryPurple, "Sat"),
                        _buildBar(0.5, primaryPurple, "Sun"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildFilterButton(String title) {
    bool isSelected = _currentTimeFilter == title;
    return GestureDetector(
      onTap: () => setState(() => _currentTimeFilter = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF004D56) : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, Color purple) {
    bool isSelected = _currentTab == title;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = title),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? purple : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String footer,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor, size: 22),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(footer, style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double heightFactor, Color color, String day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 25,
          height: 100 * heightFactor,
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  void _showDetails(BuildContext context, String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Viewing detailed $category..."), duration: const Duration(seconds: 1)),
    );
  }
}
