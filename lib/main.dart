import 'package:echovision/locale/locale.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// استيراد شاشة البداية
import 'package:echovision/app/screens/splash_screen.dart';

Future<void> requestPermissions() async {
  // طلب إذن الكاميرا والميكروفون
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();

  if (statuses[Permission.camera] != PermissionStatus.granted ||
      statuses[Permission.microphone] != PermissionStatus.granted) {
    // إذا لم تُمنح الأذونات، يمكنك عرض رسالة للمستخدم
    debugPrint('لم يتم منح أذونات الكاميرا أو الميكروفون');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();

  // وضع الـ Controller في الذاكرة قبل تشغيل التطبيق
  Get.put(Mylocalecontrol());

  runApp(const EchovisionApp());
}

class EchovisionApp extends StatelessWidget {
  const EchovisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم Obx لإعادة بناء واجهة التطبيق عند تغيير اللغة في الـ Controller
    final localeController = Get.find<Mylocalecontrol>();
    return Obx(() {
      return GetMaterialApp(
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        // نجعل اللغة المعتمدة في التطبيق هي المخزّنة في الـ Controller
        locale: localeController.currentLocale.value,
        // أو يمكنك إبقاء السطر التالي لو أردت البدء بلغة الجهاز الافتراضية:
        // locale: Get.deviceLocale,
        translations: Mylocle(),
        home: const SplashScreen(),
      );
    });
  }
}
