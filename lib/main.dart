import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
        primaryColor: const Color(0xFF0D2B45),
        fontFamily: 'Poppins',
      ),
      // We start at /main to see your hard work immediately!
      initialRoute: '/main',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainNavigation(),
      },
    );
  }
}