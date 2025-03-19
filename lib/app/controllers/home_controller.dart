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

  @override
  void onInit() {
    super.onInit();
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        audioPlayer.pause();
        audioPlayer.seek(Duration.zero);
      }
    });
  }

  // دالة اختيار الفيديو من المعرض وتشغيل التنبؤ
  Future<void> pickVideoAndPredict() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        File videoFile = File(pickedFile.path);
        await predict(videoFile);
      } else {
        Get.snackbar("إلغاء", "لم يتم اختيار فيديو");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء اختيار الفيديو: $e");
    }
  }

  // دالة إرسال الفيديو إلى الـ API واستقبال النتيجة مع تحسين معالجة الأخطاء والتحقق من الرابط الصوتي
  Future<void> predict(File videoFile) async {
    isLoading.value = true;
    try {
      // استخدام http في رابط الـ API
      var uri = Uri.parse("http://10.0.2.2:8000/api/predict");
      var request = http.MultipartRequest("POST", uri);
      // تأكد من اسم الحقل كما يتوقعه السيرفر (مثلاً 'file' أو 'video')
      request.files
          .add(await http.MultipartFile.fromPath('file', videoFile.path));

      var response = await request.send();
      // قراءة الاستجابة بالكامل
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(responseBody);
          resultText.value = data['prediction_text'] ?? '';
          // استلام الرابط من السيرفر
          audioUrl.value = data['audio_file'] ?? '';

          // طباعة الرابط للتأكد
          print("Audio URL received: ${audioUrl.value}");

          // استبدال العنوان إذا كان يحتوي على 127.0.0.1:8000
          if (audioUrl.value.isNotEmpty &&
              audioUrl.value.contains("127.0.0.1:8000")) {
            audioUrl.value =
                audioUrl.value.replaceAll("127.0.0.1:8000", "10.0.2.2:8000");
            print("Converted Audio URL: ${audioUrl.value}");
          }

          // التحقق من إمكانية الوصول للرابط عبر طلب GET
          if (audioUrl.value.isNotEmpty) {
            try {
              final audioResponse = await http.get(Uri.parse(audioUrl.value));
              print("Audio GET response status: ${audioResponse.statusCode}");
              print("Content-Type: ${audioResponse.headers['content-type']}");
              if (audioResponse.statusCode == 200) {
                try {
                  // محاولة تحميل وتشغيل الصوت
                  await audioPlayer.setUrl(audioUrl.value);
                  audioPlayer.play();
                } catch (audioError) {
                  Get.snackbar("خطأ في الصوت", "فشل تحميل الصوت: $audioError");
                }
              } else {
                Get.snackbar("خطأ في الصوت",
                    "الرابط غير متاح (رمز الاستجابة: ${audioResponse.statusCode})");
              }
            } catch (getError) {
              Get.snackbar("خطأ في الصوت", "فشل التحقق من الرابط: $getError");
            }
          }
        } catch (jsonError) {
          Get.snackbar("خطأ", "فشل تحليل بيانات الاستجابة: $jsonError");
        }
      } else {
        Get.snackbar("خطأ",
            "فشل الاتصال بالخادم (كود الخطأ: ${response.statusCode})\n$responseBody");
      }
    } on SocketException catch (socketError) {
      Get.snackbar("خطأ في الاتصال", "تحقق من اتصالك بالشبكة: $socketError");
    } on HttpException catch (httpError) {
      Get.snackbar("خطأ", "HTTP Exception: $httpError");
    } on FormatException catch (formatError) {
      Get.snackbar("خطأ", "تنسيق البيانات غير صحيح: $formatError");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير متوقع: $e");
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
