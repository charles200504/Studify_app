import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 80, 25, 60),
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D2B45), Color(0xFF163E5F)]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40))),
            child: const Center(child: Text("Studify", style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold))),
          ),
          const Spacer(),
          ElevatedButton(onPressed: () => Navigator.pushReplacementNamed(context, '/main'), child: const Text("Sign In")),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}