import 'package:flutter/material.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:echovision/app/controllers/home_controller.dart';
import 'package:echovision/app/screens/LanguageSwitch.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:just_audio/just_audio.dart';

class Voice extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const Voice({super.key, required this.audioPlayer});
  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double volume = 1.0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final localeController = Get.find<Mylocalecontrol>();
    Get.put(PredictController());

    // نستخدم Container بارتفاع محدد يساوي ارتفاع الشاشة
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
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // خلفية ثابتة
              Positioned.fill(
                child: Container(color: Colors.white),
              ),
              // صور الخلفية
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
              // المحتوى المركزي
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 300),
                    Container(
                      alignment: Alignment.center,
                      height: 80,
                      width: 350,
                      color: Colors.grey.shade200,
                      child: Text(
                        "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 200),
                    Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
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
                              volume == 0.0
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              size: 30,
                            ),
                            onPressed: () async {
                              setState(() {
                                volume = volume == 0.0 ? 1.0 : 0.0;
                              });
                              await widget.audioPlayer.setVolume(volume);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
