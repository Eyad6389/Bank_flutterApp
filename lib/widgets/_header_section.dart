import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/_action_button.dart';

class HeaderSection extends StatelessWidget {
  final String fullName;
  final double balance;
  final VoidCallback onDepositTap;
  final VoidCallback onWithdrawTap;
  final double screenHeight;
  final double screenWidth;

  const HeaderSection({
    required this.fullName,
    required this.balance,
    required this.onDepositTap,
    required this.onWithdrawTap,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assests/images/bankpagebg.png'), fit: BoxFit.cover),
        color: Color(0xff5D56C8),
      ),
      child: Padding(
        // Add padding around the content based on screen width.
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add vertical spacing based on screen height.
            SizedBox(height: screenHeight * 0.12),
            const Text('Welcome', style: TextStyle(fontSize: 16, color: Colors.white70)),
            Text(fullName,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text('Your Current Balance',
                style: TextStyle(fontSize: 14, color: Colors.white70)),
            Text('${balance.toStringAsFixed(2)} EGP',
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text('Latest update shown as of today,',
                style: TextStyle(fontSize: 12, color: Colors.white)),
            const Text('transactions may take time to reflect.',
                style: TextStyle(fontSize: 12, color: Colors.white)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  icon: Icons.arrow_upward,
                  label: 'Deposit',
                  onTap: onDepositTap,
                ),
                ActionButton(
                  icon: Icons.arrow_downward,
                  label: 'Withdraw',
                  onTap: onWithdrawTap,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}