import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/score_manager.dart';
import '../services/tts_service.dart';

enum TottyRoom { classroom, dining, stage }

enum TottyCostume { defaultFox, police, teacher, hero, chef }

// 👄 2D Cartoon Lip Sync Painter for Real Mouth Animation
class TottyMouthPainter extends CustomPainter {
  final int mouthState; // 0: closed, 1: half open, 2: wide open, 3: O shape
  final Color lipColor;

  TottyMouthPainter({
    required this.mouthState,
    this.lipColor = const Color(0xFFD81B60),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lipColor
      ..style = PaintingStyle.fill;

    final teethPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final tonguePaint = Paint()
      ..color = const Color(0xFFFF5252)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    if (mouthState == 0) {
      // Closed Smile Lip Line
      final smilePath = Path()
        ..moveTo(0, size.height * 0.4)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.9, size.width, size.height * 0.4)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.7, 0, size.height * 0.4);
      canvas.drawPath(smilePath, paint);
    } else if (mouthState == 1) {
      // Half Open Mouth (Teeth visible)
      final mouthRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: size.width * 0.85, height: size.height * 0.6),
        const Radius.circular(10),
      );
      canvas.drawRRect(mouthRect, paint);

      // Upper Teeth
      final teethRect = Rect.fromLTWH(size.width * 0.2, size.height * 0.2, size.width * 0.6, size.height * 0.2);
      canvas.drawRect(teethRect, teethPaint);
    } else if (mouthState == 2) {
      // Wide Open Talking Mouth (Teeth + Tongue)
      final mouthPath = Path()
        ..addOval(Rect.fromCenter(center: center, width: size.width * 0.9, height: size.height * 0.85));
      canvas.drawPath(mouthPath, paint);

      // Upper Teeth
      final teethPath = Path()
        ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.15, size.height * 0.1, size.width * 0.7, size.height * 0.25),
          const Radius.circular(6),
        ));
      canvas.drawPath(teethPath, teethPaint);

      // Tongue
      final tonguePath = Path()
        ..addArc(
          Rect.fromLTWH(size.width * 0.25, size.height * 0.5, size.width * 0.5, size.height * 0.45),
          0,
          pi,
        );
      canvas.drawPath(tonguePath, tonguePaint);
    } else {
      // O-Shape Talking Mouth
      final oMouth = Rect.fromCenter(center: center, width: size.width * 0.55, height: size.height * 0.75);
      canvas.drawOval(oMouth, paint);
      canvas.drawOval(
        Rect.fromCenter(center: center, width: size.width * 0.35, height: size.height * 0.5),
        tonguePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TottyMouthPainter oldDelegate) {
    return oldDelegate.mouthState != mouthState;
  }
}

class TalkingTottyScreen extends StatefulWidget {
  const TalkingTottyScreen({super.key});

  @override
  State<TalkingTottyScreen> createState() => _TalkingTottyScreenState();
}

class _TalkingTottyScreenState extends State<TalkingTottyScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;

  // 2D Motion Physics & Gesture Animation Controllers
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  late AnimationController _headNodController;
  late Animation<double> _headNodAnimation;

  late AnimationController _squishController;
  late Animation<double> _squishScaleAnimation;

  late AnimationController _danceController;
  late Animation<double> _danceRotationAnimation;

  // State Variables
  TottyRoom _currentRoom = TottyRoom.classroom;
  TottyCostume _currentCostume = TottyCostume.teacher;

  bool _isBlinking = false;
  int _mouthState = 0; // 0: closed, 1: half open, 2: wide open, 3: O shape
  bool _isSpeaking = false;
  bool _isDancing = false;
  Timer? _blinkTimer;
  Timer? _mouthLipSyncTimer;

  String _currentSpeech = 'أهلاً بيك! أنا توتي الكرتوني.. بتكلم وتحرك فمي وجسمي معاك بجد! 🦊✨';
  String _englishSubtext = 'I talk and move my mouth and body like a real cartoon!';
  String _chalkboardText = 'A  B  C';

  final List<String> _alphabetLetters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  int _letterIndex = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));

    // 1. Breathing Motion Physics
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0.98, end: 1.025).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    // 2. Head Nodding Gesture while Talking
    _headNodController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _headNodAnimation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: _headNodController, curve: Curves.easeInOut),
    );

    // 3. Touch Elastic Squish Physics
    _squishController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _squishScaleAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _squishController, curve: Curves.elasticOut),
    );

    // 4. Dance Wiggle Animation
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _danceRotationAnimation = Tween<double>(begin: -0.08, end: 0.08).animate(
      CurvedAnimation(parent: _danceController, curve: Curves.easeInOut),
    );

    // Automatic Eye Blinking System
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 3200), (timer) {
      if (mounted) {
        setState(() => _isBlinking = true);
        Future.delayed(const Duration(milliseconds: 160), () {
          if (mounted) setState(() => _isBlinking = false);
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakSpeech(_currentSpeech, _englishSubtext);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _breathingController.dispose();
    _headNodController.dispose();
    _squishController.dispose();
    _danceController.dispose();
    _blinkTimer?.cancel();
    _mouthLipSyncTimer?.cancel();
    super.dispose();
  }

  void _triggerSquish() {
    _squishController.forward().then((_) => _squishController.reverse());
  }

  // 👄 Dynamic Real Cartoon Lip Sync Engine
  void _startLipSyncAnimation() {
    _isSpeaking = true;
    _headNodController.repeat(reverse: true);
    _mouthLipSyncTimer?.cancel();

    final mouthSequence = [1, 2, 3, 1, 2, 0];
    int step = 0;

    _mouthLipSyncTimer = Timer.periodic(const Duration(milliseconds: 130), (timer) {
      if (!_isSpeaking && mounted) {
        timer.cancel();
        _headNodController.stop();
        _headNodController.reset();
        setState(() => _mouthState = 0);
      } else if (mounted) {
        setState(() {
          _mouthState = mouthSequence[step % mouthSequence.length];
          step++;
        });
      }
    });
  }

  void _stopLipSyncAnimation() {
    _isSpeaking = false;
    _mouthLipSyncTimer?.cancel();
    _headNodController.stop();
    _headNodController.reset();
    if (mounted) setState(() => _mouthState = 0);
  }

  Future<void> _speakSpeech(String arabicMsg, String englishMsg) async {
    setState(() {
      _currentSpeech = arabicMsg;
      _englishSubtext = englishMsg;
    });
    _triggerSquish();
    _startLipSyncAnimation();
    await TtsService().speakText(context, englishMsg);
    _stopLipSyncAnimation();
  }

  // Body Touch Responses
  void _onHeadTouch() {
    _speakSpeech('Head! يعني رأس 🧢! توتي بيحرك رأسه وبيكلمك!', 'Head! Touch your head!');
  }

  void _onBellyTouch() {
    _speakSpeech('Belly! يعني بطن 🍔! ههههه بتدغدغني أوي!', 'Belly! Hungry belly!');
  }

  void _onFeetTouch() {
    _speakSpeech('Feet! يعني قدمين 👟! نط وفرفش معايا!', 'Feet! Jump on your feet!');
  }

  // Classroom Action
  void _cycleChalkboardLetter() {
    setState(() {
      _letterIndex = (_letterIndex + 1) % _alphabetLetters.length;
      final letter = _alphabetLetters[_letterIndex];
      _chalkboardText = 'Letter $letter';
    });
    final letter = _alphabetLetters[_letterIndex];
    _speakSpeech(
      'حرف الـ $letter على السبورة! ممتاز يا بطل ✏️',
      'Letter $letter! $letter for Learning!',
    );
  }

  // Dining Food Action
  void _feedFood(String name, String arabicName, String letter, String phonics, String emoji) {
    _confettiController.play();
    ScoreManager().addStar();
    _speakSpeech(
      '$letter is for $name! $arabicName $emoji هم هم هم! طعمها لديد أوي!',
      '$letter is for $name! $phonics $name!',
    );
  }

  // Costume Change
  void _setCostume(TottyCostume costume, String costumeName, String costumePhrase) {
    setState(() {
      _currentCostume = costume;
    });
    _speakSpeech(
      'الله! توتي لابس زي $costumeName 👕✨!',
      'Totty is now wearing $costumePhrase!',
    );
  }

  // Dance Action
  void _startDance() {
    setState(() {
      _isDancing = true;
    });
    _danceController.repeat(reverse: true);
    _confettiController.play();

    _speakSpeech('Dance! يعني رقص 💃! يلا هيصة واحتفال مع توتي!', 'Let us dance!');

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _danceController.stop();
        _danceController.reset();
        setState(() => _isDancing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Talking Totty 🎤',
          style: GoogleFonts.fredoka(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Stars counter
          ValueListenableBuilder<int>(
            valueListenable: ScoreManager().starsNotifier,
            builder: (context, stars, child) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Text(
                      '$stars',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
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
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Main Full-Screen View
          Column(
            children: [
              // 1. Speech Banner Header
              _buildSpeechBanner(),

              // 2. Full-Body Character Room View
              Expanded(
                child: _buildCurrentRoomView(),
              ),

              // 3. Room Switcher Navigation Bar
              _buildRoomSelectorBar(),
            ],
          ),

          // Confetti Overlay
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.red, Colors.blue, Colors.amber, Colors.green, Colors.purple],
          ),
        ],
      ),
    );
  }

  // Speech Banner
  Widget _buildSpeechBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF8E24AA), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _currentSpeech,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF37474F),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _englishSubtext,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A1B9A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Room Router
  Widget _buildCurrentRoomView() {
    switch (_currentRoom) {
      case TottyRoom.classroom:
        return _buildClassroomRoom();
      case TottyRoom.dining:
        return _buildDiningRoom();
      case TottyRoom.stage:
        return _buildStageRoom();
    }
  }

  // 🏫 Room 1: Classroom
  Widget _buildClassroomRoom() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2), Color(0xFFD7CCC8)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Chalkboard
          Positioned(
            top: 10,
            child: InkWell(
              onTap: _cycleChalkboardLetter,
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF795548), width: 6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('🏫 ABC Chalkboard', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('Tap to write ✍️', style: TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _chalkboardText,
                      style: GoogleFonts.fredoka(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Full-Body Standing Character
          Positioned.fill(
            top: 90,
            bottom: 10,
            child: Center(
              child: _buildFullBodyTotty(),
            ),
          ),
        ],
      ),
    );
  }

  // 🍽️ Room 2: Kitchen Dining Table
  Widget _buildDiningRoom() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Full-Body Standing Character
          Positioned.fill(
            top: 10,
            bottom: 80,
            child: Center(
              child: _buildFullBodyTotty(),
            ),
          ),

          // Kitchen Dining Table with Plates
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF8D6E63),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: const Border(top: BorderSide(color: Color(0xFF5D4037), width: 4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFoodPlate('Watermelon', 'بطيخ', 'W', 'w w', '🍉', () {
                    _feedFood('Watermelon', 'بطيخ', 'W', 'w w', '🍉');
                  }),
                  _buildFoodPlate('Apple', 'تفاحة', 'A', 'a a', '🍎', () {
                    _feedFood('Apple', 'تفاحة', 'A', 'a a', '🍎');
                  }),
                  _buildFoodPlate('Pizza', 'بيتزا', 'P', 'p p', '🍕', () {
                    _feedFood('Pizza', 'بيتزا', 'P', 'p p', '🍕');
                  }),
                  _buildFoodPlate('Milk', 'حليب', 'M', 'm m', '🥛', () {
                    _feedFood('Milk', 'حليب', 'M', 'm m', '🥛');
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🎭 Room 3: Stage & Outfits
  Widget _buildStageRoom() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _isDancing
              ? [const Color(0xFFE91E63), const Color(0xFF9C27B0), const Color(0xFF3F51B5)]
              : [const Color(0xFFF3E5F5), const Color(0xFFCE93D8), const Color(0xFFAB47BC)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Costume Bar
          Positioned(
            top: 5,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCostumeChip('Police 👮', TottyCostume.police, 'ضابط شرطة', 'Police Costume'),
                  _buildCostumeChip('Teacher 🎓', TottyCostume.teacher, 'معلم', 'Teacher Costume'),
                  _buildCostumeChip('Hero 🦸', TottyCostume.hero, 'بطل خارق', 'Hero Costume'),
                  _buildCostumeChip('Chef 🧑‍🍳', TottyCostume.chef, 'طباخ', 'Chef Costume'),
                ],
              ),
            ),
          ),

          // Full-Body Standing Character
          Positioned.fill(
            top: 50,
            bottom: 60,
            child: Center(
              child: _buildFullBodyTotty(),
            ),
          ),

          // Dance Button
          Positioned(
            bottom: 10,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4081),
                foregroundColor: Colors.white,
                elevation: 6,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _startDance,
              icon: const Text('💃', style: TextStyle(fontSize: 20)),
              label: Text(
                'Dance Stage (ارقص مع توتي)',
                style: GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🦊 Real 2D Full-Body Animated Character Engine
  Widget _buildFullBodyTotty() {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathingController, _squishController, _danceController, _headNodController]),
      builder: (context, child) {
        final breathScale = _breathingAnimation.value;
        final squishScale = _squishScaleAnimation.value;
        final danceRotation = _isDancing ? _danceRotationAnimation.value : 0.0;
        final headNodRotation = _isSpeaking ? _headNodAnimation.value : 0.0;

        return Transform.rotate(
          angle: danceRotation + headNodRotation,
          child: Transform.scale(
            scale: breathScale * squishScale,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 380, maxWidth: 280),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Full Standing Body Image
                  Image.asset(
                    'assets/totty_full.jpg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/totty.jpg', fit: BoxFit.contain);
                    },
                  ),

                  // Costume Badge
                  _buildCostumeOverlay(),

                  // 2D Eye Blinking System 👁️
                  if (_isBlinking)
                    Positioned(
                      top: 65,
                      width: 140,
                      height: 25,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE65100),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text('—  —', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ),

                  // 👄 REAL 2D CARTOON LIP SYNC ANIMATED MOUTH PAINTER
                  Positioned(
                    top: 110,
                    width: 44,
                    height: 26,
                    child: CustomPaint(
                      painter: TottyMouthPainter(mouthState: _mouthState),
                    ),
                  ),

                  // Body Touch Zones
                  Positioned(
                    top: 0,
                    left: 20,
                    right: 20,
                    height: 110,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: _onHeadTouch,
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 8),
                        child: const Chip(
                          label: Text('Head 🧢 (المس الرأس)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.white70,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 115,
                    left: 30,
                    right: 30,
                    height: 120,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: _onBellyTouch,
                      child: Container(
                        alignment: Alignment.center,
                        child: const Chip(
                          label: Text('Belly 🍔 (المس البطن)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.white70,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 20,
                    right: 20,
                    height: 110,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: _onFeetTouch,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 8),
                        child: const Chip(
                          label: Text('Feet 👟 (المس الرجلين)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.white70,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Costume Badge
  Widget _buildCostumeOverlay() {
    String badge = '🎓';
    switch (_currentCostume) {
      case TottyCostume.police:
        badge = '👮';
        break;
      case TottyCostume.teacher:
        badge = '🎓';
        break;
      case TottyCostume.hero:
        badge = '🦸';
        break;
      case TottyCostume.chef:
        badge = '🧑‍🍳';
        break;
      default:
        badge = '🦊';
    }

    return Positioned(
      top: 10,
      right: 15,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 4),
          ],
        ),
        child: Text(badge, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  // Food Plate
  Widget _buildFoodPlate(String name, String arabicName, String letter, String phonics, String emoji, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 68,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF00ACC1), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 2),
            Text(
              name,
              style: GoogleFonts.fredoka(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF006064),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Costume Chip
  Widget _buildCostumeChip(String label, TottyCostume costume, String arabic, String english) {
    final isSelected = _currentCostume == costume;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      selected: isSelected,
      selectedColor: const Color(0xFFAB47BC),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: (selected) {
        if (selected) {
          _setCostume(costume, arabic, english);
        }
      },
    );
  }

  // Room Navigation Bar
  Widget _buildRoomSelectorBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRoomTabButton(TottyRoom.classroom, 'Classroom 🏫', 'الفصل'),
          _buildRoomTabButton(TottyRoom.dining, 'Kitchen 🍽️', 'السفرة'),
          _buildRoomTabButton(TottyRoom.stage, 'Stage 🎭', 'المسرح'),
        ],
      ),
    );
  }

  Widget _buildRoomTabButton(TottyRoom room, String label, String arabic) {
    final isSelected = _currentRoom == room;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF7B1FA2) : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : const Color(0xFF424242),
        elevation: isSelected ? 4 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () {
        setState(() => _currentRoom = room);
        _speakSpeech(
          'دخلنا غُرفة $arabic! يلا نلعب سوا 🌟',
          'Entering $label!',
        );
      },
      child: Text(
        label,
        style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
