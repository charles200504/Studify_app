import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// IMPORTANT: Make sure this path correctly points to your main_navigation.dart file
import '../../../main_navigation.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _viewDate = DateTime(2026, 3, 1);
  int _selectedDay = 13;

  List<Map<String, dynamic>> sessions = [
    {"title": "Calculus Study", "duration": "2 hours", "subject": "Mathematics", "isDone": true},
    {"title": "Essay Writing", "duration": "1 hour", "subject": "Literature", "isDone": true},
    {"title": "Chemistry Revision", "duration": "45 min", "subject": "Chemistry", "isDone": false},
  ];

  int get _daysInMonth => DateUtils.getDaysInMonth(_viewDate.year, _viewDate.month);

  int get _firstWeekdayOffset {
    int weekday = DateTime(_viewDate.year, _viewDate.month, 1).weekday;
    return weekday % 7;
  }

  void _nextMonth() => setState(() => _viewDate = DateTime(_viewDate.year, _viewDate.month + 1));
  void _prevMonth() => setState(() => _viewDate = DateTime(_viewDate.year, _viewDate.month - 1));

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xFF102A43);
    const Color primaryPurple = Color(0xFF8E8CD8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 50, 20, 30),
            decoration: const BoxDecoration(
              color: darkNavy,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                          onPressed: () {
                            // FIXED: Using direct navigation to avoid route name errors
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MainNavigation()),
                            );
                          },
                        ),
                        const Text("Study planner",
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white70, size: 24),
                          onPressed: _prevMonth,
                        ),
                        Text(
                          DateFormat('MMMM yyyy').format(_viewDate),
                          style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, color: Colors.white70, size: 24),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildDaysHeader(),
                      const SizedBox(height: 10),
                      _buildCalendarGrid(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Today's Sessions",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(DateFormat('MMMM d').format(DateTime(_viewDate.year, _viewDate.month, _selectedDay)),
                          style: const TextStyle(fontSize: 14, color: Colors.teal, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: sessions.length,
                      itemBuilder: (context, index) => _buildSessionItem(index, primaryPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysHeader() {
    final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return Row(
      children: days.map((day) => Expanded(
        child: Center(child: Text(day, style: const TextStyle(color: Colors.white60, fontSize: 12))),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final int totalSlots = _firstWeekdayOffset + _daysInMonth;

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: totalSlots,
      itemBuilder: (context, index) {
        if (index < _firstWeekdayOffset) {
          return const SizedBox.shrink();
        }

        final int day = index - _firstWeekdayOffset + 1;
        bool isSelected = day == _selectedDay;

        return GestureDetector(
          onTap: () => setState(() => _selectedDay = day),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withAlpha(50) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$day",
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSessionItem(int index, Color purple) {
    final session = sessions[index];
    bool isDone = session['isDone'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                  color: isDone ? Colors.teal : Colors.blueAccent,
                  shape: BoxShape.circle
              )
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    session['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF102A43),
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    )
                ),
                Text("${session['duration']}, ${session['subject']}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => sessions[index]['isDone'] = !isDone),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 35, height: 35,
              decoration: BoxDecoration(
                  color: isDone ? purple : purple.withAlpha(40),
                  shape: BoxShape.circle,
                  border: Border.all(color: purple, width: 2)
              ),
              child: isDone ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
            ),
          ),
        ],
      ),
    );
  }
}