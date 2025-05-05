import 'package:flutter/material.dart';

class DeleteTransactionsButton extends StatelessWidget {
  final VoidCallback onDeleteTap;

  const DeleteTransactionsButton({required this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      right: screenWidth * 0.04,
      bottom: 16,
      child: ElevatedButton(
        onPressed: onDeleteTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff6E53D2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Delete Transactions'),
      ),
    );
  }
}