import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/numbers_data.dart';
import '../services/tts_service.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakCurrentNumber();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _speakCurrentNumber() {
    final item = NumbersData.numbers[_currentIndex];
    TtsService().speakText(context, '${item.number}. ${item.word}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BCD4),
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home_rounded, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Numbers 1 to 10 🔢',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: NumbersData.numbers.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _speakCurrentNumber();
        },
        itemBuilder: (context, index) {
          final item = NumbersData.numbers[index];
          return _buildNumberPage(item);
        },
      ),
    );
  }

  Widget _buildNumberPage(NumberModel item) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [item.secondaryColor, Colors.white],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Large Digit & Word Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: item.color, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: item.color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${item.number}',
                      style: GoogleFonts.fredoka(
                        fontSize: 84,
                        fontWeight: FontWeight.bold,
                        color: item.color,
                      ),
                    ),
                    Text(
                      item.word,
                      style: GoogleFonts.fredoka(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF37474F),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      ),
                      onPressed: _speakCurrentNumber,
                      icon: const Text('🔊', style: TextStyle(fontSize: 22)),
                      label: Text(
                        'Listen Number ${item.number}',
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Counting Objects Title
              Row(
                children: [
                  const Text('✨ ', style: TextStyle(fontSize: 20)),
                  Text(
                    'Count the items (${item.number}):',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF37474F),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Items Grid
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: item.color.withOpacity(0.3), width: 2),
                  ),
                  child: GridView.builder(
                    itemCount: item.countItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          TtsService().speakText(context, '${i + 1}');
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: item.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: item.color.withOpacity(0.4), width: 2),
                          ),
                          child: Center(
                            child: Text(
                              item.countItems[i],
                              style: const TextStyle(fontSize: 44),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Navigation Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentIndex == 0 ? Colors.grey : item.color,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _currentIndex == 0
                        ? null
                        : () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text('Previous', style: GoogleFonts.fredoka()),
                  ),
                  Text(
                    '${_currentIndex + 1} / ${NumbersData.numbers.length}',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: item.color,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentIndex == NumbersData.numbers.length - 1 ? Colors.grey : item.color,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _currentIndex == NumbersData.numbers.length - 1
                        ? null
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text('Next', style: GoogleFonts.fredoka()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
