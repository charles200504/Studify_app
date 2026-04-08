import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xFF0D2B45);
    const Color primaryPurple = Color(0xFF8E8CD8);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Column(
        children: [
          // --- HEADER SECTION ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [darkNavy, Color(0xFF163E5F)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 65, color: Colors.white),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Alex Johnson",
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "alex.johnson@university.edu",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 25),
                // STATS ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat("12", "Notes"),
                    _buildStat("8", "Assignments"),
                    _buildStat("7", "Day Streak"),
                  ],
                ),
              ],
            ),
          ),

          // --- OPTIONS LIST ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              children: [
                _buildOptionTile(
                  icon: Icons.edit_outlined,
                  title: "Edit Profile",
                  color: primaryPurple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  ),
                ),
                _buildOptionTile(
                  icon: Icons.notifications_none_outlined,
                  title: "Notifications",
                  color: Colors.orange,
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: Icons.shield_outlined,
                  title: "Security",
                  color: Colors.teal,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                // LOGOUT
                ListTile(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.logout, color: Colors.red, size: 20),
                  ),
                  title: const Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }

  Widget _buildOptionTile({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF102A43))),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}