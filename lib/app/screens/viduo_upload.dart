import 'package:echovision/app/screens/home_screen.dart';
import 'package:echovision/app/screens/outputvoice.dart';

import 'package:flutter/material.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:echovision/app/controllers/home_controller.dart';
import 'package:echovision/app/screens/LanguageSwitch.dart';

import 'package:get/get.dart';
import 'package:flutter/services.dart' show SystemNavigator;

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<StatefulWidget> createState() => _Viduo();
}

class _Viduo extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
    final localeController = Get.find<Mylocalecontrol>();
    Get.put(PredictController());
    return Scaffold(
      // قائمة جانبية (Drawer) للتبديل بين اللغات + زر الخروج من التطبيق
      key: scaffoldkey,
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
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            width: 500,
            height: 1000,
          ),
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/Images/toop.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 130,
                ),
                Text(
                  '7'.tr,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 180,
                ),
                Stack(children: [PulsingCirclesWithButton()])
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
                onPressed: () {
                  scaffoldkey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.sort_outlined,
                  size: 35,
                )),
          )
        ],
      ),
    );
  }
}

class PulsingCirclesWithButton extends StatefulWidget {
  PulsingCirclesWithButton({Key? key}) : super(key: key);

  final localeController = Get.find<Mylocalecontrol>();

  _PulsingCirclesWithButtonState createState() =>
      _PulsingCirclesWithButtonState();
}

class _PulsingCirclesWithButtonState extends State<PulsingCirclesWithButton>
    with SingleTickerProviderStateMixin {
  // الحجم الابتدائي للدائرة الأصغر والأكبر
  final double _smallCircleSize = 140; //لدائرة الأصغر
  final double _bigCircleSize = 140; //الدائرة الأكبر

  late AnimationController _controller;
  late Animation<double> _smallCircleAnimation;
  late Animation<double> _bigCircleAnimation;

  final PredictController controller = Get.put(PredictController());
  void initState() {
    super.initState();
    // مدة الحركة 1.5 ثانية - يمكنك تعديلها لزيادة/تقليل السرعة
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // الدائرة الأصغر تنبض أولًا (من 0% إلى 50% من زمن الدورة)
    _smallCircleAnimation = Tween<double>(begin: -100, end: 80).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // الدائرة الأكبر تنبض بعد فترة (من 30% إلى 100% من زمن الدورة)
    _bigCircleAnimation = Tween<double>(begin: -100, end: 80).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder لإعادة بناء الواجهة عند تغير قيمة _controller.value
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // الدائرة الأكبر (لون أفتح) - تبدأ نبضها بعد الدائرة الأصغر
                Container(
                  width: _bigCircleSize + _bigCircleAnimation.value,
                  height: _bigCircleSize + _bigCircleAnimation.value,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD2EAFB),
                  ),
                ),
                Container(
                  width: _smallCircleSize + _smallCircleAnimation.value,
                  height: _smallCircleSize + _smallCircleAnimation.value,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF89CAF5)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Color(0xFF0098FF),
                  ),
                  onPressed: () {
                    controller.pickVideoAndPredict();

                    // يمكنك إضافة أي حدث عند الضغط هنا
                  },
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(controller.resultText.value),
                    SizedBox(height: 20),
                    // عرض مشغل الصوت لو رابط الصوت موجود
                    if (controller.audioUrl.value.isNotEmpty)
                      Voice(audioPlayer: controller.audioPlayer),
                  ],
                );
              }
            }),
          ],
        );
      },
    );
  }
}
