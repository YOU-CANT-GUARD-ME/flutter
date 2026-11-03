import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Lesson2()));

class Lesson2 extends StatefulWidget {
  const Lesson2({super.key});

  @override
  State<Lesson2> createState() => _Lesson2State();
}

class _Lesson2State extends State<Lesson2> with TickerProviderStateMixin{
  late AnimationController controller;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 25,
                offset: Offset(0, 10),
              )
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: controller,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.grey.shade600, Colors.black],
                      stops: [0.4, 0.5, 0.6]
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.orange
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Text("Blinding Lights", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
              Text("The Weekend", style: TextStyle(color: Colors.grey, fontSize: 20),),
              SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: Icon(Icons.skip_previous, size: 50,)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                       setState(() {
                         if(isPlaying) {
                           controller.stop();
                         } else {
                           controller.repeat();
                         }
                         isPlaying = !isPlaying;
                       });
                      },
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 50,)
                    ),
                  ),
                  Expanded(child: Icon(Icons.skip_next, size: 50,)),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}

