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
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    border: OutlineInputBorder()
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
    return AnimatedBuilder(animation: ca, builder: (context, child) {
      final logoValue = intervalValue(0.1, 0.35);
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
              child: Opacity(opacity: titleValue, child: Text("운명을 엿볼 시간이에요.", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: "M"),),),
            ),
            SizedBox(height: 110,),
            Transform.translate(
              offset: Offset(0, 24 - (1 * buttonValue)),
              child: Opacity(opacity: buttonValue, child: BottomActionButton(img: false, title: "시작하기", checkedIcon: true, onTap: () => moveToPage(1)),),
            ),
            Spacer(),
          ],
        ),
      );
    });
  }

  Widget buildNamePage() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 120,),
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
                  hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.white70,
                      width: 1.5,
                    ),
                  ),focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
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
          ),
          Spacer(),
          OutLineButton(title: "이전", onTap: () {
            if(MediaQuery.of(context).viewInsets.bottom > 0) return;
            moveToPage(0);
          }),
          SizedBox(height: 55,),
        ],
      ),
    );
  }

  Widget buildAgePage() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 120,),
          logoAndTitle("나이를 입력해주세요."),
          SizedBox(height: 50,),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
            child: Form(
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                style: TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: "  나이를 입력해주세요.",
                  hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.white70,
                      width: 1.5,
                    ),
                  ),focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return "나이 항목에 나이를 입력해주세요.";
                  }
                  if(int.tryParse(value) == null) {
                    return "나이 항목에 숫자만 입력해주세요.";
                  }
                  moveToPage(3);
                  return null;
                },
              ),
            ),
          ),
          Spacer(),
          OutLineButton(title: "이전", onTap: () {
            if(MediaQuery.of(context).viewInsets.bottom > 0) return;
            moveToPage(1);
          }),
          SizedBox(height: 55,),
        ],
      ),
    );
  }

  Widget genderButton({required String icon, required String label, required VoidCallback onTap}) {
    final isSelected = label == selectedGender;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white70, width: 1.5),
          color: isSelected ? Colors.white24 : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(icon, width: 55,),
      ),
    );
  }

  Widget buildGenderPage() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 120,),
          logoAndTitle("성별을 선택해주세요."),
          SizedBox(height: 90,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              genderButton(icon: "assets/icons/female_24dp_E3E3E3_FILL0_wght100_GRAD0_opsz24.svg", label: "여성", onTap: () {
                setState(() {
                  selectedGender = "여성";
                });
                moveToPage(4);
              }),
              SizedBox(width: 18,),
              genderButton(icon: "assets/icons/male_24dp_E3E3E3_FILL0_wght100_GRAD0_opsz24.svg", label: "남성", onTap: () {
                setState(() {
                  selectedGender = "남성";
                });
                moveToPage(4);
              }),
            ],
          ),
          Spacer(),
          OutLineButton(title: "이전", onTap: () => moveToPage(2)),
          SizedBox(height: 55,),
        ],
      ),
    );
  }

  Widget buildBirthDatePage() {
    final days = buildCalenderDays(calenderYear, calenderMonth);
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 120,),
          logoAndTitle("태어난 날짜를 입력해주세요."),
          SizedBox(height: 25,),
          InkWell(
            onTap: () => showYearMonthPicker(),
            child: Text("$calenderYear.$calenderMonth", style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: "M", fontWeight: FontWeight.w700),),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 12,
                crossAxisSpacing: 6,
                childAspectRatio: 1
              ),
              itemBuilder: (context, index) {
                final cell = days[index];
                final date = cell.date;
                final isSelected = selectedBirthDate != null && isSameDate(selectedBirthDate!, date);
                return InkWell(
                  onTap: cell.isCurrentMonth ? () {
                    setState(() {
                      selectedBirthDate = date;
                    });
                    moveToPage(5);
                  } : null,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: isSelected ? Colors.white : Colors.transparent
                    ),
                    alignment: Alignment.center,
                    child: Text("${date.day}", style: TextStyle(color: isSelected ? Color(0xff340B57) : Colors.white.withValues(alpha: cell.isCurrentMonth ? 1 : 0.25), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: "M"),),
                  ),
                );
              },
            ),
          ),
          Spacer(),
          OutLineButton(title: "이전", onTap: () => moveToPage(3)),
          SizedBox(height: 55,),
        ],
      ),
    );
  }

  Widget buildBirthTimePage() {
    final double dialSize = 200;
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 120,),
          logoAndTitle("태어난 시간을 입력헤주세요."),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSelectingHour = true;
                  });
                },
                child: Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isSelectingHour ? Colors.white54 : Colors.transparent,
                      width: 1.5
                    )
                  ),
                  alignment: Alignment.center,
                  child: Text(_tempHour.toString().padLeft(2, "0"), style: TextStyle(color: _isSelectingHour ? Colors.white : Colors.white54, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: "M"),),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                child: Text(":", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: "M"),),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSelectingHour = false;
                  });
                },
                child: Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: !_isSelectingHour ? Colors.white54 : Colors.transparent,
                          width: 1.5
                      )
                  ),
                  alignment: Alignment.center,
                  child: Text(_tempMinute.toString().padLeft(2, "0"), style: TextStyle(color: !_isSelectingHour ? Colors.white : Colors.white54, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: "M"),),
                ),
              ),
              SizedBox(width: 20,),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAm = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        border: Border.all(color: isAm ? Colors.white : Colors.white54, width: 1.5),
                      ),
                      child: Text("AM", style: TextStyle(color: isAm ? Colors.white : Colors.white54, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: "M"),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAm = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                        border: Border.all(color: !isAm ? Colors.white : Colors.white54, width: 1.5),
                      ),
                      child: Text("PM", style: TextStyle(color: !isAm ? Colors.white : Colors.white54, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: "M"),),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: dialSize,
            height: dialSize,
            child: GestureDetector(
              onPanUpdate: (details) => _handleDialTouch(details.localPosition, dialSize),
              onPanEnd: (details) => _handleDialTouchEnd(),
              onTapUp: (details) {
                _handleDialTouch(details.localPosition, dialSize);
                _handleDialTouchEnd();
              },
              child: CustomPaint(
                size: Size(dialSize / 2, dialSize / 2),
                painter: _ClockDialPainter(isHourMode: _isSelectingHour, selectedValue: _isSelectingHour ? _tempHour : _tempMinute),
              ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutLineButton(title: "이전", onTap: () => moveToPage(3)),
              SizedBox(width: 14,),
              OutLineButton(title: "잘 모르겠어요", onTap: () {
                setState(() {
                  unknownTime = false;
                  selectedHour = _tempHour;
                  selectedMinute = _tempMinute;
                });
                moveToPage(6);
              }),
            ],
          ),
          SizedBox(height: 55,),
        ],
      ),
    );
  }

  Widget infoBox({required String title, required String value, required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 50, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white60, width: 1.5)
          ),
          child: Row(
            children: [
              Text("$title : ", style: TextStyle(color: Colors.white, fontSize: 15),),
              Expanded(child: Text(value, style: TextStyle(color: Colors.white, fontSize: 15),),)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConfirmPage() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 120,),
          logoAndTitle("입력한 항몰을 확인해주세요."),
          SizedBox(height: 40,),
          infoBox(title: "이름", value: nameController.text, onTap: () => moveToPage(1)),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 50, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => moveToPage(2),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white60, width: 1.5)
                      ),
                      child: Text("나이 : ${ageController.text}", style: TextStyle(color: Colors.white, fontSize: 15),),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => moveToPage(3),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white60, width: 1.5)
                    ),
                    child: SvgPicture.asset(selectedGender == "남성" ? "assets/icons/male_24dp_E3E3E3_FILL0_wght100_GRAD0_opsz24.svg" : "assets/icons/female_24dp_E3E3E3_FILL0_wght100_GRAD0_opsz24.svg"),
                  ),
                ),
              ],
            ),
          ),
          infoBox(title: "새일", value: formatBirthDate, onTap: () => moveToPage(4)),
          infoBox(title: "태어난 시간", value: formateBirthTime, onTap: () => moveToPage(5)),
          Spacer(),
          BottomActionButton(img: false, title: "시작하기", checkedIcon: true, onTap: () => Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
            return HomePage();
          }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child,);
          }), (route) => false))
        ],
      ),
    );
  }
}

class _ClockDialPainter extends CustomPainter {
  final bool isHourMode;
  final int selectedValue;
  _ClockDialPainter({required this.isHourMode, required this.selectedValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final numberRadius = radius - 24;

    canvas.drawCircle(center, radius, Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=1.5);

    double selectedAngle;
    if(isHourMode) {
      selectedAngle = (selectedValue % 12) / 12 * 2 * pi;
    } else {
      selectedAngle = selectedValue / 60 * 2 * pi;
    }

    final handX = center.dx + (numberRadius - 18) * sin(selectedAngle);
    final handY = center.dy + (numberRadius - 18) * cos(selectedAngle);

    canvas.drawLine(cetner, Offset(handX, handY), Paint()..color=Colors.white..strokeWidth=1.5);
    canvas.drawCircle(center, 4, Paint()..color=Colors.white);

    if(isHourMode) {
      for(int i = 1; i <= 12; i++) {
        final angle = i / 12 * 2 * pi;
        final x = center.dx + numberRadius * sin(angle);
        final y = center.dy - numberRadius * cos(angle);
        final isSelected = i == selectedValue;

        if(isSelected) {
          canvas.drawCircle(Offset(x, y), 18, Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=1.5);
        }

        final tp = TextPainter(
          text: TextSpan(
            text: "$i",
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "M", fontWeight: FontWeight.w700)
          ),
          textDirection: TextDirection.ltr
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
      }
    } else {
      for(int i = 0; i < 12; i++) {
        final minuteVal = i * 5;
        final angle = i / 12 * 2 *pi;
        final x = center.dx + numberRadius * sin(angle);
        final y = center.dy - numberRadius * cos(angle);
        final isSelected = minuteVal == selectedValue;

        if(isSelected) {
          canvas.drawCircle(Offset(x, y), 18, Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=1.5);
        }

        final tp = TextPainter(
          text: TextSpan(
            text: "$minuteVal".padLeft(2, "0"),
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "M", fontWeight: FontWeight.w700)
          ),
          textDirection: TextDirection.ltr
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ClockDialPainter old) {
    return old.isHourMode != isHourMode || old.selectedValue != selectedValue;
  }
}