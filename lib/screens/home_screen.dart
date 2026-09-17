import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/abc_data.dart';
import '../services/score_manager.dart';
import '../services/totty_service.dart';
import '../services/tts_service.dart';
import '../widgets/totty_card.dart';
import 'flashcards_screen.dart';
import 'learn_grid_screen.dart';
import 'letter_detail_screen.dart';
import 'numbers_screen.dart';
import 'quiz_screen.dart';
import 'spelling_screen.dart';
import 'stickers_screen.dart';
import 'talking_totty_screen.dart';
import 'tracing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFFFF9C4),
              Color(0xFFFFEBEE),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Stars Badge & Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: const [
                          Text('🎈', style: TextStyle(fontSize: 22)),
                          SizedBox(width: 6),
                          Text(
                            'ABC Fun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0288D1),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stars Counter Badge
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
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
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
                                  color: const Color(0xFFE65100),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      'English ABC Kids',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF283593),
                      ),
                    ),
                    Text(
                      'Learn Letters, Words, Tracing & Numbers!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        color: const Color(0xFF5C6BC0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Totty Mascot Banner Card
                    const TottyCard(
                      message: TottyService.homeGreeting,
                      englishAudioText: 'Welcome to English ABC Kids with Totty!',
                      themeColor: Color(0xFF0288D1),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Main Features Grid
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    _buildMenuCard(
                      context: context,
                      title: 'Talking Totty 🎤',
                      subtitle: 'Interactive pet teaches English & phonics 🦊',
                      emoji: '🦊',
                      colors: [const Color(0xFF8E24AA), const Color(0xFF6A1B9A)],
                      onTap: () {
                        TtsService().speakText(context, 'Talking Totty');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const TalkingTottyScreen()));
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildMenuCard(
                      context: context,
                      title: 'Learn ABC (A-Z)',
                      subtitle: 'Explore 26 Letters & 78 Words 🔤',
                      emoji: '🔤',
                      colors: [const Color(0xFF29B6F6), const Color(0xFF0288D1)],
                      onTap: () {
                        TtsService().speakText(context, 'Learn A B C');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const LearnGridScreen()));
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildMenuCard(
                      context: context,
                      title: 'Quiz Game',
                      subtitle: 'Find words & earn stars ⭐',
                      emoji: '🎮',
                      colors: [const Color(0xFFFF7043), const Color(0xFFF4511E)],
                      onTap: () {
                        TtsService().speakText(context, 'Quiz Game');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildMenuCard(
                      context: context,
                      title: 'Trace & Write',
                      subtitle: 'Draw letters with finger colors ✏️',
                      emoji: '✏️',
                      colors: [const Color(0xFF66BB6A), const Color(0xFF388E3C)],
                      onTap: () {
                        TtsService().speakText(context, 'Trace and Write');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const TracingScreen()));
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildMenuCard(
                      context: context,
                      title: 'Spelling Puzzle',
                      subtitle: 'Arrange letters to spell words 🧩',
                      emoji: '🧩',
                      colors: [const Color(0xFFAB47BC), const Color(0xFF7B1FA2)],
                      onTap: () {
                        TtsService().speakText(context, 'Spelling Puzzle');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SpellingScreen()));
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildMenuCard(
                      context: context,
                      title: 'Numbers 1 to 10',
                      subtitle: 'Learn numbers & count items 🔢',
                      emoji: '🔢',
                      colors: [const Color(0xFF26C6DA), const Color(0xFF00838F)],
                      onTap: () {
                        TtsService().speakText(context, 'Numbers 1 to 10');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const NumbersScreen()));
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildMenuCard(
                      context: context,
                      title: 'Sticker Album',
                      subtitle: 'Unlock cute reward stickers 🖼️',
                      emoji: '🖼️',
                      colors: [const Color(0xFFFFCA28), const Color(0xFFFF8F00)],
                      onTap: () {
                        TtsService().speakText(context, 'Sticker Album');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const StickersScreen()));
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildMenuCard(
                      context: context,
                      title: 'Auto Flashcards',
                      subtitle: 'Hands-free automatic slideshow 🎬',
                      emoji: '🎬',
                      colors: [const Color(0xFFEC407A), const Color(0xFFC2185B)],
                      onTap: () {
                        TtsService().speakText(context, 'Auto Flashcards');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardsScreen()));
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Quick Letter Jump Strip
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
                    child: Row(
                      children: const [
                        Text('🚀 ', style: TextStyle(fontSize: 16)),
                        Text(
                          'Quick Letter Jump',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF455A64),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: AbcData.letters.length,
                      itemBuilder: (context, index) {
                        final letter = AbcData.letters[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          child: InkWell(
                            onTap: () {
                              TtsService().speakLetter(context, letter.capital);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LetterDetailScreen(initialIndex: index),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 58,
                              decoration: BoxDecoration(
                                color: letter.color,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    letter.capital,
                                    style: GoogleFonts.fredoka(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    letter.mainEmoji,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String emoji,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.fredoka(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
