import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String userEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (mounted && snapshot.exists) {
          setState(() {
            userName = snapshot.data()?['name'] ?? "Alex Johnson";
            userEmail = snapshot.data()?['email'] ?? user.email ?? "alex.j@study.com";
          });
        }
      });
    }
  }

  void _editProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
  }

  // --- FULLY WORKING LOGOUT ---
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // 1. Close the dialog first
              Navigator.pop(context);

              // 2. Clear all screens and go to Login
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) =>
                      false, // This deletes the history so they can't go "back"
                );
              }
            },
            child: const Text("Logout",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xFF0D2B45);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            width: double.infinity,
            color: darkNavy,
            child: Column(
              children: [
                const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: darkNavy)),
                const SizedBox(height: 15),
                Text(userName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text(userEmail,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.edit, color: darkNavy),
            title: const Text("Edit Profile"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _editProfile,
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
