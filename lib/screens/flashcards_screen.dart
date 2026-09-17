import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/abc_data.dart';
import '../services/tts_service.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  int _currentIndex = 0;
  bool _isPlaying = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSlideshow();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSlideshow() {
    _timer?.cancel();
    _speakCurrent();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_isPlaying) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % AbcData.letters.length;
        });
        _speakCurrent();
      }
    });
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _speakCurrent() {
    final letter = AbcData.letters[_currentIndex];
    TtsService().speakText(context, '${letter.capital}. ${letter.words.first.word}');
  }

  @override
  Widget build(BuildContext context) {
    final letter = AbcData.letters[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: letter.color,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Auto Flashcards 🎬',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [letter.secondaryColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Top Header Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isPlaying ? Icons.play_circle_fill_rounded : Icons.pause_circle_filled_rounded,
                        color: letter.color,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isPlaying ? 'Auto Slideshow Playing...' : 'Slideshow Paused',
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: letter.color,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Big Flashcard Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: letter.color, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: letter.color.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Letter Capital & Small
                      Text(
                        '${letter.capital} ${letter.small}',
                        style: GoogleFonts.fredoka(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: letter.color,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Emoji Graphic
                      Text(
                        letter.mainEmoji,
                        style: const TextStyle(fontSize: 90),
                      ),
                      const SizedBox(height: 16),

                      // First Word Text
                      Text(
                        letter.words.first.word,
                        style: GoogleFonts.fredoka(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF263238),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Playback Toolbar Controls
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 36,
                        icon: const Icon(Icons.skip_previous_rounded, color: Color(0xFF455A64)),
                        onPressed: () {
                          setState(() {
                            _currentIndex = (_currentIndex - 1 + AbcData.letters.length) % AbcData.letters.length;
                          });
                          _speakCurrent();
                        },
                      ),
                      IconButton(
                        iconSize: 52,
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                          color: letter.color,
                        ),
                        onPressed: _togglePlay,
                      ),
                      IconButton(
                        iconSize: 36,
                        icon: const Icon(Icons.skip_next_rounded, color: Color(0xFF455A64)),
                        onPressed: () {
                          setState(() {
                            _currentIndex = (_currentIndex + 1) % AbcData.letters.length;
                          });
                          _speakCurrent();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
