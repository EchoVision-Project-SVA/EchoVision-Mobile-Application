// ignore_for_file: library_private_types_in_public_api

import 'package:echovision/app/controllers/home_controller.dart';
import 'package:echovision/app/screens/LanguageSwitch.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:just_audio/just_audio.dart'; // لإغلاق التطبيق

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<Mylocalecontrol>();
    final PredictController controller = Get.put(PredictController());
    return Scaffold(
      // AppBar بسيط يحتوي على عنوان "home".tr
      appBar: AppBar(),

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

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  controller.pickVideoAndPredict();
                },
                child: Text(
                  "Upload Video",
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Text result:"),
                      SizedBox(height: 8),
                      Text(controller.resultText.value),
                      SizedBox(height: 20),
                      // عرض مشغل الصوت لو رابط الصوت موجود
                      if (controller.audioUrl.value.isNotEmpty)
                        AudioPlayerWidget(audioPlayer: controller.audioPlayer),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const AudioPlayerWidget({super.key, required this.audioPlayer});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    // متابعة حالة مشغل الصوت للتحديث التلقائي للزر والشريط
    widget.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        duration = d ?? Duration.zero;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // تصميم مشابه لرسائل الصوت في واتس آب، يمكن التعديل حسب التصميم المطلوب
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
                await widget.audioPlayer.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
          Text(
            "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
