import 'package:flutter/material.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:echovision/app/controllers/home_controller.dart';
import 'package:echovision/app/screens/LanguageSwitch.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:just_audio/just_audio.dart';

class Voice extends StatefulWidget {
  final AudioPlayer audioPlayer;
  Voice({super.key, required this.audioPlayer});
  _Voice createState() => _Voice();
}

class _Voice extends State<Voice> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double volume = 1.0;
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
              Image.asset(
                'assets/Images/—Pngtree—geometric shapes patterns vector_3553180 (1) 3 (1).png',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/Images/packgrawnd.png',
                fit: BoxFit.cover,
              ),
            ],
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80,
                  width: 350,
                  color: Colors.grey.shade200,
                  child: Text(
                    "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () async {
                          if (isPlaying) {
                            await widget.audioPlayer.pause();
                          } else {
                            await widget.audioPlayer.play();
                          }
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Slider(
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble() > 0
                              ? duration.inSeconds.toDouble()
                              : 1,
                          onChanged: (value) async {
                            await widget.audioPlayer
                                .seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          volume == 0.0 ? Icons.volume_off : Icons.volume_up,
                          size: 30,
                        ),
                        onPressed: () async {
                          setState(() {
                            // إذا كان الصوت مكتوم، فافتح الصوت وإلا اكتمه
                            volume = volume == 0.0 ? 1.0 : 0.0;
                          });
                          await widget.audioPlayer.setVolume(volume);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
