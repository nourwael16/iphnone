import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/abc_data.dart';
import '../services/score_manager.dart';
import '../services/tts_service.dart';
import '../services/totty_service.dart';
import '../widgets/totty_card.dart';

class SpellingPuzzle {
  final WordModel targetWord;
  final String upperWord;
  final List<String> scrambledTiles;

  SpellingPuzzle({
    required this.targetWord,
    required this.upperWord,
    required this.scrambledTiles,
  });
}

class SpellingScreen extends StatefulWidget {
  const SpellingScreen({super.key});

  @override
  State<SpellingScreen> createState() => _SpellingScreenState();
}

class _SpellingScreenState extends State<SpellingScreen> {
  final Random _random = Random();
  late ConfettiController _confettiController;
  late SpellingPuzzle _currentPuzzle;
  final List<String?> _placedLetters = [];
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _generatePuzzle();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generatePuzzle() {
    // Collect all words from AbcData
    final allWords = AbcData.letters.expand((l) => l.words).toList();
    // Select short words suitable for kids (3-5 letters)
    final easyWords = allWords.where((w) => w.word.length >= 3 && w.word.length <= 5).toList();

    final target = easyWords[_random.nextInt(easyWords.length)];
    final upper = target.word.toUpperCase();

    // Create scrambled tiles (correct letters + 2 extra distractor letters)
    final letters = upper.split('');
    final distractors = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'O', 'P', 'R', 'S', 'T'];
    while (letters.length < upper.length + 2) {
      final d = distractors[_random.nextInt(distractors.length)];
      letters.add(d);
    }
    letters.shuffle();

    setState(() {
      _currentPuzzle = SpellingPuzzle(
        targetWord: target,
        upperWord: upper,
        scrambledTiles: letters,
      );
      _placedLetters.clear();
      for (int i = 0; i < upper.length; i++) {
        _placedLetters.add(null);
      }
      _isCompleted = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TtsService().speakText(context, 'Spell ${target.word}');
    });
  }

  void _onTapTile(String letter) {
    if (_isCompleted) return;

    TtsService().speakText(context, letter);

    // Find first empty slot
    final firstEmpty = _placedLetters.indexOf(null);
    if (firstEmpty != -1) {
      setState(() {
        _placedLetters[firstEmpty] = letter;
      });

      // Check if word is complete
      if (!_placedLetters.contains(null)) {
        final currentSpelled = _placedLetters.join('');
        if (currentSpelled == _currentPuzzle.upperWord) {
          _onSuccess();
        } else {
          TtsService().speakText(context, 'Try again!');
        }
      }
    }
  }

  void _onSuccess() {
    setState(() {
      _isCompleted = true;
    });
    _confettiController.play();
    ScoreManager().addStar();
    TtsService().speakText(
      context,
      'Awesome! You spelled ${_currentPuzzle.targetWord.word}',
    );
  }

  void _clearSlots() {
    setState(() {
      for (int i = 0; i < _placedLetters.length; i++) {
        _placedLetters[i] = null;
      }
      _isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Spelling Puzzle 🧩',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF3E5F5), Color(0xFFFFFFFF)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    // Top Stars Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Spell the word!',
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7B1FA2),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: ScoreManager().starsNotifier,
                          builder: (context, stars, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD54F),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 22)),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$stars',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD84315),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Totty Mascot Banner
                    TottyCard(
                      message: _isCompleted
                          ? 'الله عليك! كونت الكلمة صح يا شاطر! 🎉'
                          : TottyService.spellingPrompt,
                      englishAudioText: 'Spell ${_currentPuzzle.targetWord.word}',
                      themeColor: const Color(0xFF9C27B0),
                    ),

                    const SizedBox(height: 12),

                    // Target Emoji Picture Card
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFAB47BC), width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _currentPuzzle.targetWord.emoji,
                          style: const TextStyle(fontSize: 76),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAB47BC),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        TtsService().speakWord(context, _currentPuzzle.targetWord.word);
                      },
                      icon: const Text('🔊', style: TextStyle(fontSize: 18)),
                      label: Text(
                        'Listen "${_currentPuzzle.targetWord.word}"',
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Letter Slots Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_currentPuzzle.upperWord.length, (index) {
                        final char = _placedLetters[index];
                        return Container(
                          width: 54,
                          height: 64,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: char != null ? const Color(0xFFE1BEE7) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF8E24AA),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              char ?? '',
                              style: GoogleFonts.fredoka(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF4A148C),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const Spacer(),

                    // Scrambled Letter Tiles Row
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: _currentPuzzle.scrambledTiles.map((letter) {
                        return GestureDetector(
                          onTap: () => _onTapTile(letter),
                          child: Container(
                            width: 58,
                            height: 62,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD54F),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.orange.shade700, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                letter,
                                style: GoogleFonts.fredoka(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFBF360C),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const Spacer(),

                    // Actions Bar (Reset / Next)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8E24AA),
                            side: const BorderSide(color: Color(0xFF8E24AA), width: 2),
                          ),
                          onPressed: _clearSlots,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text('Reset', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
                        ),
                        if (_isCompleted)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _generatePuzzle,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: Text('Next Word', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
          ),
        ],
      ),
    );
  }
}
