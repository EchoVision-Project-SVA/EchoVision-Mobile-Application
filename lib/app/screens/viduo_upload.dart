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
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<Mylocalecontrol>();
    Get.put(PredictController());
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'home'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
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
                    Navigator.pop(context);
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
        // نغلف المحتوى بـ Container محدود الارتفاع يساوي ارتفاع الشاشة
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // خلفية ثابتة
              Positioned.fill(
                child: Container(color: Colors.white),
              ),
              // صورة الخلفية
              Positioned.fill(
                child: Image.asset(
                  'assets/Images/toop.png',
                  fit: BoxFit.cover,
                ),
              ),
              // المحتوى المركزي
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 130),
                    Text(
                      '7'.tr,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 180),
                    const PulsingCirclesWithButton(),
                  ],
                ),
              ),
              // زر فتح الـ Drawer
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.sort_outlined, size: 35),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PulsingCirclesWithButton extends StatefulWidget {
  const PulsingCirclesWithButton({super.key});
  @override
  _PulsingCirclesWithButtonState createState() =>
      _PulsingCirclesWithButtonState();
}

class _PulsingCirclesWithButtonState extends State<PulsingCirclesWithButton>
    with SingleTickerProviderStateMixin {
  final double _smallCircleSize = 140;
  final double _bigCircleSize = 140;
  late AnimationController _controller;
  late Animation<double> _smallCircleAnimation;
  late Animation<double> _bigCircleAnimation;
  final PredictController controller = Get.put(PredictController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _smallCircleAnimation = Tween<double>(begin: -100, end: 80).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutSine),
      ),
    );
    _bigCircleAnimation = Tween<double>(begin: -100, end: 80).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutSine),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
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
                    shape: BoxShape.circle,
                    color: Color(0xFF89CAF5),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color(0xFF0098FF),
                  ),
                  onPressed: () {
                    controller.pickVideoAndPredict();
                  },
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(controller.resultText.value),
                    const SizedBox(height: 20),
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
