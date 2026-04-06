import 'package:flutter/material.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/planner/screens/planner_screen.dart';
import 'features/tracker/screens/assignment_tracker_screen.dart';
import 'features/reminders/screens/reminders_screen.dart';
import 'features/notes/screens/notes_screen.dart';
import 'features/tracker/screens/progress_tracking_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PlannerScreen(),
    const AssignmentTrackerScreen(),
    const RemindersScreen(),
    const NotesScreen(),
    const ProgressTrackingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3E4A89),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: ''),
        ],
      ),
    );
  }
}