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

class TestHomePage extends StatefulWidget {
  const TestHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  bool isRunning = false;

  @override
  void initState() {
    isRunning = false;
    super.initState();
  }

  void onStart() {
    setState(() {
      isRunning = true;
    });
  }

  void onStop() {
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Timer will be here'),
            isRunning
                ? AnimatedRoundButtonWidget(
                    text: 'Stop',
                    width: 300,
                    onPressed: onStop,
                  )
                : RoundButtonWidget(
                    text: 'Start',
                    onPressed: onStart,
                    color: Colors.green,
                  ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double strokeWidth;

  const StrokeText({
    Key? key,
    required this.text,
    this.fontSize = 36,
    this.strokeWidth = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(text,
            style: TextStyle(
              fontSize: fontSize,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth,
            )),
        Text(text,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
            )),
      ],
    );
  }
}

class RoundButtonWidget extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final VoidCallback onPressed;

  const RoundButtonWidget({
    Key? key,
    required this.onPressed,
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
        onPressed: onPressed,
        child: StrokeText(text: text),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            primary: color,
            side: const BorderSide(
              width: 5.0,
              color: Colors.black,
            )),
      ),
    );
  }
}

class AnimatedButtonWidget extends AnimatedWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const AnimatedButtonWidget({
    Key? key,
    required Animation<Color?> animation,
    required this.text,
    required this.onPressed,
    this.width = 200,
    this.height = 200,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<Color?>;
    return RoundButtonWidget(
      text: text,
      color: animation.value ?? Colors.redAccent,
      width: width,
      height: height,
      onPressed: onPressed,
    );
  }
}

class AnimatedRoundButtonWidget extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const AnimatedRoundButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
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
  late Animation<Color?> _animation;

  static const Color _firstColor = Colors.redAccent;
  static const Color _secondColor = Color.fromARGB(255, 200, 128, 128);
  static final ColorTween _colorTween =
      ColorTween(begin: _firstColor, end: _secondColor);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _animation = _colorTween.animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void pressed() async {
    _animationController.stop();
    // call parent
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) => AnimatedButtonWidget(
        text: widget.text,
        width: widget.width,
        height: widget.height,
        onPressed: pressed,
        animation: _animation,
      );
}
