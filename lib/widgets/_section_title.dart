import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff5D56C8)),
        ),
      ),
    );
  }
}