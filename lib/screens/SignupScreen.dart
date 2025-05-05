import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/widgets/CustomTextfield.dart'; // Custom text field widget

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers to retrieve input from text fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Firebase Authentication and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false; // Used to show loading indicator during signup
  bool _obscurePassword = true; // Toggles password visibility
  bool _obscureConfirmPassword = true; // Toggles confirm password visibility

  void _signup() async {
    // Check if passwords match before creating account
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save additional user data to Firestore if account creation succeeds
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'creationTime':
              FieldValue.serverTimestamp(), // Server-generated timestamp
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Signup Successful, Login to proceed')),
          );
          // Navigate to login page after successful signup
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle common signup errors
      String errorMessage = 'Signup failed';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'Signup failed: ${e.message}';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Catch any other unexpected errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Toggle visibility for password field
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Toggle visibility for confirm password field
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows background to extend behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xff5D56C8),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, // Responsive horizontal padding
            vertical: screenHeight * 0.04, // Responsive vertical padding
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.account_balance,
                size: screenHeight * 0.08, // Responsive icon size
                color: Colors.white,
              ),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(height: screenHeight * 0.04),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: screenHeight * 0.04, // Responsive title size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Input field for full name
              CustomTextField(
                controller: _fullNameController,
                labelText: 'Full Name',
                prefixIcon: Icons.person_outline,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Input field for email
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Input field for password
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
              SizedBox(height: screenHeight * 0.02),
              // Input field for confirming password
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _signup, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 107, 100, 198),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          screenHeight * 0.02, // Responsive vertical padding
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Have an account?',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
