import 'package:flutter/material.dart';

const Color mainColor = Color(0xFFFF5656);

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: true,
    home: SplashPage(),
  ));
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: mainColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: const Icon(
                Icons.terrain,
                color: Colors.white,
                size: 90,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 80,
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
