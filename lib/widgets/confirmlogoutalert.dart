import 'package:flutter/material.dart';

Future<bool> confirmlogoutscreen(BuildContext context) async {
  bool? confirmlogout = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
  return confirmlogout ?? false;
}
