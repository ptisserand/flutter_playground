import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo circular button',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestHomePage(title: 'Demo circular button'),
    );
  }
}

class TestHomePage extends StatelessWidget {
  const TestHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Timer will be here'),
            RoundButtonWidget(text: 'Start', color: Colors.green),
            AnimatedRoundButtonWidget(text: 'Stop', width: 300),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RoundButtonWidget extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;

  const RoundButtonWidget({
    Key? key,
    required this.text,
    this.width = 200,
    this.height = 200,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width, height: height),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(text),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          primary: color,
        ),
      ),
    );
  }
}

class AnimatedRoundButtonWidget extends StatefulWidget {
  final String text;
  final double width;
  final double height;

  const AnimatedRoundButtonWidget({
    Key? key,
    required this.text,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  _AnimatedRoundButtonWidgetState createState() =>
      _AnimatedRoundButtonWidgetState();
}

class _AnimatedRoundButtonWidgetState extends State<AnimatedRoundButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  static final Color _firstColor = Colors.redAccent;
  static final Color _secondColor = Colors.grey;
  static final ColorTween _colorTween =
      ColorTween(begin: _firstColor, end: _secondColor);
  late Color _color;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animationController.repeat(reverse: true);
    _animation = _colorTween.animate(_animationController)
      ..addListener(() {
        setState(() {
          _color = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoundButtonWidget(
      text: widget.text,
      color: _color,
      width: widget.width,
      height: widget.height,
    );
  }
}
