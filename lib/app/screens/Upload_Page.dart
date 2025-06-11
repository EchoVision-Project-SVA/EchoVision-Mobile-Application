// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:echovision/app/controllers/home_controller.dart';
import 'package:echovision/app/screens/LanguageSwitch.dart';
import 'package:echovision/app/screens/Result_Page.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<Mylocalecontrol>();
    final PredictController controller = Get.put(PredictController());
    // إنشاء مفتاح للتحكم بالـ Scaffold
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      // الـ Drawer بدون تغيير
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
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
            // تبديل اللغة باستخدام Obx
            Obx(() {
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
                  },
                ),
              );
            }),
            ListTile(
              title: Text('logout'.tr),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // الخلفية بصورة ثابتة
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Images/BACKGRAWIND.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              // توزيع العناصر عمودياً مع تباعد مناسب
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // عرض الصورة sort.svg مع فتح الـ Drawer عند النقر عليها
                Obx(() {
                  bool isArabic =
                      (localeController.currentLocale.value.languageCode ==
                          'ar');
                  return Align(
                    alignment:
                        isArabic ? Alignment.centerLeft : Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                      child: SvgPicture.asset(
                        'assets/Images/sort.svg',
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  child: Text(
                    "Video Upload",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 300),
                // هنا استبدلنا زر رفع الفيديو بالزر المتحرك المخصص
                Center(
                  child: AnimatedUploadButton(
                    onPressed: () async {
                      await controller.pickVideoAndPredict();
                      // التنقل إلى صفحة عرض النتائج بعد إتمام العملية
                      Get.to(() => const ResultPage());
                    },
                  ),
                ),
                const SizedBox(height: 300),
                // عرض مؤشر التحميل أثناء العملية
                Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return Container();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ويدجت الزر المتحرك مع تأثير Ripple متكرر بلا نهاية
class AnimatedUploadButton extends StatefulWidget {
  final VoidCallback onPressed;
  const AnimatedUploadButton({super.key, required this.onPressed});

  @override
  _AnimatedUploadButtonState createState() => _AnimatedUploadButtonState();
}

class _AnimatedUploadButtonState extends State<AnimatedUploadButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double buttonSize = 100.0;
  final double maxScale = 1.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildRipple(double delay, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = (_controller.value + delay) % 1;
        double scale = 2.0 + (maxScale - 0.5) * progress;
        double opacity = 1.0 - progress;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(opacity * 0.9),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ثلاث دوائر بتأخيرات مختلفة مع درجات لون أزرق مختلفة
            buildRipple(0.0, Colors.blue.shade200),
            buildRipple(0.3, Colors.blue.shade400),
            buildRipple(0.6, Colors.blue.shade600),
            // الصورة الثابتة في المنتصف (غيرل المسار حسب المطلوب)
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blue
              ),
              child: Image.asset(
                'assets/Images/Group.png',
                width: buttonSize * 0.5,
                height: buttonSize * 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
