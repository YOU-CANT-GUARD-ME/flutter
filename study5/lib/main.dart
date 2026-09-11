import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final int currentYear = DateTime.now().year;
  final int firstYear = 1900;

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Container(
              height: 300,
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                color: Colors.blue[200],
              ),
              child: Column(
                children: [
                  Text("연도 / 월 선택", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),),
                  SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 150,
                        child: ListWheelScrollView.useDelegate(
                          controller: FixedExtentScrollController(
                            initialItem: currentYear - firstYear + 1,
                          ),
                          itemExtent: 44,
                          perspective: 0.003,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedYear = firstYear + index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                              childCount:  currentYear - firstYear + 1,
                              builder: (context, index) {
                                final year = firstYear + index;
                                return Center(
                                  child: Text("$year년", style: TextStyle(fontSize: 24, color: year == selectedYear ? Colors.black : Colors.grey),),
                                );
                              }
                          ),
                        ),
                      ),

                      SizedBox(width: 30,),

                      SizedBox(
                        width: 100,
                        height: 150,
                        child: ListWheelScrollView.useDelegate(
                          controller: FixedExtentScrollController(
                            initialItem: selectedMonth - 1,
                          ),
                          itemExtent: 44,
                          perspective: 0.003,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedMonth = index + 1;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 12,
                              builder: (context, index) {
                                final month = index + 1;
                                return Center(
                                  child: Text("$month월", style: TextStyle(fontSize: 24, color: month == selectedMonth ? Colors.black : Colors.grey),),
                                );
                              }
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox( height: 10,),

                  Container(
                    width: 230,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    child: Text("확인하기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}