import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 60, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0D2B45), Color(0xFF163E5F)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22), onPressed: () => Navigator.pop(context)),
                    const Text("Study planner", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const Text("< March 2026 >", style: TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: DateTime.utc(2026, 3, 16),
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    calendarStyle: const CalendarStyle(
                      defaultTextStyle: TextStyle(color: Colors.white70),
                      weekendTextStyle: TextStyle(color: Colors.white70),
                      todayDecoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today's Sessions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("March 16", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _buildSessionTile("Calculas Study", "2 hours. Mathematics", true),
                  _buildSessionTile("Essay Writing", "1 hour. Litrature", false),
                  _buildSessionTile("Chemistry Revision", "45 min. Chemistry", false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTile(String title, String subtitle, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          const Icon(Icons.circle, color: Color(0xFF4A90E2), size: 12),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3E4A89))), Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13))])),
          Container(width: 35, height: 35, decoration: BoxDecoration(color: isCompleted ? const Color(0xFF9E8CF2) : const Color(0xFFD1C4E9), shape: BoxShape.circle), child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 20) : null),
        ],
      ),
    );
  }
}