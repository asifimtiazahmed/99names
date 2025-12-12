class NameOfAllah {
  final int number;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String explanation;
  final String benefit; // "Why learning this name is beneficial"
  final bool isUnlocked; // For gamification later

  const NameOfAllah({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.explanation,
    required this.benefit,
    this.isUnlocked = true, // Default unlocked for now
  });

  factory NameOfAllah.fromJson(Map<String, dynamic> json) {
    return NameOfAllah(
      number: json['number'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaning: json['meaning'] as String,
      explanation: json['explanation'] as String,
      benefit: json['benefit'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? true,
    );
  }
}
