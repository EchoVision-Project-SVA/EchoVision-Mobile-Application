// ignore_for_file: library_private_types_in_public_api

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// الصفحة الثانية: تعرض معاينة الكاميرا والتحكمات
class CamraScreen extends StatefulWidget {
  const CamraScreen({super.key});

  @override
  _CamraScreenState createState() => _CamraScreenState();
}

class _CamraScreenState extends State<CamraScreen> {
  // متغير لتحديد الكاميرا المستخدمة (أمامية أو خلفية)
  bool isRearCamera = false;
  // متغير لتحديد حالة التسجيل
  bool _isRecording = false;
  // مرجع لحالة الكاميرا للتحكم في التسجيل
  CameraState? _cameraState;
  // نتيجة التحليل
  String analysisResult = '5'.tr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.08),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // زر تسجيل الخروج في أعلى اليمين
         
            const SizedBox(height: 10),
            // معاينة الكاميرا
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 450,
                width: double.infinity,
                color: Colors.black87,
                child: CameraAwesomeBuilder.custom(
                  previewFit: CameraPreviewFit.fitHeight,
                  sensorConfig: SensorConfig.single(
                    sensor: isRearCamera
                        ? Sensor.position(SensorPosition.back)
                        : Sensor.position(SensorPosition.front),
                    flashMode: FlashMode.always,
                    aspectRatio: CameraAspectRatios.ratio_4_3,
                    zoom: 0.0,
                  ),
                  saveConfig: SaveConfig.photoAndVideo(),
                  mirrorFrontCamera: false,
                  enablePhysicalButton: false,
                  progressIndicator:
                      const Center(child: CircularProgressIndicator()),
                  onImageForAnalysis: (AnalysisImage image) async {
                    // هنا يمكنك معالجة كل إطار للتحليل
                    await Future.delayed(const Duration(milliseconds: 100));
                    return;
                  },
                  builder: (CameraState state, Preview preview) {
                    _cameraState = state;
                    return Container();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // الكابشن أسفل الكاميرا
            Container(
              height: 132,
              width: 386,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                analysisResult,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // صف الأزرار: زر تبديل الكاميرا وزر الشتر
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isRearCamera = !isRearCamera;
                    });
                  },
                  child: Image.asset(
                    "assets/Images/Cameraswap.png",
                    height: 81,
                    width: 81,
                  ),
                ),
                const SizedBox(width: 35),
                GestureDetector(
                  onTap: () {
                    if (_cameraState != null) {
                      _cameraState!.when(
                        onVideoMode: (videoState) {
                          if (!_isRecording) {
                            videoState.startRecording();
                            setState(() {
                              _isRecording = true;
                            });
                          }
                        },
                        onVideoRecordingMode: (videoRecordingState) {
                          if (_isRecording) {
                            videoRecordingState.stopRecording();
                            setState(() {
                              _isRecording = false;
                            });
                          }
                        },
                      );
                    }
                  },
                  child: Image.asset(
                    "assets/Images/Shutter.png",
                    height: 81,
                    width: 81,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
