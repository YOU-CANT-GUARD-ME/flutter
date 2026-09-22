import 'package:daily_tarot_app/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashTap extends StatefulWidget {
  final int moon;
  final int moonImg;
  final String discount;
  final String price;
  final VoidCallback onTap;
  const CashTap({
    super.key,
    required this.moon,
    required this.moonImg,
    required this.discount,
    required this.price,
    required this.onTap,
  });

  @override
  State<CashTap> createState() => _CashTapState();
}

class _CashTapState extends State<CashTap> {

  Future<void> cashPlus(int moon) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("cash", AppController.cash + moon);
    AppController.cash = prefs.getInt("cash")!;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        await cashPlus(widget.moon);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("달 ${widget.moon}개가 충전되었습니다!"), duration: Duration(seconds: 1),)
        );
        widget.onTap();
      },
      child: SizedBox(
        width: 350,
        child: Row(
          children: [
            if(widget.moonImg == 1)
              Image.asset("assets/img/moon.png", width: 45),
            if(widget.moonImg == 2)
              Stack(
                children: [
                  Positioned(right: 0, child: Image.asset("assets/img/moon.png", width: 30),),
                  Image.asset("assets/img/moon.png", width: 45),
                ],
              ),
            if(widget.moonImg == 3)
              Stack(
                children: [
                  Positioned(right: 0, child: Image.asset("assets/img/moon.png", width: 30),),
                  Image.asset("assets/img/moon.png", width: 45),
                  Positioned(right: 0, bottom: 2, child: Image.asset("assets/img/moon.png", width: 15),),
                ],
              ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("달 ${widget.moon}개", style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: "N", fontWeight: FontWeight.w500),),
                Text(widget.discount, style: TextStyle(color: Color(0xffFBDA37), fontSize: 13, fontFamily: "N", fontWeight: FontWeight.w500),),
              ],
            ),
            Spacer(),
            Text(widget.price, style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: "N", fontWeight: FontWeight.w500),),
            SizedBox(width: 10,)
          ],
        ),
      ),
    );
  }
}
