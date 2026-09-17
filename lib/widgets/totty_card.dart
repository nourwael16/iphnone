import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/totty_service.dart';

class TottyCard extends StatelessWidget {
  final String message;
  final String? englishAudioText;
  final Color themeColor;

  const TottyCard({
    super.key,
    required this.message,
    this.englishAudioText,
    this.themeColor = const Color(0xFF0288D1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: themeColor.withOpacity(0.4), width: 3),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Totty Avatar Image Box
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: themeColor, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/totty.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('🦊', style: TextStyle(fontSize: 36)));
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Speech Bubble Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'توتي (Totty)',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('✨', style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF37474F),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // Speaker Audio Button 🔊
          InkWell(
            onTap: () {
              TottyService().speakTottyMessage(context, message, englishText: englishAudioText);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: const Text('🔊', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
