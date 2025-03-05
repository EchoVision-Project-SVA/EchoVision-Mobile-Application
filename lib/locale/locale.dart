import 'package:get/get.dart';

class Mylocle implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': {
          '1': ' !مرحبًا بعودتك',
          '2': "الايميل",
          '3': "كلمة المرور",
          '4': "تسجيل الدخول",
          '5': "ماذا تقول؟",
     
          'subscription_expired': "انتهت صلاحية الاشتراك",
          'login_failed': "فشل تسجيل الدخول، تأكد من صحة بياناتك",
          'error_occurred': "حدث خطأ، يرجى المحاولة مرة أخرى",
          'change_lang': "تغيير اللغة",
          'logout': "تسجيل الخروج",
          'home':"مرحبًا بك في EchoVision!",
      'welcome_message': 'مرحبًا بك في EchoVision!\nاضغط على الزر أدناه للبدء في ترجمة حركة الشفاه.',
        },
        'en': {
          '1': 'Welcome back!',
          '2': "Email",
          '3': "Password",
          '4': "Login",
          '5': "What are you saying?",
  
          'subscription_expired': "Subscription has expired",
          'login_failed': "Login failed, please check your credentials",
          'error_occurred': "An error occurred, please try again",
          'change_lang': "Change Language",
          'logout': "Logout",
          'home': "Welcome to echo vision",
          'welcome_message': 'Welcome to EchoVision!\nPress the button below to start translating lip movements.',
        }
      };
}
