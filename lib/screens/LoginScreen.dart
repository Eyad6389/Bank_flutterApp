import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/BankAccount.dart';
import 'package:flutter_application_1/screens/SignupScreen.dart';
import 'package:flutter_application_1/widgets/CustomTextfield.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController(); // Controller to capture user email input
  final TextEditingController _passwordController = TextEditingController(); // Controller to capture user password input
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase authentication instance
  bool _isLoading = false; // Indicates whether login is in progress
  bool _obscurePassword = true; // Controls password visibility

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempts to sign in with email and password using Firebase Auth
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        // Shows success message and navigates to the BankAccount screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BankAccountPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handles different login error types
      String errorMessage = 'Login failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Login failed: ${e.message}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      // Stop the loading spinner once login attempt completes
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _togglePasswordVisibility() {
    // Toggles the password field between visible and obscured
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve screen dimensions using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true, // Allows body content behind transparent app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Returns to the previous screen
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xff5D56C8), // Background color of login screen
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08, // Responsive horizontal padding
            vertical: screenHeight * 0.05, // Responsive vertical padding
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.account_balance,
                size: screenHeight * 0.08, // Responsive icon size
                color: Colors.white,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: screenHeight * 0.04, // Responsive text size
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              // Custom email text field
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Custom password text field with visibility toggle
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Typically would lead to a password reset flow
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login, // Disables button if loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 107, 100, 198),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // Responsive button padding
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Log In',
                          style: TextStyle(fontSize: 18.0),
                        ),
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      // Navigates to the sign-up screen and replaces current route
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
