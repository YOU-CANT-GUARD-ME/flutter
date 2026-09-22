import 'package:flutter/material.dart';

class OutLineButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const OutLineButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white10
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(title == "이전" ? Icons.arrow_back_ios_new_rounded : null, size: 18, color: Colors.white70,),
            if(title == "이전")
              SizedBox(width: 10,),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "N", fontWeight: FontWeight.w600),),
            if(title == "잘 모르겠어요")
              SizedBox(width: 10,),
            Icon(title == "잘 모르겠어요" ? Icons.arrow_forward_ios_rounded : null, size: 18, color: Colors.white70,),
          ],
        ),
      ),
    );
  }
}
