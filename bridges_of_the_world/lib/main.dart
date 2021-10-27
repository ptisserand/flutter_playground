import 'package:flutter/material.dart';

const Color mainYellow = Color(0xFFFFB02F);
const Color primaryGray = Color(0xFF313131);
const Color secondaryGray = Color(0xFF1C1C1C);
const Color lightGray = Color(0xFF3B3B3B);

void main() {
  runApp(MaterialApp(
    home: LandingPage(),
  ));
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGray,
        iconTheme: const IconThemeData(
          color: mainYellow,
        ),
        title: const Center(
          child: Icon(Icons.airplanemode_on),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_on_outlined,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: mainYellow,
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(20),
          child: const Icon(
            Icons.airplanemode_on,
            color: Colors.black,
            size: 80,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryGray,
              secondaryGray,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
