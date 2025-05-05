import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/LoginScreen.dart';
import 'package:flutter_application_1/screens/SignupScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the full screen height and width using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows the body to appear behind the app bar (e.g., for transparent backgrounds)
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Makes AppBar background invisible
        elevation: 0, // Removes shadow
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_balance,
                    color: Colors.white, size: 30),
                SizedBox(
                    width: screenWidth * 0.04), // Responsive horizontal spacing
                Text(
                  'C-BANK',
                  style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.075, // Responsive font size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.7, // Responsive height for image
            child: Image.asset(
              'assests/images/Homescreen.png',
              fit: BoxFit
                  .cover, // Ensures image covers the container proportionally
            ),
          ),
          Expanded(
            child: SafeArea(
              top:
                  false, // Avoids padding at the top of SafeArea to overlap image
              child: SingleChildScrollView(
                // Allows scrolling if content overflows
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          screenWidth * 0.04), // Responsive horizontal padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: screenHeight * 0.02), // Responsive spacing
                      Text(
                        'Banking Made Easy',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.06, // Responsive text size
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Padding(
                        padding: EdgeInsets.all(
                            screenWidth * 0.02), // Responsive padding
                        child: Text(
                          'A modern approach to managing your finances. Our friendly experts are here to simplify your banking experience.',
                          style: GoogleFonts.poppins(
                              fontSize:
                                  screenWidth * 0.035), // Responsive text size
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: const Color(0xff5D56C8),
                              fixedSize: Size(
                                  screenWidth * 0.4,
                                  screenHeight *
                                      0.07), // Responsive button size
                            ),
                            onPressed: () {
                              // Navigates to the login screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.045, // Responsive text
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: const Color(0xff5D56C8),
                              fixedSize: Size(
                                  screenWidth * 0.4,
                                  screenHeight *
                                      0.07), // Responsive button size
                            ),
                            onPressed: () {
                              // Navigates to the signup screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.045, // Responsive text
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone,
                              size: screenWidth * 0.04,
                              color: Colors.grey[500]),
                          SizedBox(width: screenWidth * 0.015),
                          Text(
                            'For help call 19322',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03, // Responsive text
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
