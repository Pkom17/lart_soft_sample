import 'package:dno_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:dno_app/views/drawer.dart';

class About extends StatefulWidget {
  final UserModel? profile;
  const About({super.key, this.profile});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        profile: widget.profile,
      ),
      appBar: AppBar(
        title: const Text(
          "A propos",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
        ),
      ),
      body: const Center(
          // add your code here
          ),
    );
  }
}
