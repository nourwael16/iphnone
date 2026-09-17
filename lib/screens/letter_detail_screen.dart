import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/abc_data.dart';
import '../services/tts_service.dart';
import '../widgets/totty_card.dart';
import 'quiz_screen.dart';

class LetterDetailScreen extends StatefulWidget {
  final int initialIndex;

  const LetterDetailScreen({super.key, this.initialIndex = 0});

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    // Speak initial letter on launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakCurrentLetter();
    });
  }

  void _speakCurrentLetter() {
    final letter = AbcData.letters[_currentIndex];
    TtsService().speakLetter(context, letter.capital);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentIndex < AbcData.letters.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AbcData.letters[_currentIndex].color,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, size: 32, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        title: Text(
          'Letter ${AbcData.letters[_currentIndex].capital}',
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
              Navigator.pop(context);
            },
          ),
          // Quiz shortcut
          IconButton(
            tooltip: 'Quiz Game',
            icon: const Icon(Icons.sports_esports_rounded, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuizScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // PageView for letters A-Z
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: AbcData.letters.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _speakCurrentLetter();
              },
              itemBuilder: (context, index) {
                final letter = AbcData.letters[index];
                return _buildLetterPage(letter);
              },
            ),
          ),

          // Bottom Navigation Bar with Previous, Home, Grid, Quiz, Next
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildLetterPage(LetterModel letter) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            letter.secondaryColor,
            Colors.white,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Big Banner Card for Letter
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: letter.color, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: letter.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        letter.capital,
                        style: GoogleFonts.fredoka(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: letter.color,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        letter.small,
                        style: GoogleFonts.fredoka(
                          fontSize: 60,
                          fontWeight: FontWeight.w600,
                          color: letter.color.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        letter.mainEmoji,
                        style: const TextStyle(fontSize: 64),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Sound Button 🔊
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: letter.color,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      TtsService().speakLetter(context, letter.capital);
                    },
                    icon: const Text('🔊', style: TextStyle(fontSize: 22)),
                    label: Text(
                      'Listen Letter ${letter.capital}',
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Totty Mascot Guidance
            TottyCard(
              message: 'حرف الـ ${letter.capital} زي كلمة ${letter.words.first.word}! يلا نسمعها سوا من توتي 🦊',
              englishAudioText: 'Letter ${letter.capital}, ${letter.words.first.word}',
              themeColor: letter.color,
            ),

            const SizedBox(height: 16),

            // Section Header
            Row(
              children: [
                const Text('📝 ', style: TextStyle(fontSize: 22)),
                Text(
                  'Words starting with ${letter.capital}:',
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF37474F),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 3 Word Cards
            Column(
              children: letter.words.map((word) => _buildWordCard(letter, word)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordCard(LetterModel letter, WordModel word) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: letter.color.withOpacity(0.4), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            TtsService().speakWord(context, word.word);
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Word Emoji Box
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: letter.secondaryColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: letter.color.withOpacity(0.3), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      word.emoji,
                      style: const TextStyle(fontSize: 38),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Word Title & Category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.word,
                        style: GoogleFonts.fredoka(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF263238),
                        ),
                      ),
                      Text(
                        word.category,
                        style: GoogleFonts.fredoka(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Sound Button 🔊
                InkWell(
                  onTap: () {
                    TtsService().speakWord(context, word.word);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: letter.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: letter.color.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🔊', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final letter = AbcData.letters[_currentIndex];
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == AbcData.letters.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isFirst ? Colors.grey.shade300 : letter.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: isFirst ? null : _goToPreviousPage,
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              label: Text(
                'Previous',
                style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // Letter Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: letter.secondaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_currentIndex + 1} / ${AbcData.letters.length}',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: letter.color,
                ),
              ),
            ),

            // Next Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isLast ? Colors.grey.shade300 : letter.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: isLast ? null : _goToNextPage,
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
