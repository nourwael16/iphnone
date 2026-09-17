import 'package:flutter/material.dart';

class NumberModel {
  final int number;
  final String word;
  final String emoji;
  final Color color;
  final Color secondaryColor;
  final List<String> countItems;

  const NumberModel({
    required this.number,
    required this.word,
    required this.emoji,
    required this.color,
    required this.secondaryColor,
    required this.countItems,
  });
}

class NumbersData {
  static const List<NumberModel> numbers = [
    NumberModel(
      number: 1,
      word: 'One',
      emoji: '🍎',
      color: Color(0xFFFF5252),
      secondaryColor: Color(0xFFFFEBEE),
      countItems: ['🍎'],
    ),
    NumberModel(
      number: 2,
      word: 'Two',
      emoji: '⚽',
      color: Color(0xFFFF9800),
      secondaryColor: Color(0xFFFFF3E0),
      countItems: ['⚽', '⚽'],
    ),
    NumberModel(
      number: 3,
      word: 'Three',
      emoji: '🐱',
      color: Color(0xFFFFC107),
      secondaryColor: Color(0xFFFFFDE7),
      countItems: ['🐱', '🐱', '🐱'],
    ),
    NumberModel(
      number: 4,
      word: 'Four',
      emoji: '🐶',
      color: Color(0xFF4CAF50),
      secondaryColor: Color(0xFFE8F5E9),
      countItems: ['🐶', '🐶', '🐶', '🐶'],
    ),
    NumberModel(
      number: 5,
      word: 'Five',
      emoji: '🌟',
      color: Color(0xFF00BCD4),
      secondaryColor: Color(0xFFE0F7FA),
      countItems: ['🌟', '🌟', '🌟', '🌟', '🌟'],
    ),
    NumberModel(
      number: 6,
      word: 'Six',
      emoji: '🚗',
      color: Color(0xFF2196F3),
      secondaryColor: Color(0xFFE3F2FD),
      countItems: ['🚗', '🚗', '🚗', '🚗', '🚗', '🚗'],
    ),
    NumberModel(
      number: 7,
      word: 'Seven',
      emoji: '🌸',
      color: Color(0xFF9C27B0),
      secondaryColor: Color(0xFFF3E5F5),
      countItems: ['🌸', '🌸', '🌸', '🌸', '🌸', '🌸', '🌸'],
    ),
    NumberModel(
      number: 8,
      word: 'Eight',
      emoji: '🎈',
      color: Color(0xFFE91E63),
      secondaryColor: Color(0xFFFCE4EC),
      countItems: ['🎈', '🎈', '🎈', '🎈', '🎈', '🎈', '🎈', '🎈'],
    ),
    NumberModel(
      number: 9,
      word: 'Nine',
      emoji: '🍦',
      color: Color(0xFF009688),
      secondaryColor: Color(0xFFE0F2F1),
      countItems: ['🍦', '🍦', '🍦', '🍦', '🍦', '🍦', '🍦', '🍦', '🍦'],
    ),
    NumberModel(
      number: 10,
      word: 'Ten',
      emoji: '🚀',
      color: Color(0xFF3F51B5),
      secondaryColor: Color(0xFFE8EAF6),
      countItems: ['🚀', '🚀', '🚀', '🚀', '🚀', '🚀', '🚀', '🚀', '🚀', '🚀'],
    ),
  ];
}
