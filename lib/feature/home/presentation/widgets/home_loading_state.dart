import 'package:flutter/material.dart';

class HomeLoadingState extends StatelessWidget {
  const HomeLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF185FA5),
        strokeWidth: 2.5,
      ),
    );
  }
}
