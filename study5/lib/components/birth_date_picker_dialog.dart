import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BirthDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  const BirthDatePickerDialog({super.key, required this.initialDate});

  @override
  State<BirthDatePickerDialog> createState() => _BirthDatePickerDialogState();
}

class _BirthDatePickerDialogState extends State<BirthDatePickerDialog> {
  late final FixedExtentScrollController _yearController;
  late final FixedExtentScrollController _monthController;
  late final FixedExtentScrollController _dayController;

  final int _startYear = 1950;
  final DateTime _now = DateTime.now().toUtc().add(Duration(hours: 9));

  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final init = widget.initialDate ?? DateTime(2025, 4,1);
    selectedYear = init.year;
    selectedMonth = init.month;
    selectedDay = init.day;
    _yearController = FixedExtentScrollController(initialItem: selectedYear - _startYear);

    _monthController = FixedExtentScrollController(initialItem: 12 * 500 + (selectedMonth - 1));

    final initialMaxDate = _daysInMonth(selectedYear, selectedMonth);

    _dayController = FixedExtentScrollController(initialItem: initialMaxDate * 500 + (selectedDay - 1));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  bool _isValidDate() {
    final picked = DateTime(selectedYear, selectedMonth, selectedDay);
    return picked.isBefore(DateTime(_now.year, _now.month, _now.day));
  }

  @override
  Widget build(BuildContext context) {
    final maxDay = _daysInMonth(selectedYear, selectedMonth);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff340B57), Color(0xff1D0630)]
          )
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("생년월일 선택", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "N", fontWeight: FontWeight.w500),),
              SizedBox(height: 8,),
              Divider(height: 1, color: Colors.white24,),
              SizedBox(height: 24,),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                        child: _buildWheel(
                            controller: _yearController,
                            count: _now.year - _startYear + 1,
                            labelOf: (p0) => "${_startYear + p0}",
                            onChanged: (value) {
                              setState(() {
                                selectedYear = _startYear + value;
                                final max = _daysInMonth(selectedYear, selectedMonth);
                                if(selectedDay > max) {
                                  selectedDay = max;
                                  _dayController.jumpToItem(max * 500 + (selectedDay - 1));
                                }
                              });
                            },
                        )
                    ),
                    Expanded(
                        flex: 2,
                        child: _buildWheel(
                          controller: _monthController,
                          count: 12,
                          labelOf: (p0) => "${p0 + 1}".padLeft(2,'0'),
                          looping: true,
                          onChanged: (value) {
                            setState(() {
                              selectedMonth = value + 1;
                              final max = _daysInMonth(selectedYear, selectedMonth);
                              if(selectedDay > max) {
                                selectedDay = max;
                                _dayController.jumpToItem(max * 500 + (selectedDay - 1));
                              }
                            });
                          },
                        )
                    ),
                    Expanded(
                        flex: 2,
                        child: _buildWheel(
                          controller: _dayController,
                          count: maxDay,
                          labelOf: (p0) => "${p0 + 1}".padLeft(2,'0'),
                          looping: true,
                          onChanged: (value) {
                            setState(() {
                              selectedDay = value + 1;
                            });
                          },
                        )
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.white24,),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text("취소", style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: "N" , fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(width: 20,),
                  InkWell(
                    onTap: () {
                      if(_isValidDate()) {
                        Navigator.pop(context, DateTime(selectedYear, selectedMonth, selectedDay));
                      }
                    },
                    child: Text("선택", style: TextStyle(color: _isValidDate() ? Colors.white : Colors.grey, fontSize: 17, fontFamily: "N" , fontWeight: FontWeight.w500),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isCurrent(FixedExtentScrollController controller, int index) {
    try {
      return controller.selectedItem == index;
    } catch(_) {
      return false;
    }
  }

  Widget _buildWheel({required FixedExtentScrollController controller, required int count, required String Function(int) labelOf,  required ValueChanged<int> onChanged, bool looping = false}) {
    final virtualCount = looping ? count * 1000 : count;
    return CupertinoPicker.builder(
        itemExtent: 77,
        diameterRatio: 100,
        squeeze: 1.0,
        childCount: virtualCount,
        selectionOverlay: Container(),
        scrollController: controller,
        onSelectedItemChanged: (value) {
          final realIndex = looping ? value % count : value;
          return onChanged(realIndex);
        },
        itemBuilder: (context, index) {
          final realIndex = looping ? index % count : index;
          final isSelected = _isCurrent(controller, index);
          return Column(
            children: [
              Spacer(),
              Text(labelOf(realIndex), style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 22, fontFamily: "N", fontWeight: FontWeight.w600),),
              Spacer(),
              Text("ㅡ", style: TextStyle(color: isSelected ? Colors.white30 : Colors.white),)
            ],
          );
        },
    );
  }
  
}
