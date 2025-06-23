import 'package:flutter/material.dart';

class LogoCorner extends StatelessWidget {
  final double size;
  const LogoCorner({super.key, this.size = 70});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.white,
        backgroundImage: const AssetImage('assets/logo.png'),
      ),
    );
  }
}