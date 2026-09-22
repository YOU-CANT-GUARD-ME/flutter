import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

import 'components/default_background.dart';
import 'components/bottom_action_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class CalenderCellDate {
  final DateTime  date;
  final bool isCurrent;
  CalenderCellDate({required this.date, required this.isCurrent});
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin{
  late TabController tabController;
  late final AnimationController ac;
  late final CurvedAnimation ca;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final cloudOffsets = [
    Offset(180, -50), Offset(-200, -40), Offset(250, 0), Offset(-190, 25), Offset(170, 50),
  ];

  String selectedGender = "";
  DateTime? selectedBirthDate;

  bool isAm = true;
  int? selectedHour;
  int? selectedMinute;
  bool unkownTime = false;

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

    double angle = atan2(dx, -dx);
    if (angle < 0) angle += 2 * pi;

    if(_isSelectingHour) {
      int hour = (angle / (2 * pi) * 12).round();
      if(hour == 0) hour = 12;
      setState(() {
        _tempHour = hour;
      });
    } else {
      int minute = (angle / (2 * pi) * 60).round() %60;
      if(minute == 60) minute = 0;
      setState(() {
        _tempMinute = minute;
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
        unkownTime = false;
        selectedHour = _tempHour;
        selectedHour = _tempMinute;
      });
      Future.delayed(Duration(milliseconds:  300), () {
        if(mounted) {
          moveToPage(6);
        }
      });
    }
  }

  String get formatBirthdate {
    if(selectedBirthDate == null) return "태어난 날짜를 선택해주세요.";
    final d = selectedBirthDate!;
    return "${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}";
  }

  String get formBirthTime {
    if (unkownTime) return "잘 모르겠어요";
    if (selectedHour == null || selectedMinute == null) return "태어난 시간을 선택해주세요.";
    final hour24 = to24Hour(selectedHour!, isAm);
    return "${hour24.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
  }

  int calenderYear = DateTime.now().year;
  int calenderMonth = DateTime.now().month;

  List<CalenderCellDate> buildCalenderDays(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    final startWeekday = firstDay.weekday % 7;
    final totalDays = lastDay.day;

    final prevMonthLastDay = DateTime(year, month, 0).day;

    final List<CalenderCellDate> days = [];

    for (int i = 0; i < startWeekday; i++) {
      final day = prevMonthLastDay - startWeekday + i + 1;
      days.add(CalenderCellDate(date: DateTime(year, month - 1, day), isCurrent: false));
    }

    for (int i = 1; i <= totalDays; i++) {
      days.add(CalenderCellDate(date: DateTime(year, month, i), isCurrent: true));
    }

    int nextDay = 1;
    while(days.length % 7 != 0) {
      days.add(CalenderCellDate(date: DateTime(year, month + 1, nextDay), isCurrent: false));
      nextDay++;
    }

    return days;
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year&& a.month == b.month && a.day == b.day;
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
                        controller: FixedExtentScrollController(initialItem: tempYear - 1900),
                        onSelectedItemChanged: (value) => setModalState(() => tempYear = 1900 + value),
                        childDelegate: ListWheelChildBuilderDelegate(childCount: 201, builder: (context, index) {
                          final year = 1900 + index;
                          final isSelected = year == tempYear;
                          return Center(
                            child: Text("$year년", style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: isSelected ? 22 : 20, fontFamily: "M", fontWeight: FontWeight.w700),),
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 44,
                        perspective: 0.003,
                        controller:  FixedExtentScrollController(initialItem:  tempMonth - 1),
                        onSelectedItemChanged: (value) => setModalState(() => tempMonth = value + 1),
                        childDelegate: ListWheelChildBuilderDelegate(childCount: 21, builder: (context, index) {
                          final month = index + 1;
                          final isSelected = month == tempMonth;
                          return Center(
                            child: Text("$month월", style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: isSelected ? 22 : 20, fontFamily: "M", fontWeight: FontWeight.w700),),
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
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: Text("확인", style: TextStyle(color: Color(0xff340b57), fontFamily: "N", fontWeight: FontWeight.w600, fontSize: 16),),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void moveToPage(int index) {
    tabController.animateTo(index);
  }

  double intervalValue(double start, double end) {
    final t = ((ca.value - start) / (end - start)).clamp(0.0, 1.0);
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
    tabController = TabController(length: 7, vsync: this,);
    tabController.addListener(() {
      setState(() {
        if(!tabController.indexIsChanging && tabController.index == 5) {
          _isSelectingHour = true;
          if(selectedHour != null) _tempHour = selectedHour!;
          if(selectedMinute != null) _tempMinute = selectedMinute!;
        }
      });
    },);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    ac.dispose();
    nameController.dispose();
    ageController.dispose();
    super.dispose();
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
                          final value = intervalValue(0.0, 0.35);
                          return Transform.translate(
                            offset: Offset(-20 * (1 - value), -20 * (2 - value)),
                            child: Opacity(opacity: value, child: child,),
                          );
                        }, child: Image.asset("assets/img/moon.png", width: 130,),)
                      ],
                    ),
                    Spacer(),
                    Stack(
                      children: [
                        ...cloudOffsets.map((e) => AnimatedBuilder(animation: ca, builder: (context, child) {
                          final value = intervalValue(0.1, 0.45);
                          return Transform.translate(
                            offset: Offset(e.dx - (e.dx.sign * 90 * value), e.dy),
                            child: Opacity(opacity: value, child: child,),
                          );
                        }, child: Image.asset("assets/img/cloud.png", width: 220,),))
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
                  buildBirtTimePage(),
                  buildConfirmPage(),
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
            ),
            Offstage(
              offstage: true,
              child: SizedBox(
                width: 1,
                height: 1,
                child: TextFormField(
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logoAndTitle(String title) {
    return Column(
      children: [
        Image.asset("assets/img/Daily Tarot.png", width: 210,),
        Image.asset("assets/img/graphic.png", width: 60,),
        Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "M", fontWeight: FontWeight.w700),)
      ],
    );
  }

  Widget buildIntroPage() {
    final logoValue = intervalValue(0.2, 0.5);
    final titleValue = intervalValue(0.35, 0.7);
    final buttonValue = intervalValue(0.5, 1.0);
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 200,),
          Transform.translate(
            offset: Offset(0, 20 - (1 * logoValue)),
            child: Opacity(opacity: logoValue, child: Column(
              children: [
                Image.asset("assets/img/Daily Tarot.png", width: 210,),
                Image.asset("assets/img/graphic.png", width: 60,),
              ],
            ),),
          ),
          Transform.translate(
            offset: Offset(0, 16 - (1 * titleValue)),
            child: Opacity(opacity: titleValue, child: Text("운명을 엿볼 시간이예요.", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "M", fontWeight: FontWeight.w700),),),
          ),
          SizedBox(height: 110,),
          Transform.translate(
            offset: Offset(0, 24 - (1 * buttonValue)),
            child: Opacity(opacity: buttonValue, child: BottomActionButton(img: false, title: "시작하기", checkedIcon: true, onTap: () => moveToPage(1)),),
          )
        ],
      ),
    );
  }

  Widget buildNamePage() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height:  120,),
          logoAndTitle("이름을 입력해주세요."),
          SizedBox(height: 50,),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
            child: Form(
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.done,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "  이름을 입력해주세요.",
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.white70,
                      width: 1.5,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.white70,
                      width: 1.5,
                    )
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    )
                  ),
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return "이름 항목에 이름을 입력해주세요.";
                  }
                  if(value.length < 2 || value.length > 20) {
                    return "이름은 2자 이상 20자 이하로 입력해주세요.";
                  }
                  moveToPage(2);
                  return null;
                },
              ),
            ),
          )
        ],
      ),
    )
  }
}
