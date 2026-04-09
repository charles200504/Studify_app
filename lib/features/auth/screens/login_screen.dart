import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controllers to capture what you type
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Cleanup memory when the screen is closed
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Header Design
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0D2B45),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Studify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  // EMAIL FIELD
                  TextField(
                    controller: _usernameController,
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
                    obscureText: true, // This masks the password
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // LOGIN BUTTON
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
                        // THE LOGIN LOGIC
                        String email = _usernameController.text.trim();
                        String pass = _passwordController.text.trim();

                        if (email.isNotEmpty && pass.isNotEmpty) {
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email,
                              password: pass,
                            );
                            if (mounted) {
                              Navigator.pushReplacementNamed(context, '/main');
                            }
                          } on FirebaseAuthException catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message ?? 'Authentication failed'),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(20),
                                )
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        } else {
                          // ERROR: Show Red Message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter email and password!'),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(20),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // REGISTER LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => const SignupScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Color(0xFF0D2B45), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}