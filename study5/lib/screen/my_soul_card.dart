import 'dart:math';

import 'package:daily_tarot_app/components/default_background.dart';
import 'package:daily_tarot_app/controller/app_controller.dart';
import 'package:daily_tarot_app/modal/tarot_card.dart';
import 'package:daily_tarot_app/screen/home_screen.dart';
import 'package:flutter/material.dart';

class MySoulCard extends StatefulWidget {
  final int cardNum;
  final DateTime birth;
  const MySoulCard({super.key, required this.cardNum, required this.birth});

  @override
  State<MySoulCard> createState() => _MySoulCardState();
}

class _MySoulCardState extends State<MySoulCard> with TickerProviderStateMixin{
  late final year = widget.birth.year;
  late final month = widget.birth.month;
  late final day = widget.birth.day;

  late final AnimationController ac;

  late TarotCard card = AppController.soulCard[widget.cardNum - 1];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ac = AnimationController(vsync: this, duration: Duration(seconds: 1));
    Future.delayed(Duration(seconds: 1),  () => ac.forward(),);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ac.dispose();
    super.dispose();
  }

  String formatStorytelling(String text) {
    return text.replaceAll("연인 카드는 중요한 선택, 관계, 그리고 조화를 상징합니다. 두 남녀가 천사의 축복 아래 서 있는 모습은 사랑과 결정의 순간을 보여줍니다. 당신은 삶에서 중요한 선택의 기로에 자주 서게 되며, 관계 속에서 성장하고 조화를 이루는 것을 배웁니다. 이 카드는 당신이 자신의 가치관에 따라 진정으로 원하는 것을 선택하고, 깊고 의미 있는 관계를 통해 자신을 발견하고 완성해나갈 수 있음을 의미합니다. 사랑과 선택을 통해 당신의 영혼은 더욱 성숙해질 것입니다.", "연인 카드는 중요한 선택, 관계,\n 그리고 조화를 상징합니다. 두 남녀가 천사의 축복 아래 서 있는 모습은\n 사랑과 결정의 순간을 보여줍니다. 당신은 삶에서 중요한 선택의 기로에 자주 서게 되며,\n 관계 속에서 성장하고 조화를 이루는 것을 배웁니다. 이 카드는 당신이 자신의 가치관에 따라\n 진정으로 원하는 것을 선택하고,\n 깊고 의미 있는 관계를 통해 자신을 발견하고\n 완성해나갈 수 있음을 의미합니다. 사랑과 선택을 통해\n 당신의 영혼은 더욱 성숙해질 것입니다.").replaceAll(".", ".\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60,),
                Row(
                  children: [
                    SizedBox(width: 170,),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/img/graphic.png", width: 60,),
                            Text("$year년 $month월 $day일생.", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: "M", fontWeight: FontWeight.w700),),
                            SizedBox(height: 30,),
                            Text("당신의 소울카드는", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: "M", fontWeight: FontWeight.w700),),
                            SizedBox(height: 10,),
                            Text("${card.number}번 ${card.name} 입니다.", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "M", fontWeight: FontWeight.w700),),
                          ],
                        )
                    )
                  ],
                ),
                SizedBox(height: 70,),
                SizedBox(
                  width: card.number == 6 ? 350 : 300,
                  child: Text(formatStorytelling(card.storytelling), style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: "M", fontWeight: FontWeight.w800, height: 2), textAlign: TextAlign.center,),
                )
              ],
            ),
            AnimatedBuilder(animation: ac, builder: (context, child) {
              final t = Curves.easeOut.transform(ac.value);
              return Stack(
                children: [
                  Opacity(
                    opacity: 1 - t,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      child: Column(
                        children: [
                          SizedBox(height: 90,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Image.asset("assets/img/graphic.png", width: 60,)],
                          ),
                          Text("${card.number}번 ${card.name}", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "M", fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.lerp(Alignment.center, Alignment(-0.8, -0.8), t)!,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(t * 2 * pi),
                      child: SizedBox(
                        width: 230 * (1 - t * 0.5),
                        height: 330 * (1 - t * 0.5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20 * (1 - t * 0.5)),
                          child: Image.asset(card.image, fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: t,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () => Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
                            return HomeScreen();
                          },transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child,);
                          },), (route) => false,),
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.white38, width: 1.5)
                            ),
                            child: Icon(Icons.close_sharp, size: 28, color: Colors.white70,),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },)
          ],
        )
    );
  }
}
