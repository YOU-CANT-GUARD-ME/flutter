import 'package:flutter/material.dart';

class DefaultBackground extends StatelessWidget {
  final Widget child;
  const DefaultBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff340B57), Color(0xff1D0630)]
        )
      ),
      child: child,
    );
  }
}
