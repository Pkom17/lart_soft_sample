import 'package:flutter/material.dart';
import 'package:dno_app/models/user_model.dart';
import 'package:dno_app/views/drawer.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? profile;
  const HomeScreen({super.key, this.profile});
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        profile: widget.profile,
      ),
      appBar: AppBar(
        title: const Text(
          "Accueil",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ListTile(
            title: Text(
              "Lab Sample Tracker App",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          ),
          Center(
            child: Image.asset(
              "images/back.jpg",
            ),
          ),
        ],
      ),
    );
  }
}
