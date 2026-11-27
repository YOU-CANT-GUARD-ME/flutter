import 'dart:math';

import 'package:daily_tarot_app/components/clouds.dart';
import 'package:daily_tarot_app/components/default_background.dart';
import 'package:daily_tarot_app/controller/app_controller.dart';
import 'package:daily_tarot_app/screen/cash_screen.dart';
import 'package:daily_tarot_app/screen/soul_card_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNum();
  }

  Future<void> loadNum() async{
    prefs = await SharedPreferences.getInstance();
    AppController.cash = prefs.getInt("cash") ?? 0;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultBackground(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Transform(transform: Matrix4.rotationX(pi), alignment: Alignment.center, child: Clouds(),),
                    SizedBox(height: 800,),
                    Clouds(),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => CashScreen(),)),
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(top: 0, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset("assets/img/moon.png", width: 40,),
                                Text(AppController.cash.toString(), style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "N", fontWeight: FontWeight.w800),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      children: [
                        Image.asset("assets/img/Daily Tarot.png", width: 210,),
                        Image.asset("assets/img/graphic.png", width: 60,),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.only(left: 15),
                          child: Text("Daily Tarot Soul Card", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "M", fontWeight: FontWeight.w700),),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 25,
                                  spreadRadius: -15,
                                )
                              ]
                            ),
                            child: InkWell(
                              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => SoulCardScreen(),)),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(20),
                                    child: Image.asset("assets/img/daily_tarot_soul_card.png"),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(top: 60, left: 140),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("Soul Card", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "M", fontWeight: FontWeight.w700),),
                                        Text("운명적인 나만의 데일리 카드!", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "M", fontWeight: FontWeight.w500),),
                                        Text("매일 하루를 카운셀링 받으세요", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "M", fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text("Daily Tarot List", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "M", fontWeight: FontWeight.w700),),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                          height: 220,
                          child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            scrollDirection: Axis.horizontal,
                            children: [
                              InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("서비스를 준비 중입니다!"))
                                  );
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadiusGeometry.circular(15),
                                      child: Image.asset("assets/img/love_tarot.png"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 135, left: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("인연 타로", style: TextStyle(color: Colors.white, fontSize: 19, fontFamily: "N", fontWeight: FontWeight.w800),),
                                          Text("지금은 힘들지만 그래도,", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "N", fontWeight: FontWeight.w600),),
                                          Text("그 사람과 인연이 될 수 있을까?", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "N", fontWeight: FontWeight.w600),),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 15,),
                              InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("서비스를 준비 중입니다!"))
                                  );
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadiusGeometry.circular(15),
                                      child: Image.asset("assets/img/fruit_tarot.png"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 135, left: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("열매 타로", style: TextStyle(color: Colors.white, fontSize: 19, fontFamily: "N", fontWeight: FontWeight.w800),),
                                          Text("지금 생각하고 있는 일은", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "N", fontWeight: FontWeight.w600),),
                                          Text("어떤 결과로 이어질까?", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "N", fontWeight: FontWeight.w600),),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.only(left: 15),
                              child: Text("Daily Master", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "M", fontWeight: FontWeight.w700),),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 15,
                                      spreadRadius: -15,
                                      offset: Offset(0, -2),
                                    ),
                                  ]
                                ),
                                child: InkWell(
                                  onTap: () {
                                    launchUrl(Uri.parse("https://ko.wikipedia.org/wiki/타로"));
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius: BorderRadiusGeometry.circular(20),
                                          child: Image.asset("assets/img/daily_master.png", fit: BoxFit.cover,),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 24, left: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("당신만을 위한 상담", style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: "M", fontWeight: FontWeight.w700),),
                                            Text("당신을 위해 모인 '데일리마스터'와", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "M", fontWeight: FontWeight.w500),),
                                            Text("직접 이야기를 나누어 보세요.", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "M", fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
