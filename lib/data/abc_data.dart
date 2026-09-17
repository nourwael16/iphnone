import 'package:flutter/material.dart';

class WordModel {
  final String word;
  final String emoji;
  final String category;

  const WordModel({
    required this.word,
    required this.emoji,
    this.category = 'General',
  });
}

class LetterModel {
  final String capital;
  final String small;
  final String phonetic;
  final String mainEmoji;
  final Color color;
  final Color secondaryColor;
  final List<WordModel> words;

  const LetterModel({
    required this.capital,
    required this.small,
    required this.phonetic,
    required this.mainEmoji,
    required this.color,
    required this.secondaryColor,
    required this.words,
  });

  String get fullTitle => '$capital $small';
}

class AbcData {
  static const List<LetterModel> letters = [
    LetterModel(
      capital: 'A',
      small: 'a',
      phonetic: 'Letter A',
      mainEmoji: '🍎',
      color: Color(0xFFFF5252),
      secondaryColor: Color(0xFFFFEBEE),
      words: [
        WordModel(word: 'Apple', emoji: '🍎', category: 'Fruit'),
        WordModel(word: 'Ant', emoji: '🐜', category: 'Animal'),
        WordModel(word: 'Airplane', emoji: '✈️', category: 'Vehicle'),
      ],
    ),
    LetterModel(
      capital: 'B',
      small: 'b',
      phonetic: 'Letter B',
      mainEmoji: '⚽',
      color: Color(0xFFFF9800),
      secondaryColor: Color(0xFFFFF3E0),
      words: [
        WordModel(word: 'Ball', emoji: '⚽', category: 'Toy'),
        WordModel(word: 'Bee', emoji: '🐝', category: 'Animal'),
        WordModel(word: 'Bus', emoji: '🚌', category: 'Vehicle'),
      ],
    ),
    LetterModel(
      capital: 'C',
      small: 'c',
      phonetic: 'Letter C',
      mainEmoji: '🐱',
      color: Color(0xFFFFC107),
      secondaryColor: Color(0xFFFFFDE7),
      words: [
        WordModel(word: 'Cat', emoji: '🐱', category: 'Animal'),
        WordModel(word: 'Car', emoji: '🚗', category: 'Vehicle'),
        WordModel(word: 'Cake', emoji: '🍰', category: 'Food'),
      ],
    ),
    LetterModel(
      capital: 'D',
      small: 'd',
      phonetic: 'Letter D',
      mainEmoji: '🐶',
      color: Color(0xFF4CAF50),
      secondaryColor: Color(0xFFE8F5E9),
      words: [
        WordModel(word: 'Dog', emoji: '🐶', category: 'Animal'),
        WordModel(word: 'Duck', emoji: '🦆', category: 'Animal'),
        WordModel(word: 'Drum', emoji: '🥁', category: 'Music'),
      ],
    ),
    LetterModel(
      capital: 'E',
      small: 'e',
      phonetic: 'Letter E',
      mainEmoji: '🐘',
      color: Color(0xFF00BCD4),
      secondaryColor: Color(0xFFE0F7FA),
      words: [
        WordModel(word: 'Elephant', emoji: '🐘', category: 'Animal'),
        WordModel(word: 'Egg', emoji: '🥚', category: 'Food'),
        WordModel(word: 'Eagle', emoji: '🦅', category: 'Animal'),
      ],
    ),
    LetterModel(
      capital: 'F',
      small: 'f',
      phonetic: 'Letter F',
      mainEmoji: '🐟',
      color: Color(0xFF2196F3),
      secondaryColor: Color(0xFFE3F2FD),
      words: [
        WordModel(word: 'Fish', emoji: '🐟', category: 'Animal'),
        WordModel(word: 'Frog', emoji: '🐸', category: 'Animal'),
        WordModel(word: 'Flower', emoji: '🌸', category: 'Nature'),
      ],
    ),
    LetterModel(
      capital: 'G',
      small: 'g',
      phonetic: 'Letter G',
      mainEmoji: '🦒',
      color: Color(0xFF9C27B0),
      secondaryColor: Color(0xFFF3E5F5),
      words: [
        WordModel(word: 'Giraffe', emoji: '🦒', category: 'Animal'),
        WordModel(word: 'Grapes', emoji: '🍇', category: 'Fruit'),
        WordModel(word: 'Guitar', emoji: '🎸', category: 'Music'),
      ],
    ),
    LetterModel(
      capital: 'H',
      small: 'h',
      phonetic: 'Letter H',
      mainEmoji: '🐴',
      color: Color(0xFFE91E63),
      secondaryColor: Color(0xFFFCE4EC),
      words: [
        WordModel(word: 'Horse', emoji: '🐴', category: 'Animal'),
        WordModel(word: 'House', emoji: '🏠', category: 'Place'),
        WordModel(word: 'Hat', emoji: '🎩', category: 'Clothes'),
      ],
    ),
    LetterModel(
      capital: 'I',
      small: 'i',
      phonetic: 'Letter I',
      mainEmoji: '🍦',
      color: Color(0xFF009688),
      secondaryColor: Color(0xFFE0F2F1),
      words: [
        WordModel(word: 'Ice Cream', emoji: '🍦', category: 'Food'),
        WordModel(word: 'Iguana', emoji: '🦎', category: 'Animal'),
        WordModel(word: 'Island', emoji: '🏝️', category: 'Nature'),
      ],
    ),
    LetterModel(
      capital: 'J',
      small: 'j',
      phonetic: 'Letter J',
      mainEmoji: '🧃',
      color: Color(0xFF3F51B5),
      secondaryColor: Color(0xFFE8EAF6),
      words: [
        WordModel(word: 'Juice', emoji: '🧃', category: 'Drink'),
        WordModel(word: 'Jellyfish', emoji: '🪼', category: 'Animal'),
        WordModel(word: 'Jacket', emoji: '🧥', category: 'Clothes'),
      ],
    ),
    LetterModel(
      capital: 'K',
      small: 'k',
      phonetic: 'Letter K',
      mainEmoji: '🪁',
      color: Color(0xFFFF5722),
      secondaryColor: Color(0xFFFBE9E7),
      words: [
        WordModel(word: 'Kite', emoji: '🪁', category: 'Toy'),
        WordModel(word: 'Kangaroo', emoji: '🦘', category: 'Animal'),
        WordModel(word: 'Key', emoji: '🔑', category: 'Object'),
      ],
    ),
    LetterModel(
      capital: 'L',
      small: 'l',
      phonetic: 'Letter L',
      mainEmoji: '🦁',
      color: Color(0xFF8BC34A),
      secondaryColor: Color(0xFFF1F8E9),
      words: [
        WordModel(word: 'Lion', emoji: '🦁', category: 'Animal'),
        WordModel(word: 'Lemon', emoji: '🍋', category: 'Fruit'),
        WordModel(word: 'Leaf', emoji: '🍃', category: 'Nature'),
      ],
    ),
    LetterModel(
      capital: 'M',
      small: 'm',
      phonetic: 'Letter M',
      mainEmoji: '🐒',
      color: Color(0xFF795548),
      secondaryColor: Color(0xFFEFEBE9),
      words: [
        WordModel(word: 'Monkey', emoji: '🐒', category: 'Animal'),
        WordModel(word: 'Moon', emoji: '🌙', category: 'Space'),
        WordModel(word: 'Milk', emoji: '🥛', category: 'Drink'),
      ],
    ),
    LetterModel(
      capital: 'N',
      small: 'n',
      phonetic: 'Letter N',
      mainEmoji: '🪺',
      color: Color(0xFF673AB7),
      secondaryColor: Color(0xFFEDE7F6),
      words: [
        WordModel(word: 'Nest', emoji: '🪺', category: 'Nature'),
        WordModel(word: 'Nut', emoji: '🥜', category: 'Food'),
        WordModel(word: 'Needle', emoji: '🪡', category: 'Object'),
      ],
    ),
    LetterModel(
      capital: 'O',
      small: 'o',
      phonetic: 'Letter O',
      mainEmoji: '🦉',
      color: Color(0xFFFF9800),
      secondaryColor: Color(0xFFFFF3E0),
      words: [
        WordModel(word: 'Owl', emoji: '🦉', category: 'Animal'),
        WordModel(word: 'Orange', emoji: '🍊', category: 'Fruit'),
        WordModel(word: 'Octopus', emoji: '🐙', category: 'Animal'),
      ],
    ),
    LetterModel(
      capital: 'P',
      small: 'p',
      phonetic: 'Letter P',
      mainEmoji: '🐧',
      color: Color(0xFFEC407A),
      secondaryColor: Color(0xFFFCE4EC),
      words: [
        WordModel(word: 'Penguin', emoji: '🐧', category: 'Animal'),
        WordModel(word: 'Pizza', emoji: '🍕', category: 'Food'),
        WordModel(word: 'Panda', emoji: '🐼', category: 'Animal'),
      ],
    ),
    LetterModel(
      capital: 'Q',
      small: 'q',
      phonetic: 'Letter Q',
      mainEmoji: '👑',
      color: Color(0xFFAB47BC),
      secondaryColor: Color(0xFFF3E5F5),
      words: [
        WordModel(word: 'Queen', emoji: '👑', category: 'Person'),
        WordModel(word: 'Quack', emoji: '🦆', category: 'Sound'),
        WordModel(word: 'Quiet', emoji: '🤫', category: 'Action'),
      ],
    ),
    LetterModel(
      capital: 'R',
      small: 'r',
      phonetic: 'Letter R',
      mainEmoji: '🐰',
      color: Color(0xFF26A69A),
      secondaryColor: Color(0xFFE0F2F1),
      words: [
        WordModel(word: 'Rabbit', emoji: '🐰', category: 'Animal'),
        WordModel(word: 'Rain', emoji: '🌧️', category: 'Nature'),
        WordModel(word: 'Robot', emoji: '🤖', category: 'Toy'),
      ],
    ),
    LetterModel(
      capital: 'S',
      small: 's',
      phonetic: 'Letter S',
      mainEmoji: '☀️',
      color: Color(0xFFFFCA28),
      secondaryColor: Color(0xFFFFFDE7),
      words: [
        WordModel(word: 'Sun', emoji: '☀️', category: 'Space'),
        WordModel(word: 'Star', emoji: '🌟', category: 'Space'),
        WordModel(word: 'Snake', emoji: '🐍', category: 'Animal'),
      ],
    ),
    LetterModel(
      capital: 'T',
      small: 't',
      phonetic: 'Letter T',
      mainEmoji: '🐯',
      color: Color(0xFFFF7043),
      secondaryColor: Color(0xFFFBE9E7),
      words: [
        WordModel(word: 'Tiger', emoji: '🐯', category: 'Animal'),
        WordModel(word: 'Tree', emoji: '🌲', category: 'Nature'),
        WordModel(word: 'Train', emoji: '🚂', category: 'Vehicle'),
      ],
    ),
    LetterModel(
      capital: 'U',
      small: 'u',
      phonetic: 'Letter U',
      mainEmoji: '☂️',
      color: Color(0xFF5C6BC0),
      secondaryColor: Color(0xFFE8EAF6),
      words: [
        WordModel(word: 'Umbrella', emoji: '☂️', category: 'Object'),
        WordModel(word: 'Unicorn', emoji: '🦄', category: 'Fantasy'),
        WordModel(word: 'Up', emoji: '⬆️', category: 'Direction'),
      ],
    ),
    LetterModel(
      capital: 'V',
      small: 'v',
      phonetic: 'Letter V',
      mainEmoji: '🎻',
      color: Color(0xFF8D6E63),
      secondaryColor: Color(0xFFEFEBE9),
      words: [
        WordModel(word: 'Violin', emoji: '🎻', category: 'Music'),
        WordModel(word: 'Van', emoji: '🚐', category: 'Vehicle'),
        WordModel(word: 'Volcano', emoji: '🌋', category: 'Nature'),
      ],
    ),
    LetterModel(
      capital: 'W',
      small: 'w',
      phonetic: 'Letter W',
      mainEmoji: '🐋',
      color: Color(0xFF29B6F6),
      secondaryColor: Color(0xFFE1F5FE),
      words: [
        WordModel(word: 'Whale', emoji: '🐋', category: 'Animal'),
        WordModel(word: 'Watch', emoji: '⌚', category: 'Object'),
        WordModel(word: 'Watermelon', emoji: '🍉', category: 'Fruit'),
      ],
    ),
    LetterModel(
      capital: 'X',
      small: 'x',
      phonetic: 'Letter X',
      mainEmoji: '🎼',
      color: Color(0xFF26C6DA),
      secondaryColor: Color(0xFFE0F7FA),
      words: [
        WordModel(word: 'Xylophone', emoji: '🎼', category: 'Music'),
        WordModel(word: 'X-ray', emoji: '🦴', category: 'Science'),
        WordModel(word: 'X-ray Fish', emoji: '🐟', category: 'Animal'),
      ],
    ),
    LetterModel(
      capital: 'Y',
      small: 'y',
      phonetic: 'Letter Y',
      mainEmoji: '⛵',
      color: Color(0xFFD4E157),
      secondaryColor: Color(0xFFF9FBE7),
      words: [
        WordModel(word: 'Yacht', emoji: '⛵', category: 'Vehicle'),
        WordModel(word: 'Yo-yo', emoji: '🪀', category: 'Toy'),
        WordModel(word: 'Yak', emoji: '🐂', category: 'Animal'),
      ],
    ),
    LetterModel(
      capital: 'Z',
      small: 'z',
      phonetic: 'Letter Z',
      mainEmoji: '🦓',
      color: Color(0xFF78909C),
      secondaryColor: Color(0xFFECEFF1),
      words: [
        WordModel(word: 'Zebra', emoji: '🦓', category: 'Animal'),
        WordModel(word: 'Zipper', emoji: '🤐', category: 'Object'),
        WordModel(word: 'Zoo', emoji: '🏛️', category: 'Place'),
      ],
    ),
  ];
}
