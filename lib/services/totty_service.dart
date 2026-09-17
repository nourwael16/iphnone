import 'package:flutter/material.dart';
import 'tts_service.dart';

class TottyService {
  static final TottyService _instance = TottyService._internal();
  factory TottyService() => _instance;
  TottyService._internal();

  // Egyptian Arabic welcoming messages
  static const String homeGreeting = 'أهلاً بيك يا شاطر! أنا توتي.. يلا نلعب ونتعلم إنجليزي مع بعض! 🎈';
  static const String learnGreeting = 'بص يا عسل.. الحروف والكلمات كتيرة وممتعة جداً مع توتي! 🔤';
  static const String quizGreeting = 'يلا نختبر ذكائنا مع توتي ونجمع نجوم كتيرة! ⭐';
  static const String quizCorrect = 'الله عليك يا بطل! إجابة ممتازة جداً! خد نجمة من توتي ⭐🎉';
  static const String quizRetry = 'ولا يهمك يا عسل.. توتي معاك، فكر تاني وهتجيبها صح! 💪';
  static const String tracingPrompt = 'يلا نمشي صباعنا مع توتي ونكتب الحرف بالألوان! ✏️🎨';
  static const String spellingPrompt = 'يلا نجمع الحروف مع توتي ونكون الكلمة! 🧩';
  static const String numbersPrompt = 'يلا نعد مع توتي من 1 لـ 10! 🔢';
  static const String stickersPrompt = 'شاطر أوي! كل ما تجمع نجوم أكتر تفتح استيكرات توتي الجميلة! 🖼️';

  Future<void> speakTottyMessage(BuildContext context, String message, {String? englishText}) async {
    // Speak English audio via TTS
    if (englishText != null && englishText.isNotEmpty) {
      await TtsService().speakText(context, englishText);
    } else {
      await TtsService().speakText(context, 'Hi kids! I am Totty!');
    }
  }
}
