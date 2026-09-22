import 'package:flutter/material.dart';

class BottomActionButton extends StatelessWidget {
  final bool img;
  final String title;
  final bool checkedIcon;
  final VoidCallback onTap;
  const BottomActionButton({
    super.key,
    required this.img,
    required this.title,
    required this.checkedIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
              begin: Alignment(-5, -5),
              end: Alignment.centerRight,
              colors: [Colors.yellow.shade200, Color(0xff2A0050)]
          )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(img)
              Image.asset("assets/img/moon.png", width: 40,),
            SizedBox(width: 5,),
            Text(title, style: TextStyle(color: Colors.white, fontFamily: "M", fontSize: 17, fontWeight: FontWeight.w700),),
            SizedBox(width: 8,),
            if(checkedIcon)
              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white70,)
          ],
        ),
      ),
    );
  }
}
