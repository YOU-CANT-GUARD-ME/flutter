import 'dart:math';

import 'package:daily_tarot_app/components/cash_tap.dart';
import 'package:daily_tarot_app/components/clouds.dart';
import 'package:daily_tarot_app/components/default_background.dart';
import 'package:daily_tarot_app/controller/app_controller.dart';
import 'package:flutter/material.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({super.key});

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {

  void refreshCash() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultBackground(
        child: Stack(
          children: [
            Column(
              children: [
                Transform(transform: Matrix4.rotationX(pi), alignment: Alignment.center, child: Clouds(),),
                Spacer(),
                Clouds(),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 40,),
                Row(
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white70,)),
                  ],
                ),
                Column(
                  children: [
                    Image.asset("assets/img/graphic.png", width: 60,),
                    Text("달 충전", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "M", fontWeight: FontWeight.w800),),
                    SizedBox(height: 20,),
                    Text("현재 보유중인 달", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "N", fontWeight: FontWeight.w500),),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/img/moon.png", width: 35,),
                        Text(AppController.cash.toString(), style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "N", fontWeight: FontWeight.w800),),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  children: [
                    CashTap(moon: 25, moonImg: 1, discount: "약 750원 할인", price: "5,500원", onTap: refreshCash),
                    line(),
                    CashTap(moon: 50, moonImg: 1, discount: "약 2,600원 할인", price: "9,900원", onTap: refreshCash),
                    line(),
                    CashTap(moon: 75, moonImg: 2, discount: "약 4,750원 할인", price: "14,000원", onTap: refreshCash),
                    line(),
                    CashTap(moon: 100, moonImg: 2, discount: "약 8,000원 할인", price: "17,000원", onTap: refreshCash),
                    line(),
                    CashTap(moon: 200, moonImg: 3, discount: "약 17,000원 할인", price: "33,000원", onTap: refreshCash),
                    line(),
                    CashTap(moon: 350, moonImg: 3, discount: "약 32,500원 할인", price: "55,000원", onTap: refreshCash),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget line() {
    return Column(
      children: [
        SizedBox(height: 7,),
        Container(
          width: 350,
          height: 1,
          color: Colors.white24,
        ),
        SizedBox(height: 7,),
      ],
    );
  }
}
