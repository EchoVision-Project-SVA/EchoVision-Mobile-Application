// ignore_for_file: library_private_types_in_public_api

import 'package:echovision/app/controllers/home_controller.dart';
import 'package:echovision/app/screens/LanguageSwitch.dart';
import 'package:echovision/locale/locale_controlar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:just_audio/just_audio.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<Mylocalecontrol>();

    final PredictController controller = Get.find<PredictController>();
        final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
  
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(
                'home'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
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
            height: double.infinity,

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/BACKGRAWIND.png"),
                fit: BoxFit.cover,
              ),
            ),
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
            
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios_new_sharp))
                    ],
                  ),
                  SizedBox(height: 200,),
                Expanded(
                  child: Obx(() {
            
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Text",
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(controller.resultText.value),
                          const SizedBox(height: 20),
    
                          if (controller.audioUrl.value.isNotEmpty)
                            AudioPlayerWidget(audioPlayer: controller.audioPlayer),
                        ],
                      );
                    }
                  }),
                ),
              ],
            ),
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
      padding: const EdgeInsets.all(8),
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
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
