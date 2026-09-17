import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/abc_data.dart';
import '../services/score_manager.dart';
import '../services/tts_service.dart';
import '../services/totty_service.dart';
import '../widgets/totty_card.dart';
import 'learn_grid_screen.dart';

class QuizQuestion {
  final LetterModel targetLetter;
  final WordModel correctWord;
  final List<WordModel> choices;

  QuizQuestion({
    required this.targetLetter,
    required this.correctWord,
    required this.choices,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Random _random = Random();
  late ConfettiController _confettiController;
  late QuizQuestion _currentQuestion;

  WordModel? _selectedChoice;
  bool? _isCorrect;
  bool _answeredCorrectly = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _generateNewQuestion();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateNewQuestion() {
    setState(() {
      _selectedChoice = null;
      _isCorrect = null;
      _answeredCorrectly = false;

      // Pick a target letter randomly from A-Z
      final targetLetter = AbcData.letters[_random.nextInt(AbcData.letters.length)];
      // Pick one correct word from this letter
      final correctWord = targetLetter.words[_random.nextInt(targetLetter.words.length)];

      // Pick 2 wrong choices from other letters
      final wrongChoices = <WordModel>[];
      while (wrongChoices.length < 2) {
        final otherLetter = AbcData.letters[_random.nextInt(AbcData.letters.length)];
        if (otherLetter.capital != targetLetter.capital) {
          final randomWord = otherLetter.words[_random.nextInt(otherLetter.words.length)];
          if (!wrongChoices.contains(randomWord) && randomWord.word != correctWord.word) {
            wrongChoices.add(randomWord);
          }
        }
      }

      // Combine and shuffle choices
      final choices = [correctWord, ...wrongChoices]..shuffle();

      _currentQuestion = QuizQuestion(
        targetLetter: targetLetter,
        correctWord: correctWord,
        choices: choices,
      );
    });

    // Speak question prompt automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakQuestionPrompt();
    });
  }

  void _speakQuestionPrompt() {
    TtsService().speakText(
      context,
      'Which word starts with letter ${_currentQuestion.targetLetter.capital}?',
    );
  }

  void _handleChoiceSelection(WordModel choice) {
    if (_answeredCorrectly) return; // Prevent extra taps after winning

    final isCorrect = choice.word == _currentQuestion.correctWord.word;

    setState(() {
      _selectedChoice = choice;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _answeredCorrectly = true;
      _confettiController.play();
      ScoreManager().addStar();
      TtsService().speakText(context, 'Great! ${choice.word} starts with ${_currentQuestion.targetLetter.capital}');
    } else {
      TtsService().speakText(context, 'Try again!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final letter = _currentQuestion.targetLetter;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7043),
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, size: 32, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        title: Text(
          'Quiz Game 🎮',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Learn Grid shortcut
          IconButton(
            tooltip: 'Learn ABC Grid',
            icon: const Icon(Icons.grid_view_rounded, size: 28, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LearnGridScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF3E0),
                  Color(0xFFFBE9E7),
                  Color(0xFFFFFFFF),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  children: [
                    // Top Stars Badge Banner
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Row(
                            children: const [
                              Text('🏆 ', style: TextStyle(fontSize: 18)),
                              Text(
                                'Kids Quiz',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE65100),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Stars Badge
                        ValueListenableBuilder<int>(
                          valueListenable: ScoreManager().starsNotifier,
                          builder: (context, stars, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD54F),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
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
                      message: _isCorrect == true
                          ? TottyService.quizCorrect
                          : (_isCorrect == false
                              ? TottyService.quizRetry
                              : TottyService.quizGreeting),
                      englishAudioText: _isCorrect == true
                          ? 'Great job!'
                          : 'Which word starts with letter ${letter.capital}?',
                      themeColor: letter.color,
                    ),

                    const SizedBox(height: 12),

                    // Question Box Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: letter.color, width: 3.5),
                        boxShadow: [
                          BoxShadow(
                            color: letter.color.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Which word starts with',
                            style: GoogleFonts.fredoka(
                              fontSize: 20,
                              color: const Color(0xFF455A64),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${letter.capital} ${letter.small}',
                                style: GoogleFonts.fredoka(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: letter.color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // TTS Replay sound button 🔊
                              IconButton(
                                iconSize: 36,
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: letter.color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.volume_up_rounded, color: Colors.white),
                                ),
                                onPressed: _speakQuestionPrompt,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Choices List (3 Choices with Emojis)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _currentQuestion.choices.length,
                        itemBuilder: (context, index) {
                          final choice = _currentQuestion.choices[index];
                          final isSelected = _selectedChoice?.word == choice.word;
                          final isThisCorrect = choice.word == _currentQuestion.correctWord.word;

                          Color cardColor = Colors.white;
                          Color borderColor = const Color(0xFFB0BEC5);

                          if (isSelected) {
                            if (_isCorrect == true) {
                              cardColor = const Color(0xFFE8F5E9);
                              borderColor = const Color(0xFF4CAF50);
                            } else {
                              cardColor = const Color(0xFFFFEBEE);
                              borderColor = const Color(0xFFEF5350);
                            }
                          } else if (_answeredCorrectly && isThisCorrect) {
                            cardColor = const Color(0xFFE8F5E9);
                            borderColor = const Color(0xFF4CAF50);
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _handleChoiceSelection(choice),
                                borderRadius: BorderRadius.circular(24),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: borderColor, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: borderColor.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Choice Emoji Graphic
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            choice.emoji,
                                            style: const TextStyle(fontSize: 34),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      // Word label
                                      Expanded(
                                        child: Text(
                                          choice.word,
                                          style: GoogleFonts.fredoka(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF263238),
                                          ),
                                        ),
                                      ),

                                      // Audio icon 🔊
                                      IconButton(
                                        icon: const Icon(Icons.volume_up_rounded, color: Colors.orange, size: 28),
                                        onPressed: () {
                                          TtsService().speakWord(context, choice.word);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Feedback & Next Question Action
                    if (_isCorrect != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: _isCorrect == true ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _isCorrect == true ? ' Great! ⭐' : ' Try again! 💪',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            if (_isCorrect == true)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF2E7D32),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                                onPressed: _generateNewQuestion,
                                icon: const Icon(Icons.arrow_forward_rounded),
                                label: Text(
                                  'Next Question',
                                  style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Confetti Animation Overlay
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.amber
            ],
          ),
        ],
      ),
    );
  }
}
