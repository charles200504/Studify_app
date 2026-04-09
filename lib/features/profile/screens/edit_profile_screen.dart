import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameC;
  late TextEditingController _emailC;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: "Loading...");
    _emailC = TextEditingController(text: "Loading...");

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((snapshot) {
        if (mounted) {
          setState(() {
            _nameC.text = snapshot.data()?['name'] ?? "";
            _emailC.text = snapshot.data()?['email'] ?? user.email ?? "";
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xFF0D2B45);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: darkNavy, fontWeight: FontWeight.bold)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: darkNavy),
            onPressed: () => Navigator.pop(context)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 60, backgroundColor: Color(0xFFF5F7F9), child: Icon(Icons.camera_alt, size: 40, color: Colors.grey)),
            const SizedBox(height: 40),
            TextField(controller: _nameC, decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 20),
            TextField(controller: _emailC, decoration: InputDecoration(labelText: "Email Address", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 100),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: darkNavy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      // We only update the Firestore Database visual profile to avoid authentication token expirations

                      // Save Profile Data
                      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                        'name': _nameC.text,
                        'email': _emailC.text,
                      }, SetOptions(merge: true));
                      
                      if(!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated!"), backgroundColor: Colors.green));
                      Navigator.pop(context);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent));
                    }
                  }
                },
                child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}