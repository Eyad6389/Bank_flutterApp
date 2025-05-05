import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/BankAccount.dart';
import 'package:flutter_application_1/screens/Homescreen.dart';

import 'package:flutter_application_1/widgets/BalanceTxnSection.dart';
import 'package:flutter_application_1/widgets/confirmlogoutalert.dart';
import 'package:flutter_application_1/widgets/profileActions.dart';
import 'package:flutter_application_1/widgets/profileAvatar.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;

  const ProfilePage({
    Key? key,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _saving = false;
  double _balance = 0.0;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _fetchAccountData();
  }

  // Asynchronously fetches the user's account data from Firestore.
  Future<void> _fetchAccountData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot accountSnap = await FirebaseFirestore.instance
            .collection('accounts')
            .doc(user.uid)
            .get();

        if (accountSnap.exists) {
          final accountData = accountSnap.data() as Map<String, dynamic>?;
          setState(() {
            // Get the balance from the account data, defaulting to 0.0 if null.
            _balance = (accountData?['balance'] as num?)?.toDouble() ?? 0.0;
            // Get the last 2 transactions, if any, reverse their order, and store them.
            _transactions =
                (accountData?['transactions'] as List<dynamic>? ?? [])
                    .cast<Map<String, dynamic>>()
                    .reversed
                    .take(2)
                    .toList();
          });
        }
      } catch (e) {
        print('Error fetching account data: $e');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Asynchronously saves the updated profile name to Firestore.
  Future<void> _saveProfile() async {
    // Validate the form. If not valid, return.
    if (!_formKey.currentState!.validate()) return;
    // Get the trimmed new name from the text controller.
    final newName = _nameController.text.trim();
    // Set the saving state to true to indicate that the operation is in progress.
    setState(() => _saving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      // If the user is logged in and the new name is different from the current name.
      if (user != null && newName != widget.name) {
        // Update the 'fullName' field in the user's document in the 'users' collection.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fullName': newName});
      }

      // Show a success snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
    } catch (e) {
      debugPrint('Error saving profile: $e');
      // Show an error snackbar if saving fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      // Set the saving state back to false, regardless of success or failure.
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the width of the screen.
    final screenWidth = MediaQuery.of(context).size.width;
    // Get the height of the screen.
    final screenHeight = MediaQuery.of(context).size.height;
    // Determine if the screen width is considered small.
    final isSmallScreen = screenWidth < 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // This callback is invoked when a pop attempt is made.
        // 'didPop' is true if the pop completed, false otherwise.
        // 'result' is the data passed back from the popped route, if any.
        if (!didPop) {
          // If the pop was not handled by the system (e.g., back button press),
          // navigate to the BankAccountPage, replacing the current route.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BankAccountPage(),
            ),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              // Navigate to the BankAccountPage, replacing the current route.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BankAccountPage(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              // Set the height of the background image container based on screen height.
              height: screenHeight * 0.25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assests/images/pfpBg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              // Position the profile avatar below the background image.
              top: screenHeight * 0.25 - (isSmallScreen ? 50 : 60),
              child: ProfileAvatar(isSmallScreen: isSmallScreen),
            ),
            Padding(
              // Add padding below the background image area.
              padding: EdgeInsets.only(top: screenHeight * 0.25),
              child: SingleChildScrollView(
                // Make the content scrollable.
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Add vertical space.
                      SizedBox(height: isSmallScreen ? 60 : 70),
                      Text(
                        widget.email,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      // Add vertical space.
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter a name' : null,
                      ),
                      // Add vertical space.
                      SizedBox(height: screenHeight * 0.03),
                      AccountSummary(
                        balance: _balance,
                        transactions: _transactions,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        isSmallScreen: isSmallScreen,
                      ),
                      // Add vertical space.
                      SizedBox(height: screenHeight * 0.04),
                      ProfileActions(
                        saving: _saving,
                        onSave: _saveProfile,
                        onLogout: () async {
                          // Show a confirmation dialog before logging out.
                          final confirm = await confirmlogoutscreen(context);
                          if (confirm) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Homescreen()),
                              (route) => false, // Remove all existing routes.
                            );
                          }
                        },
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),
                      // Add vertical space.
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
