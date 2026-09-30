import 'dart:ffi';
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
  CalenderCellData({
    required this.date,
    required this.isCurrentMonth
  });
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

  List<CalenderCellData> buildCalenderDays(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    final startWeekday = firstDay.weekday % 7;
    final totalDays = lastDay.day;

    final prevMonthLastday = DateTime(year, month, 0).day;

    final List<CalenderCellData> days = [];

    for (int i = 0; i < startWeekday; i++) {
      final day = prevMonthLastday - startWeekday + i + 1;
      days.add(CalenderCellData(date: DateTime(year, month - 1, day), isCurrentMonth: false));
    }

    for (int i = 1; i <= totalDays; i++) {
      days.add(CalenderCellData(date: DateTime(year, month, i), isCurrentMonth: true));
    }

    int nextDay = 1;
    while(days.length % 7 != 0) {
      days.add(CalenderCellData(date: DateTime(year, month + 1, nextDay), isCurrentMonth: false));
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
                          final value = intervalValue(0.1, 0.35);
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
                          final value = intervalValue(0.2, 0.45);
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
                  color: tabController.index == 6 || tabController.index == 0 ? Colors.transparent : Colors.white24,
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
    return AnimatedBuilder(animation: ca, builder: (context, child) {
      final logoValue = intervalValue(0.2, 0.5);
      final titleValue = intervalValue(0.35, 0.7);
      final buttonValue = intervalValue(0.5, 1.0);
      return SafeArea(
        child: Column(
          children: [
            SizedBox(height: 200,),
            Transform.translate(
              offset: Offset(0, 20 * (1 - logoValue)),
              child: Opacity(opacity: logoValue, child: Column(
                children: [
                  Image.asset("assets/img/Daily Tarot.png", width: 210,),
                  Image.asset("assets/img/graphic.png", width: 60,),
                ],
              ),),
            ),
            Transform.translate(
              offset: Offset(0, 16 * (1 - titleValue)),
              child: Opacity(opacity: titleValue, child: Text("운명을 엿볼 시간이예요.", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: "M"),),),
            ),
            SizedBox(height: 110,),
            Transform.translate(
              offset: Offset(0, 24 * (1 - buttonValue)),
              child: Opacity(opacity: buttonValue, child: BottomActionButton(img: false, title: "시작하기", checkedIcon: true, onTap: () => moveToPage(1)),),
            )
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
                      width: 1.5
                    ),
                  ),focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.5
                    ),
                  ),errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5
                    ),
                  ),focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5
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
          SizedBox(height: 50,),
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
                        width: 1.5
                    ),
                  ),focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.5
                  ),
                ),errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5
                  ),
                ),focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.5
                  ),
                ),
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return "나이 항목에 나이를 입력해주세요.";
                  }
                  if(int.tryParse(value) == null) {
                    return "나이 항목에 숫자로만 입력해주세요.";
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
          SizedBox(height: 50,),
        ],
      ),
    );
  }

  Widget genderButton({required String icon, required String label, required VoidCallback onTap}) {
    final selected = label == selectedGender;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 1.5),
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
              SizedBox(width: 25,),
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
                  borderRadius: BorderRadius.circular(100),
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
                    child: Text("${date.day}", style: TextStyle(color: isSelected ? Color(0xff340B57) : Colors.white.withValues(alpha: cell.isCurrentMonth ? 1 : 0.25), fontSize: 16, fontWeight: FontWeight.w700, fontFamily: "M"),),
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
    const double dialSize = 200;
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 120,),
          logoAndTitle("태어난 날짜를 입력해주세요."),
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
                  child: Text(_tempHour.toString().padLeft(2, "0"), style: TextStyle(color: _isSelectingHour ? Colors.white54, fontSize: 28, fontFamily: "M", fontWeight: FontWeight.w700),),
                ),
              )
            ],
          )
        ],
      ),
    )
  }
}
