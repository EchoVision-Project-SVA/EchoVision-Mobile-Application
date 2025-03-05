import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> login() async {
    isLoading.value = true;
    errorMessage.value = '';

    final payload = jsonEncode({
      "email": email.value,
      "password": password.value,
    });

    final String baseUrl = Platform.isIOS ?"http://localhost:3000": "http://10.0.2.2:3000" ;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        DateTime subscriptionExpiration = DateTime.parse(data["subscription_expiration"]);
        DateTime now = DateTime.now().toUtc();

        if (subscriptionExpiration.isAfter(now)) {
          print("تم تسجيل الدخول بنجاح");
        } else {
          errorMessage.value = "subscription_expired".tr;
        }
      } else {
        errorMessage.value = "login_failed".tr;
      }
    } catch (e) {
      errorMessage.value = "حدث خطأ: $e";
      print(e);
    }
    isLoading.value = false;
  }
}
