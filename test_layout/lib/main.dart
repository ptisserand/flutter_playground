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
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MountApp()));
    });
    return Container(
        color: mainColor,
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Icon(
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

class MountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome to Mounts of the World!'),
      ),
    );
  }
}
