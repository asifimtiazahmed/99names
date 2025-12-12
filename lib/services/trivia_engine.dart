import 'dart:math';
import '../data/names_data.dart';
import '../models/name_model.dart';

class TriviaQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  TriviaQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

class TriviaEngine {
  final Random _random = Random();

  TriviaQuestion generateQuestion(int unlockedCount) {
    // Determine available pool (clamped to at least 4 items so we have distractors)
    int count = max(unlockedCount, 4);
    if (count > NamesData.names.length) count = NamesData.names.length;
    
    final availableNames = NamesData.names.sublist(0, count);

    // Randomly choose question type
    // 0: Meaning
    // 1: Benefit (New)
    final questionType = _random.nextInt(2); 

    if (questionType == 1) {
      return _generateBenefitQuestion(availableNames);
    }
    
    return _generateMeaningQuestion(availableNames);
  }

  TriviaQuestion _generateMeaningQuestion(List<NameOfAllah> pool) {
    // Pick a random target name
    final targetName = pool[_random.nextInt(pool.length)];
    
    // Pick 3 distractors
    final distractors = <NameOfAllah>{};
    while (distractors.length < 3) {
      final d = pool[_random.nextInt(pool.length)];
      if (d.number != targetName.number) {
        distractors.add(d);
      }
    }
    
    final options = [targetName, ...distractors];
    options.shuffle(_random);
    
    final correctIndex = options.indexOf(targetName);
    
    return TriviaQuestion(
      questionText: "What is the meaning of ${targetName.transliteration} (${targetName.arabic})?",
      options: options.map((e) => e.meaning).toList(),
      correctOptionIndex: correctIndex,
      explanation: "${targetName.transliteration} means ${targetName.meaning}.",
    );
  }

  TriviaQuestion _generateBenefitQuestion(List<NameOfAllah> pool) {
    // Pick a random target name
    final targetName = pool[_random.nextInt(pool.length)];
    
    // Pick 3 distractors
    final distractors = <NameOfAllah>{};
    while (distractors.length < 3) {
      final d = pool[_random.nextInt(pool.length)];
      if (d.number != targetName.number) {
        distractors.add(d);
      }
    }
    
    final options = [targetName, ...distractors];
    options.shuffle(_random);
    
    final correctIndex = options.indexOf(targetName);
    
    return TriviaQuestion(
      questionText: "Which name's benefit is: \"${targetName.benefit}\"?",
      options: options.map((e) => e.transliteration).toList(),
      correctOptionIndex: correctIndex,
      explanation: "${targetName.transliteration} (${targetName.arabic}) - ${targetName.meaning}",
    );
  }
}
