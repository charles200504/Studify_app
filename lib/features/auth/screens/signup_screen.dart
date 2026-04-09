import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Header Design
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0D2B45),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Icon(Icons.person_add_alt_1, size: 60, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                   // NAME FIELD
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // EMAIL FIELD
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD FIELD
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Create a password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // SIGN UP BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D2B45),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        String name = _nameController.text.trim();
                        String email = _emailController.text.trim();
                        String pass = _passwordController.text.trim();

                        if (name.isNotEmpty && email.isNotEmpty && pass.isNotEmpty) {
                          try {
                            // 1. Create secure account
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email,
                              password: pass,
                            );

                            // 2. Add profile metadata
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                                'name': name,
                                'email': email,
                                'profilePic': '',
                              });
                            }

                            if (mounted) {
                              // We explicitly log out the background session creation so they must use the Login Screen to enter!
                              await FirebaseAuth.instance.signOut();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Account Created Successfully! Please Log In.'), backgroundColor: Colors.green)
                              );

                              Navigator.pop(context); // Go back exactly to Login Screen!
                            }
                          } on FirebaseAuthException catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message ?? 'Registration failed'), backgroundColor: Colors.redAccent)
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields!'), backgroundColor: Colors.redAccent)
                          );
                        }
                      },
                      child: const Text('CREATE ACCOUNT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 10),

                  // LOGIN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?", style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to login screen
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(color: Color(0xFF0D2B45), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
