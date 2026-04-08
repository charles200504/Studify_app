import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});
  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _isListView = true;

  @override
  Widget build(BuildContext context) {
    const Color tealHeader = Color(0xFF004D56);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
            decoration: const BoxDecoration(color: tealHeader),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text("Reminders", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                  ],
                ),
                const SizedBox(height: 20),
                // Toggle Switcher
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: const Color(0xFF003D44), borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      _buildTab("List View", Icons.list, _isListView),
                      _buildTab("Calendar View", Icons.calendar_today, !_isListView),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Stats Row
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("5", "Total"),
                _buildStatCard("2", "Study"),
                _buildStatCard("1", "Events"),
                _buildStatCard("2", "Tasks"),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _reminderCard("Math Exam Prep", "Review Chapters 1-5", "Mar 20", "High", const Color(0xFFB8CDE1)),
                _reminderCard("Physics Lab Due", "Submit Newton Law report", "Mar 19", "High", const Color(0xFFD9C0E0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, bool active) => Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _isListView = label == "List View"),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: active ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: active ? Colors.black : Colors.white70),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: active ? Colors.black : Colors.white70, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );

  Widget _buildStatCard(String val, String lab) => Container(
    width: 75, padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Column(children: [Text(val, style: const TextStyle(fontWeight: FontWeight.bold)), Text(lab, style: const TextStyle(fontSize: 10, color: Colors.grey))]),
  );

  Widget _reminderCard(String t, String d, String date, String p, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(20)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Icon(Icons.edit, size: 18, color: Colors.black45),
        ]),
        const SizedBox(height: 5),
        Text(d, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: p == "High" ? Colors.red : Colors.orange, borderRadius: BorderRadius.circular(10)),
            child: Text(p, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ]),
      ],
    ),
  );
}
