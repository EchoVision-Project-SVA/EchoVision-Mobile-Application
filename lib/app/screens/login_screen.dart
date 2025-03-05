import 'package:echovision/app/controllers/login_controller.dart';
import 'package:echovision/app/screens/LanguageSwitch.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.put(LoginController());
  final localeController = Get.find<Mylocalecontrol>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
               
                  Obx(() {
                    bool isArabic = localeController.currentLocale.value.languageCode == 'ar';
                    return LanguageSwitch(
                      isArabic: isArabic,
                      onChanged: (bool newValue) {
                        if (newValue) {
                          localeController.chnglang('ar');
                        } else {
                          localeController.chnglang('en');
                        }
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 30),
              Image.asset(
                'assets/Images/imageECHO.png',
                width: 170,
                height: 157,
              ),
              const SizedBox(height: 20),
               Text(
                "1".tr,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 45),
              TextField(
                decoration:  InputDecoration(
                  labelText: "2".tr,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  loginController.email.value = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "3".tr,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  loginController.password.value = value;
                },
              ),
              const SizedBox(height: 20),
              Obx(() => loginController.errorMessage.value.isNotEmpty
                  ? Text(
                      loginController.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  onPressed: loginController.isLoading.value
                      ? null
                      : () async {
                          await loginController.login();
                          if (loginController.errorMessage.value.isEmpty) {
                            Get.offAll(() => HomePage());
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0098FF),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: loginController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      :  Text(
                          "4".tr,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
