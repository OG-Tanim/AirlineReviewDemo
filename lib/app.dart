import 'package:airlineapp/screens/feed_screen.dart';
import 'package:airlineapp/screens/share_experience_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

class AirlineReviewApp extends StatelessWidget {
  const AirlineReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airline Review App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/feed': (context) => FeedScreen(),
        '/share': (context) => const ShareExperienceScreen(),
      },
    );
  }
}
