import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/default_background.dart';
import 'components/bottom_action_button.dart';
import 'components/out_line_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class CalenderCellData {
  final DateTime date;
  final bool isCurrentMonth;
  CalenderCellData({required this.isCurrentMonth, required this.date});
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin{
  late TabController tabController;
  late final AnimationController ac;
  late final CurvedAnimation ca;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final cloudOffset = [
    Offset(180, -50), Offset(-200, -40), Offset(250, 0), Offset(-190, -25), Offset(170, 50),
  ];

  String selectedGender = "";
  DateTime? selectedBirthDate;

  bool isAm = true;
  int? selectedHour;
  int? selectedMinute;
  bool unknownTime = false;

  bool _isSelectingHour = true;
  int _tempHour = 9;
  int _tempMinute = 0;

  int to24Hour(int hour12, bool isAm) {
    if(isAm) {
      return hour12 == 12 ? 0 : hour12;
    } else {
      return hour12 == 12 ? 12 : hour12 + 12;
    }
  }

  void _handleDialTouch(Offset localPosition, double dialSize) {
    final center = Offset(dialSize / 2, dialSize / 2);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    if(dx * dx + dy * dy < 20 * 20) return;

    double angle = atan2(dx, -dy);
    if(angle < 0) angle += 2 * pi;

    if(_isSelectingHour) {
      int hour = (angle / (2 * pi) * 12).round();
      if(hour == 0) hour = 12;
      setState(() {
        selectedHour = hour;
      });
    } else {
      int minute = (angle / (2 * pi) * 60).round()%60;
      if(minute == 60) minute = 0;
      setState(() {
        selectedMinute = minute;
      });
    }
  }

  void _handleDialTouchEnd() {
    if(_isSelectingHour) {
      Future.delayed(Duration(milliseconds: 250), () {
        if(mounted) {
          setState(() {
            _isSelectingHour = false;
          });
        }
      });
    } else {
      setState(() {
        unknownTime = false;
        selectedHour = _tempHour;
        selectedMinute = _tempMinute;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        if(mounted) {
          moveToPage(6);
        }
      });
    }
  }

  String get formatBirthDate {
    if(selectedBirthDate == null) return "태어난 날짜를 선택해주세요";
    final d = selectedBirthDate!;
    return "${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}";
  }

  String get formateBirthTime {
    if(unknownTime) return "잘 모르겠어요";
    if(selectedHour == null || selectedMinute == null) return "태어난 시간을 입력해주세요";
    final hour24 = to24Hour(selectedHour!, isAm);
    return "${hour24.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
  }

  int calenderYear = DateTime.now().year;
  int calenderMonth = DateTime.now().month;

  List<CalenderCellData> buildCalenderDays(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    final startWeekday = firstDay.weekday % 7;
    final totalDays = lastDay.day;

    final prevMonthLastDay = DateTime(year, month, 0).day;

    final List<CalenderCellData> days = [];

    for(int i = 0; i < startWeekday; i++) {
      final day = prevMonthLastDay - startWeekday + i + 1;
      days.add(CalenderCellData(isCurrentMonth: false, date: DateTime(year, month - 1, day)));
    }

    for(int i = 1; i <= totalDays; i++) {
      days.add(CalenderCellData(isCurrentMonth: true, date: DateTime(year, month, i)));
    }

    int nextDay = 1;
    while(days.length % 7 != 0) {
      days.add(CalenderCellData(isCurrentMonth: false, date: DateTime(year, month + 1, nextDay)));
    }

    return days;
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> showYearMonthPicker() async {
    int tempYear = calenderYear;
    int tempMonth = calenderMonth;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xff2D1248),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(24))
      ),
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        return SizedBox(
          height: 320,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                child: Text("연도 / 월 선택", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "M", fontWeight: FontWeight.w700),),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 44,
                        perspective: 0.003,
                        controller: FixedExtentScrollController(initialItem:  tempYear - 1900),
                        onSelectedItemChanged: (value) => setModalState(() => tempYear = 1900 + value),
                        childDelegate: ListWheelChildBuilderDelegate(builder: (context, index) {
                          final year = 1900 + index;
                          final isSelected = year == tempYear;
                          return Center(
                            child: Text("$year년", style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: isSelected ? 22 : 20, fontWeight: FontWeight.w700, fontFamily: "M"),),
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 44,
                        perspective: 0.003,
                        controller: FixedExtentScrollController(initialItem:  tempMonth - 1),
                        onSelectedItemChanged: (value) => setModalState(() => tempYear = value + 1),
                        childDelegate: ListWheelChildBuilderDelegate(builder: (context, index) {
                          final month = index + 1;
                          final isSelected = month == tempMonth;
                          return Center(
                            child: Text("$month월", style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: isSelected ? 22 : 20, fontWeight: FontWeight.w700, fontFamily: "M"),),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      calenderYear = tempYear;
                      calenderMonth = tempMonth;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white
                    ),
                    alignment: Alignment.center,
                    child: Text("확인", style: TextStyle(color: Color(0xff340B57), fontSize: 16, fontFamily: "N", fontWeight: FontWeight.w600),),
                  ),
                ),
              )
            ],
          ),
        );
      })
    );
  }

  void moveToPage(int index) {
    tabController.animateTo(index);
  }

  double intervalValue(double start, double end) {
    final t = ((ca.value - start) / (end - start));
    return Curves.easeOut.transform(t);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();
    calenderYear = now.year;
    calenderMonth = now.month;
    ac = AnimationController(vsync: this, duration: Duration(seconds: 4))..forward();
    ca = CurvedAnimation(parent: ac, curve: Curves.easeInOutCirc);
    tabController = TabController(length: 7, vsync: this);
    tabController.addListener(() {
      setState(() {
        if(!tabController.indexIsChanging && tabController.index == 5) {
          _isSelectingHour = true;
          if(selectedHour != null) _tempHour = selectedHour!;
          if(selectedMinute != null) _tempMinute = selectedMinute!;
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
    ac.dispose();
    nameController.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultBackground(
        child: Stack(
          children: [
            SafeArea(
              child: RepaintBoundary(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AnimatedBuilder(animation: ca, builder: (context, child) {
                          final value = intervalValue(0.1, 0.35);
                          return Transform.translate(
                            offset: Offset(-20 * (1 - value), -20 * (2 - value)),
                            child: Opacity(opacity: value, child: child,),
                          );
                        }, child: Image.asset("assets/img/moon", width: 130,),)
                      ],
                    ),
                    Stack(
                      children: [
                        ...cloudOffset.map((e) => AnimatedBuilder(animation: ca, builder: (context, child) {
                          final value = intervalValue(0.2, 0.45);
                          return Transform.translate(
                            offset: Offset(e.dx - (e.dx.sign * 90 * value), e.dy),
                            child: Opacity(opacity: value, child: child,),
                          );
                        }, child: Image.asset("assets/img/cloud", width: 220,),))
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  buildIntroPage(),
                  buildNamePage(),
                  buildAgePage(),
                  buildGenderPage(),
                  buildBirthDatePage(),
                  buildBirthTimePage(),
                  buildCOnfirmPage(),
                ],
              ),
            ),
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width - 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: tabController.index == 6 || tabController.index == 0 ? Colors.transparent : Colors.white24
                ),
                child: Row(
                  children: List.generate(5, (index) => Expanded(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: tabController.index == 6 || tabController.index == 0 ? Colors.transparent : (tabController.index - 1 >= index ? Colors.white : Colors.transparent)
                      ),
                    ),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}