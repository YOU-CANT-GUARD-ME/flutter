import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Lesson2()));

class Lesson2 extends StatefulWidget {
  const Lesson2({super.key});

  @override
  State<Lesson2> createState() => _Lesson2State();
}

class _Lesson2State extends State<Lesson2> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;
  late final Animation<double> _size;
  late final Animation<Color?> _color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _size = Tween<double>(begin: 1.0, end: 2.5).animate(curved);
    _color = ColorTween(begin: Colors.orange, end: Colors.deepPurple).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Breathing Circle"),),
      body: Center(
        child: AnimatedBuilder(animation: _controller, builder: (context, child) {
          return Transform.scale(
            scale: _size.value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: _color.value,
              ),
            ),
          );
        }),
      ),
    );
  }
}
