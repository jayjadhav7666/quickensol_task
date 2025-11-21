import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'user_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _boxSize = 0.0;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();


    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _boxSize = 160;
        _opacity = 1.0;
      });
    });

    Timer(const Duration(milliseconds: 1800), () async {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.checkLoginStatus();
      if (auth.loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserListScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              width: _boxSize,
              height: _boxSize,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _opacity,
                child: Center(
                  child: Text(
                    'User Manager',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 900),
              opacity: _opacity,
              child: const Text(
                'Manage users with ease',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
