import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/theme_providers.dart';
import '../utils/mediaquery.dart';
import 'main_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Email and Password are required.");
      return;
    }

      if (email == "manuvelvictor@gmail.com" && password == "Test@123") {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        _showSnackbar("Login failed. Please try again.");
    }
  }


  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQueryHelper = MediaQueryHelper(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Login",
          style: TextStyle(
            fontSize: mediaQueryHelper.scaledFontSize(0.07),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mediaQueryHelper.scaledWidth(0.04)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Lottie.asset(
                'assets/anim/login_register.json',
                height: mediaQueryHelper.scaledWidth(0.5),
                width: mediaQueryHelper.scaledWidth(0.5),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: mediaQueryHelper.scaledHeight(0.02)),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize:
                Size(double.infinity, mediaQueryHelper.scaledHeight(0.06)),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(mediaQueryHelper.scaledWidth(0.02)),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mediaQueryHelper.scaledFontSize(0.04),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
