import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback onLogout;
  final double screenHeight;
  final double screenWidth;

  const ProfileActions({
    required this.saving,
    required this.onSave,
    required this.onLogout,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: saving ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff5D56C8),
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.018,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: saving
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: ElevatedButton(
            onPressed: onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.018,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
