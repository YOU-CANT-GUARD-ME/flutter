import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BirthDatePickerDialog extends StatefulWidget {
  final DateTime? initalDate;
  const BirthDatePickerDialog({super.key, required this.initalDate});

  @override
  State<BirthDatePickerDialog> createState() => _BirthDatePickerDialogState();
}

class _BirthDatePickerDialogState extends State<BirthDatePickerDialog> {
  final startYear = 1950;
  final DateTime now = DateTime.now().toUtc().add(Duration(hours: 9));

  late int year, month, day;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final init = widget.initalDate ?? DateTime(2025, 4, 1);
    year = init.year;
    month = init.month;
    day = init.day;
  }

  bool get isValid {
    final picked = DateTime(year, month, day);
    return picked.day == day && picked.isBefore(DateTime(now.year, now.month, now.day));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: [Color(0xff340b57), Color(0xff1D0630)]
          )
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
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
                    Expanded(flex: 3, child: wheel(startYear, now.year, year, false, (v) => year = v),),
                    Expanded(flex: 2, child: wheel(1, 12, month, true, (v) => month = v),),
                    Expanded(flex: 2, child: wheel(1, 31, day, true, (v) => day = v),),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              Divider(height: 1, color: Colors.white24,),
              SizedBox(height: 24,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text("취소", style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: "N", fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(width: 20,),
                  InkWell(
                    onTap:isValid ? () => Navigator.pop(context, DateTime(year, month, day)) : null,
                    child: Text("선택", style: TextStyle(color: isValid ? Colors.white : Colors.grey, fontSize: 17,),),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget wheel(int from, int to, int selected, bool looping, void Function(int) onChanged) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: selected - from),
      looping: looping,
      itemExtent: 77,
      diameterRatio: 100,
      squeeze: 1.0,
      selectionOverlay: Container(),
      onSelectedItemChanged: (i) => setState(() => onChanged(from + i)),
      children: [
        for(int n = from; n <= to; n++)
          Column(
            children: [
              Spacer(),
              Text(
                n < 100 ? "$n".padLeft(2, '0') : "$n",
                style: TextStyle(color: n == selected ? Colors.white : Colors.grey, fontSize: 22, fontFamily: "N", fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Text("ㅡ", style: TextStyle(color: n == selected ? Colors.white30 : Colors.white),),
            ],
          )
      ],
    );
  }
}
