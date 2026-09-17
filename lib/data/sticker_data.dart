class StickerModel {
  final String id;
  final String title;
  final String emoji;
  final int requiredStars;

  const StickerModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.requiredStars,
  });
}

class StickerData {
  static const List<StickerModel> stickers = [
    StickerModel(id: 's1', title: 'Puppy Hero', emoji: '🐶', requiredStars: 1),
    StickerModel(id: 's2', title: 'Cute Kitty', emoji: '🐱', requiredStars: 2),
    StickerModel(id: 's3', title: 'King Lion', emoji: '🦁', requiredStars: 4),
    StickerModel(id: 's4', title: 'Magical Unicorn', emoji: '🦄', requiredStars: 6),
    StickerModel(id: 's5', title: 'Space Rocket', emoji: '🚀', requiredStars: 8),
    StickerModel(id: 's6', title: 'Golden Crown', emoji: '👑', requiredStars: 10),
    StickerModel(id: 's7', title: 'Artist Palette', emoji: '🎨', requiredStars: 12),
    StickerModel(id: 's8', title: 'Surprise Gift', emoji: '🎁', requiredStars: 15),
    StickerModel(id: 's9', title: 'Champion Trophy', emoji: '🏆', requiredStars: 18),
    StickerModel(id: 's10', title: 'Party Balloons', emoji: '🎈', requiredStars: 20),
    StickerModel(id: 's11', title: 'Tasty Ice Cream', emoji: '🍦', requiredStars: 25),
    StickerModel(id: 's12', title: 'Super Star', emoji: '🌟', requiredStars: 30),
  ];
}
