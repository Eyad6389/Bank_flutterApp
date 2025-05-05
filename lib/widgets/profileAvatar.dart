import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final bool isSmallScreen;

  const ProfileAvatar({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: isSmallScreen ? 50 : 60,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: isSmallScreen ? 46 : 56,
        backgroundColor: Colors.indigo.shade100,
        child: Icon(
          Icons.person,
          size: isSmallScreen ? 60 : 70,
          color: const Color(0xff5D56C8),
        ),
      ),
    );
  }
}
