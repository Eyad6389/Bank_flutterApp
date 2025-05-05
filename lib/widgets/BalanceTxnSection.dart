import 'package:flutter/material.dart';

class AccountSummary extends StatelessWidget {
  final double balance;
  final List<Map<String, dynamic>> transactions;
  final double screenHeight;
  final double screenWidth;
  final bool isSmallScreen;

  const AccountSummary({
    required this.balance,
    required this.transactions,
    required this.screenHeight,
    required this.screenWidth,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Add horizontal and vertical padding based on screen dimensions.
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance: ${balance.toStringAsFixed(2)} EGP',
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add vertical spacing based on screen height.
          SizedBox(height: screenHeight * 0.015),
          const Text(
            'Latest Transactions:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add vertical spacing based on screen height.
          SizedBox(height: screenHeight * 0.01),
          if (transactions.isEmpty)
            const Text('No transactions available.')
          else
            ...transactions.map((transaction) {
              final isDeposit = transaction['type'].toLowerCase() == 'deposit';
              final amount = transaction['amount'] as num;
              final formattedAmount =
                  '${isDeposit ? '+' : '-'}${amount.toStringAsFixed(2)} EGP';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  formattedAmount,
                  style: TextStyle(
                    color: isDeposit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${transaction['type']} - ${transaction['timestamp'].toDate()}',
                ),
              );
            }),
        ],
      ),
    );
  }
}
