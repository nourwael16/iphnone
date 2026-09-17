import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/abc_data.dart';
import '../services/tts_service.dart';
import '../services/totty_service.dart';
import '../widgets/totty_card.dart';

class DrawnPoint {
  final Offset point;
  final Paint paint;

  DrawnPoint({required this.point, required this.paint});
}

class LetterPainter extends CustomPainter {
  final List<List<DrawnPoint>> strokes;

  LetterPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(
          stroke[i].point,
          stroke[i + 1].point,
          stroke[i].paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant LetterPainter oldDelegate) => true;
}

class TracingScreen extends StatefulWidget {
  const TracingScreen({super.key});

  @override
  State<TracingScreen> createState() => _TracingScreenState();
}

class _TracingScreenState extends State<TracingScreen> {
  int _letterIndex = 0;
  final List<List<DrawnPoint>> _strokes = [];
  List<DrawnPoint> _currentStroke = [];
  Color _selectedColor = const Color(0xFFFF5252);
  double _strokeWidth = 14.0;
  late ConfettiController _confettiController;

  final List<Color> _brushColors = const [
    Color(0xFFFF5252), // Red
    Color(0xFFFF9800), // Orange
    Color(0xFFFFD54F), // Yellow
    Color(0xFF4CAF50), // Green
    Color(0xFF0288D1), // Blue
    Color(0xFF9C27B0), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakCurrent();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _speakCurrent() {
    final letter = AbcData.letters[_letterIndex];
    TtsService().speakText(context, 'Trace Letter ${letter.capital}');
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke = [];
    });
  }

  void _onFinishTracing() {
    _confettiController.play();
    final letter = AbcData.letters[_letterIndex];
    TtsService().speakText(context, 'Great job tracing letter ${letter.capital}!');
  }

  @override
  Widget build(BuildContext context) {
    final letter = AbcData.letters[_letterIndex];

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
          'Trace & Write ✏️',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_rounded, size: 28, color: Colors.white),
            onPressed: _clearCanvas,
            tooltip: 'Clear Canvas',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [letter.secondaryColor, Colors.white],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top Banner with Letter Sound Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trace: ${letter.capital} ${letter.small}',
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: letter.color,
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: letter.color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: _speakCurrent,
                          icon: const Text('🔊', style: TextStyle(fontSize: 18)),
                          label: Text(
                            'Listen',
                            style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Totty Mascot Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TottyCard(
                      message: TottyService.tracingPrompt,
                      englishAudioText: 'Trace letter ${letter.capital}',
                      themeColor: letter.color,
                    ),
                  ),

                  // Drawing Canvas with Guide Letter
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: letter.color, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: letter.color.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          children: [
                            // Background Letter Outline Guide
                            Center(
                              child: Text(
                                '${letter.capital} ${letter.small}',
                                style: GoogleFonts.fredoka(
                                  fontSize: 150,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ),

                            // Interactive Finger Paint Gesture Area
                            GestureDetector(
                              onPanStart: (details) {
                                setState(() {
                                  final paint = Paint()
                                    ..color = _selectedColor
                                    ..strokeCap = StrokeCap.round
                                    ..strokeWidth = _strokeWidth;
                                  _currentStroke = [DrawnPoint(point: details.localPosition, paint: paint)];
                                  _strokes.add(_currentStroke);
                                });
                              },
                              onPanUpdate: (details) {
                                setState(() {
                                  final paint = Paint()
                                    ..color = _selectedColor
                                    ..strokeCap = StrokeCap.round
                                    ..strokeWidth = _strokeWidth;
                                  _currentStroke.add(DrawnPoint(point: details.localPosition, paint: paint));
                                });
                              },
                              onPanEnd: (details) {
                                if (_strokes.isNotEmpty && _strokes.last.length > 10) {
                                  _onFinishTracing();
                                }
                              },
                              child: CustomPaint(
                                painter: LetterPainter(strokes: _strokes),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Color Picker Brushes Palette
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ..._brushColors.map((color) {
                          final isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isSelected ? 48 : 38,
                              height: isSelected ? 48 : 38,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.black : Colors.white,
                                  width: isSelected ? 3 : 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        // Clear Button Icon
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 32),
                          onPressed: _clearCanvas,
                          tooltip: 'Clear Canvas',
                        ),
                      ],
                    ),
                  ),

                  // Bottom Navigation Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _letterIndex == 0 ? Colors.grey : letter.color,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _letterIndex == 0
                              ? null
                              : () {
                                  setState(() {
                                    _letterIndex--;
                                    _clearCanvas();
                                  });
                                  _speakCurrent();
                                },
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: Text('Previous', style: GoogleFonts.fredoka()),
                        ),
                        Text(
                          '${_letterIndex + 1} / ${AbcData.letters.length}',
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: letter.color,
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _letterIndex == AbcData.letters.length - 1 ? Colors.grey : letter.color,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _letterIndex == AbcData.letters.length - 1
                              ? null
                              : () {
                                  setState(() {
                                    _letterIndex++;
                                    _clearCanvas();
                                  });
                                  _speakCurrent();
                                },
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text('Next', style: GoogleFonts.fredoka()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti Animation Overlay
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
