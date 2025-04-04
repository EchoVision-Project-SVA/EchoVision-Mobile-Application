// ignore_for_file: library_private_types_in_public_api

import 'package:echovision/app/screens/home_screen.dart';
import 'package:echovision/app/screens/login_screen.dart';
import 'package:echovision/app/screens/viduo_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتظار لمدة800 ملي من الثانيه ثم الانتقال للصفحة التالية
    Timer(const Duration(milliseconds: 800), () {
      Get.to(Video());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/Images/SplashScreen.png', // تأكد من صحة المسار وامتداد الصورة
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
