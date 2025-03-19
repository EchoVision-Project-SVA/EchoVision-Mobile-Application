import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'dart:convert';

class PredictController extends GetxController {
  var isLoading = false.obs;
  var resultText = ''.obs;
  var audioUrl = ''.obs;
  final AudioPlayer audioPlayer = AudioPlayer();

  // دالة اختيار الفيديو من المعرض وتشغيل التنبؤ
  Future<void> pickVideoAndPredict() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      await predict(videoFile);
    }
  }

  // دالة إرسال الفيديو إلى الـ API واستقبال النتيجة
  Future<void> predict(File videoFile) async {
    isLoading.value = true;
    try {
      var uri = Uri.parse("http://127.0.0.1:8000/api/predict");
      var request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        // بافتراض إن الـ API بترجع JSON بالشكل ده:
        // { "text": "النص هنا", "audio_url": "رابط الصوت" }
        var data = jsonDecode(responseData);
        resultText.value = data['text'] ?? '';
        audioUrl.value = data['audio_url'] ?? '';

        // لو تم استلام رابط الصوت، نجهز ونشغل الصوت تلقائي
        if (audioUrl.value.isNotEmpty) {
          await audioPlayer.setUrl(audioUrl.value);
          audioPlayer.play();
        }
      } else {
        Get.snackbar("خطأ", "فشل الاتصال بالخادم");
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
