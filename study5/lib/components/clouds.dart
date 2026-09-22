import 'package:flutter/cupertino.dart';

class Clouds extends StatelessWidget {
  const Clouds({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: Stack(
        children: [
          Positioned(right: 0, child: Image.asset("assets/img/cloud.png", width: 220,)),
          Positioned(left: -20, top: 20, child: Image.asset("assets/img/cloud.png", width: 220,)),
          Positioned(right: -30, top: 50, child: Image.asset("assets/img/cloud.png", width: 220,)),
          Positioned(left: -10, top: 70, child: Image.asset("assets/img/cloud.png", width: 220,)),
          Positioned(right: 10, top: 100, child: Image.asset("assets/img/cloud.png", width: 220,)),
        ],
      ),
    );
  }
}
