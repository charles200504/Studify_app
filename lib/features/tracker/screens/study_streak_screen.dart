import 'package:flutter/material.dart';

class StudyStreakScreen extends StatefulWidget {
  const StudyStreakScreen({super.key});

  @override
  State<StudyStreakScreen> createState() => _StudyStreakScreenState();
}

class _StudyStreakScreenState extends State<StudyStreakScreen> {
  // Mock data for the activity grid (true = completed, false = missed)
  List<bool> activityData = List.generate(30, (index) => index >= 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 50, 20, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8E99EE), Color(0xFF6EC6D1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Study Streak",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Glassmorphic Center Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25), // Semi-transparent
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 55),
                        const Text(
                          "7",
                          style: TextStyle(color: Colors.white, fontSize: 65, fontWeight: FontWeight.w300),
                        ),
                        const Text(
                          "Day Streak",
                          style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.1),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Intermediate Level",
                            style: TextStyle(color: Color(0xFF6EC6D1), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- STATS ROW ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(Icons.emoji_events_outlined, "12", "Best Streak", Colors.orange),
                  _buildStatCard(Icons.calendar_month_outlined, "45", "Total Days", Colors.blue),
                  _buildStatCard(Icons.trending_up, "14.5h", "This Week", Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- INTERACTIVE ACTIVITY GRID ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black87),
                      SizedBox(width: 8),
                      Text("Last 30 Days Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, // 7 days a week look
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      bool isCompleted = activityData[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            activityData[index] = !activityData[index]; // Toggle on click
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isCompleted ? const Color(0xFF8E99EE) : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check, color: Colors.white, size: 14)
                                : Text("${index + 1}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend(Colors.grey.shade200, "Missed"),
                      const SizedBox(width: 25),
                      _buildLegend(const Color(0xFF8E99EE), "Completed"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- INTERACTIVE ACTION BANNER ---
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Motivation Activated! Keep it up!")),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.orange, Colors.redAccent]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.white, size: 32),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Don't Break the Chain!",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Click here to log today's progress!",
                              style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper for Stats Cards (Interactive with InkWell)
  Widget _buildStatCard(IconData icon, String value, String label, Color iconColor) {
    return InkWell(
      onTap: () {}, // Add navigation or details here
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
      ],
    );
  }
}