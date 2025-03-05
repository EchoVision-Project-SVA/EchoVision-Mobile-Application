import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mylocalecontrol extends GetxController {
  // سنعتبر اللغة الافتراضية "en"
  var currentLocale = const Locale('en').obs;

  void chnglang(String codeLang) {
    currentLocale.value = Locale(codeLang);
    Get.updateLocale(currentLocale.value);
  }
}
