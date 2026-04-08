import 'package:flutter/material.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/planner/screens/planner_screen.dart';
import 'features/tracker/screens/assignment_tracker_screen.dart';
import 'features/notes/screens/notes_screen.dart';

// 1. Keep this commented out until your teammate fixes their class naming
// import 'features/profile/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. Renamed to 'screens' (removed underscore) to fix the warning
    final List<Widget> screens = [
      DashboardScreen(onSeeAllPressed: _onItemTapped),
      const PlannerScreen(),
      const AssignmentTrackerScreen(),
      const NotesScreen(),
      const ProfilePlaceholder(), // 3. Use the placeholder for now
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0D2B45),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// 4. TEMPORARY PLACEHOLDER: This keeps the app from crashing.
// Once your friend fixes the ProfileScreen, delete this and the call above.
class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Profile Screen Loading...\n(Waiting for group member update)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}