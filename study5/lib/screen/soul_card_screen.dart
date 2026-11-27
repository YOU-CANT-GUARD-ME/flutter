import 'dart:math';

import 'package:daily_tarot_app/components/birth_date_picker_dialog.dart';
import 'package:daily_tarot_app/components/bottom_action_button.dart';
import 'package:daily_tarot_app/components/clouds.dart';
import 'package:daily_tarot_app/components/default_background.dart';
import 'package:daily_tarot_app/controller/app_controller.dart';
import 'package:daily_tarot_app/screen/my_soul_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoulCardScreen extends StatefulWidget {
  const SoulCardScreen({super.key});

  @override
  State<SoulCardScreen> createState() => _SoulCardScreenState();
}

class _SoulCardScreenState extends State<SoulCardScreen> {
  DateTime? selectedDate;
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
                SizedBox(height: 30,),
                Row(
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white70,))
                  ],
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    Image.asset("assets/img/graphic.png", width: 55,),
                    Text("나의 생일로 알아보는 소울카드", style: TextStyle(color: Colors.white, fontSize: 19, fontFamily: "M", fontWeight: FontWeight.w700),),
                  ],
                ),
                SizedBox(height: 25,),
                SizedBox(
                  height: 300,
                  child: soulCardPreview(),
                ),
                SizedBox(height: 40,),
                InkWell(
                  onTap: () async {
                    final date = await showDialog(context: context, builder: (context) => BirthDatePickerDialog(initalDate: selectedDate),);
                    if(date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    width: 240,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: Row(
                      children: [
                        Text(selectedDate == null ? "생년월일 선택해주세요" : "${selectedDate!.year}년 ${selectedDate!.month}월 ${selectedDate!.day}일", style: TextStyle(color: selectedDate == null ? Colors.white70 : Colors.white, fontSize: 16),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded, size: 17, color: selectedDate == null ? Colors.white70 : Colors.white,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 45,),
                BottomActionButton(img: true, title: "달 10개로 소울카드 찾기", checkedIcon: false, onTap: () async{
                  if(selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("생년월일 선택해주세요"))
                    );
                  } else {
                    if(AppController.cash < 10) {
                      return showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          backgroundColor: Color(0xff2D1248),
                          title: Text("달 개수가 부족합니다", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "M", fontWeight: FontWeight.w700),),
                          content: Row(
                            children: [
                              Image.asset("assets/img/moon.png", width: 24,),
                              Text("달 충전 화면에서 달 충전해주세요!", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: "M", fontWeight: FontWeight.w700),),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text("확인", style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "N", fontWeight: FontWeight.w600),))
                          ],
                        );
                      },);
                    } else {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      AppController.cash = AppController.cash - 10;
                      await prefs.setInt("cash", AppController.cash);
                      setState(() {

                      });
                      Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
                        return MySoulCard(cardNum: cardNum(selectedDate!), birth: selectedDate!);
                      }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child,);
                      },), (route) => false,);
                    }
                  }
                }),
                SizedBox(height: 14,),
                Text("소울카드에 사용되는 정보는\n 카드 조합 용도 외에 사용되지 않습니다.", style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: "N", fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
              ],
            )
          ],
        ),
      ),
    );
  }

  int cardNum(DateTime selectedDate) {
    int sum = selectedDate.year + selectedDate.month + selectedDate.day;
    return (sum - 1) % 9 + 1;
  }

  Widget soulCardPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [yellowText("소울 넘버"),whiteText("는 생년월일의 숫자를 모두 더해")],),
        whiteText("얻는 최종적인 한 자리 숫자로,"),
        whiteText("당신의 핵심적인 에너지와 삶의 테마를 나타냅니다."),
        whiteText("이 소울 넘버에 해당하는"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [whiteText("메이저 아르카나 타로 카드가 바로 "), yellowText("소울 카드"),whiteText("이며,")],),
        whiteText("이는 당신의 타고난 성격, 기질,"),
        whiteText("그리고 삶의 목적을 상징합니다."),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [whiteText("즉, 소울 넘버는 당신의 "), yellowText("영혼의 번호"),whiteText("이고,")],),
        whiteText("소울 카드는 그 번호가 의미하는"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [yellowText("영혼의 본질"),whiteText("을 보여주는 상징인 셈입니다.")],),
      ],
    );
  }

  Widget yellowText(String text) {
    return Text(text, style: TextStyle(color: Color(0xffFBDA37), fontSize: 13, fontFamily: "N", fontWeight: FontWeight.w600),);
  }
  Widget whiteText(String text) {
    return Text(text, style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "N", fontWeight: FontWeight.w600),);
  }
}
