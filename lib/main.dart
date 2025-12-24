// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'about_page.dart';
import 'person.dart';
import 'facedetectionview.dart';
import 'user_activity.dart';
import 'db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Recognition',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Face Recognition'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String _warningState = "";
  bool _visibleWarning = false;

  final _facesdkPlugin = FacesdkPlugin();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    int facepluginState = -1;

    try {
      facepluginState = await _facesdkPlugin.setActivation(
            "fzALKHxa5oYw5fzkRdJ1bITesTUlnePuBCGJDhr948H06ZB6jO5bcxezJKPVpDq4HKsz9Gko3Eq1NRmHE5vNLHBeoWENtxbtZ5JDbMWAnNoaF6c/CzSREzrfucQPMzgw/tTnxvVLojXP0Mr9k4i1aJ1zGg/S6WxiD2sa9DPxtxtrjnqOMj2Ky66yEssP68hIyTZI9a5wn9dabEBay/DkcyBpv9Wm8EUOdkQ03AZKaB49BdvQJn7EWDdz2Lci089ta/ghKM4fXAnUhc98DNm9VddNvC5Y+sABHYjKe7MiHeEIK//Gn8Jmg5jKwcahWFM8X0mBxCHQufvClQm3zH6twA==") ??
          -1;

      if (facepluginState == 0) {
        facepluginState = await _facesdkPlugin.init() ?? -1;
      }
    } catch (_) {}

    if (facepluginState < 0) {
      setState(() {
        _visibleWarning = true;
        _warningState = {
              -1: "Invalid license!",
              -2: "License expired!",
              -3: "Invalid license!",
              -4: "No activation!",
              -5: "Init error!"
            }[facepluginState] ??
            "Unknown error";
      });
    }
  }

  /// 🔥 Improved Menu Card (smaller icon, perfect alignment)
  Widget _menuCard({
    required String title,
    required String subtitle,
    required String image,
    required VoidCallback onTap,
    Color backgroundColor = const Color(0xFFFCFCFC),
    
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            /// LEFT ICON – FIXED SIZE, CLEAN LOOK
            Image.asset(
              "assets/images/$image",
              width: 42,
              height: 42,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 18),

            /// TITLE + SUBTITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: const Color(0xFF25C0DE),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),

            /// RIGHT ARROW
            Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0BCFF),
      appBar: AppBar(
        title: const Text('Face Recognition'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// HEADER LOGO
              Image.asset(
                "assets/images/company_name.png",
                height: 70,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 15),

              /// SERVICE IMAGE – BIGGER (fixed height)
              Image.asset(
                "assets/images/service2.png",
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 20),

              /// MENUS
              _menuCard(
                title: "Enroll Faces",
                subtitle: "Registering user face data",
                image: "enroll_face.png",
                backgroundColor: const Color(0xFFFCFCFC),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => UserActivity()));
                },
              ),

              _menuCard(
                
                title: "Verify Faces",
                subtitle: "Matching Face Algorithm (1:1, 1:N)",
                image: "verify_face.png",
                onTap: () async {
                  List<Person> list = await AppDB.instance.loadAllPersons();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FaceRecognitionView(personList: list),
                    ),
                  );
                },
              ),

              _menuCard(
                title: "Liveness",
                subtitle: "Anti-spoofing Face Liveness Test",
                image: "liveness_test.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FaceRecognitionView(
                        personList: [],
                        livenessOnly: true,
                      ),
                    ),
                  );
                },
              ),

              _menuCard(
                title: "About Us",
                subtitle: "Learn more about MiniAiLive Ltd",
                image: "about_us.png",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AboutPage()));
                },
              ),

              /// WARNING MESSAGE
              if (_visibleWarning)
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCFCFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _warningState,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
