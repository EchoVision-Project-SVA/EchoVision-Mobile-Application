import 'package:echovision/app/screens/Camra_Screen.dart';
import 'package:echovision/app/screens/LanguageSwitch.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show SystemNavigator; // لإغلاق التطبيق

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<Mylocalecontrol>();

    return Scaffold(
      // AppBar بسيط يحتوي على عنوان "home".tr
      appBar: AppBar(
  
      ),
      
      // قائمة جانبية (Drawer) للتبديل بين اللغات + زر الخروج من التطبيق
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'home'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // عنصر تغيير اللغة داخل الدروار
            Obx(() {
              // التحقق هل اللغة الحالية "ar"
              bool isArabic =
                  (localeController.currentLocale.value.languageCode == 'ar');
              return ListTile(
                title: Text('change_lang'.tr),
                trailing: LanguageSwitch(
                  isArabic: isArabic,
                  onChanged: (bool newValue) {
                    if (newValue) {
                      localeController.chnglang('ar');
                    } else {
                      localeController.chnglang('en');
                    }
                    // إغلاق الـ Drawer بعد التغيير
                    Navigator.pop(context);
                  },
                ),
              );
            }),
            ListTile(
              title: Text('logout'.tr),
              onTap: () {
                // منطق تسجيل الخروج (إغلاق التطبيق بالكامل)
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
      
      // جسم الصفحة: خلفية متدرجة + نص ترحيبي + زر (شتر) في المنتصف
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // خلفية متدرجة من اللون الوردي الفاتح للأبيض (مثال فقط)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF1F5), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // نص ترحيبي يوضح فكرة التطبيق
              Text(
                'welcome_message'.tr, // تأكد من إضافته في ملف الترجمة
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              
              // زر في المنتصف (شبيه بالشتر) للانتقال إلى صفحة الكاميرا
              GestureDetector(
                onTap: () {
                  // الانتقال إلى الصفحة التي تعرض الكاميرا
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CamraScreen()),
                  );
                },
                child: Image.asset(
                  "assets/Images/Shutter2.png",
                  height: 81,
                  width: 81,
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
