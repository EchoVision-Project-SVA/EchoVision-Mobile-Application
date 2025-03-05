import 'package:flutter/material.dart';

class LanguageSwitch extends StatefulWidget {
  final bool isArabic;               // هل اللغة الحالية هي العربية
  final ValueChanged<bool> onChanged; // دالة تُستدعى عند تغيير الحالة

  const LanguageSwitch({
    super.key,
    required this.isArabic,
    required this.onChanged,
  });

  @override
  _LanguageSwitchState createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  late bool isArabic;

  @override
  void initState() {
    super.initState();
    // ضبط القيمة الابتدائية بناءً على ما يأتي من الـ parent
    isArabic = widget.isArabic;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // عند الضغط نقلب الحالة ونستدعي الدالة الممرّرة من الخارج
        setState(() {
          isArabic = !isArabic;
        });
        widget.onChanged(isArabic);
      },
      child: Container(
        width: 70,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[300],          // الخلفية الرمادية الثابتة
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // النص "EN" في الجهة اليسرى (دائمًا باللون الأسود)
            Positioned(
              left: 10,
              top: 10,
              child: Text(
                'EN',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // النص "AR" في الجهة اليمنى (دائمًا باللون الأسود)
            Positioned(
              right: 10,
              top: 10,
              child: Text(
                'AR',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // الجزء المتحرك (الدائرة الزرقاء) مع النص الذي يدل على اللغة الحالية
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              // إذا isArabic == true => تتموضع في اليمين، والعكس صحيح
              alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blue,       // لون ثابت للدائرة
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: Text(
                  // إذا isArabic == true => "AR" وإلا "EN"
                  isArabic ? 'AR' : 'EN',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,    // النص باللون الأبيض داخل الدائرة
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
