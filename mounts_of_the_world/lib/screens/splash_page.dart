import 'package:flutter/material.dart';

import '../globals.dart';
import 'mountapp.dart';

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
