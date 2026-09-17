import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setLanguage('en-US');
      // Slow toddler-friendly speech rate for maximum clarity
      await _flutterTts.setSpeechRate(kIsWeb ? 0.38 : 0.35);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.15);
      
      await _flutterTts.awaitSpeakCompletion(true);
      _isInitialized = true;
    } catch (e) {
      debugPrint('TTS init warning: $e');
      _isInitialized = true;
    }
  }

  Future<void> speakLetter(BuildContext context, String letter) async {
    await speakText(context, 'Letter $letter');
  }

  Future<void> speakWord(BuildContext context, String word) async {
    await speakText(context, word);
  }

  Future<void> speakText(BuildContext context, String text) async {
    try {
      await init();

      // Stop previous playback to avoid speech overlap
      await _flutterTts.stop();

      // Speak text
      var result = await _flutterTts.speak(text);
      debugPrint('TTS Speak result for "$text": $result');
    } catch (e) {
      debugPrint('TTS speak exception: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFE65100),
            duration: Duration(seconds: 2),
            content: Text(
              'Tap speaker icon to play sound 🔊',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
  }
}
