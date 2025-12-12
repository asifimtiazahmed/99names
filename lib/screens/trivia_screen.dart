import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../services/trivia_engine.dart';
import '../services/user_progress_service.dart';
import '../theme/app_theme.dart';
import '../services/ad_service.dart';
import '../widgets/responsive_wrapper.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  late TriviaEngine _engine;
  TriviaQuestion? _currentQuestion;
  int _score = 0;
  int _questionCount = 0;
  bool _isAnswered = false;
  int? _selectedOptionIndex;
  Timer? _timer;
  int _timeLeft = 15;
  static const int _maxQuestions = 5;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _engine = TriviaEngine();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    AdService.loadInterstitial(); // Preload ad
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_questionCount >= _maxQuestions) {
      _endGame();
      return;
    }

    final progressService = context.read<UserProgressService>();
    
    setState(() {
      _currentQuestion = _engine.generateQuestion(progressService.unlockedNamesCount);
      _questionCount++;
      _isAnswered = false;
      _selectedOptionIndex = null;
      _timeLeft = 15;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    // Treat as wrong answer
    _handleAnswer(-1); 
  }

  void _handleAnswer(int index) {
    if (_isAnswered) return;
    _timer?.cancel();
    setState(() {
      _isAnswered = true;
      _selectedOptionIndex = index;
    });
    
    if (index == _currentQuestion!.correctOptionIndex) {
      _score += 10 + _timeLeft; // Bonus for speed
      // Play sound?
    }
    
    // Auto advance after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _nextQuestion();
    });
  }

  void _endGame() {
    if (_score > 0) {
      _confettiController.play();
    }

    AdService.showInterstitial(onAdDismissed: () {
      if (!mounted) return;
      _showGameOverDialog();
    });
  }

  void _showGameOverDialog() {
    final progressService = context.read<UserProgressService>();
    progressService.addXp(_score);
    progressService.updateHighscore(_score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Score: $_score", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("XP Earned: $_score"),
            const SizedBox(height: 5),
            const Text("(Bonus Ad Credit applied!)", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close Dialog
              Navigator.pop(context); // Close Screen
            },
            child: const Text("Finish"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close Dialog
              setState(() {
                _score = 0;
                _questionCount = 0;
                _nextQuestion();
              });
            },
            child: const Text("Play Again"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text("Question $_questionCount/$_maxQuestions"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text("Score: $_score", style: const TextStyle(fontWeight: FontWeight.bold))),
          )
        ],
      ),
      backgroundColor: AppTheme.creamBackground,
      body: Stack(
        children: [
          ResponsiveWrapper(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: _timeLeft / 15,
                    color: _timeLeft < 5 ? Colors.red : AppTheme.pastelGreen,
                    backgroundColor: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 20),
                  
                  Text(
                    _currentQuestion!.questionText,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(),
                  
                  const SizedBox(height: 40),
        
                  ...List.generate(_currentQuestion!.options.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildOptionButton(index),
                    );
                  }),
        
                  if (_isAnswered)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.pastelBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.pastelBlue),
                      ),
                      child: Text(
                        _currentQuestion!.explanation,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ).animate().fadeIn(),
                ],
              ),
            ),
          ),
          
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false, 
              colors: const [AppTheme.pastelBlue, AppTheme.pastelGreen, AppTheme.pastelPink, AppTheme.pastelYellow],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black;
    
    if (_isAnswered) {
      if (index == _currentQuestion!.correctOptionIndex) {
        backgroundColor = AppTheme.pastelGreen;
        textColor = Colors.white;
      } else if (index == _selectedOptionIndex) {
        backgroundColor = AppTheme.pastelPink;
        textColor = Colors.white;
      }
    }

    return ElevatedButton(
      onPressed: _isAnswered ? null : () => _handleAnswer(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 20),
        elevation: 2,
        disabledBackgroundColor: backgroundColor, 
        disabledForegroundColor: textColor,
      ),
      child: Text(
        _currentQuestion!.options[index],
        style: const TextStyle(fontSize: 18),
      ),
    ).animate().slideX(delay: (100 * index).ms);
  }
}
