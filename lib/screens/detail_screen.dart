import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/name_model.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_wrapper.dart';

class DetailScreen extends StatefulWidget {
  final NameOfAllah name;

  const DetailScreen({super.key, required this.name});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("ar"); // Arabic for the Name
    // android might need specific engine setup, but default often works.
  }

  Future<void> _speak() async {
    await flutterTts.speak(widget.name.arabic);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Name #${widget.name.number}"),
        backgroundColor: AppTheme.creamBackground,
      ),
      backgroundColor: AppTheme.creamBackground,
      body: SingleChildScrollView(
        child: ResponsiveWrapper(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Big Arabic Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: AppTheme.pastelBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppTheme.pastelBlue.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                       GestureDetector(
                         onTap: _speak,
                         child: Icon(
                           Icons.volume_up_rounded, 
                           size: 40, 
                           color: AppTheme.pastelBlue,
                         ).animate().shimmer(delay: 1.seconds, duration: 1.seconds),
                       ),
                       const SizedBox(height: 10),
                       Hero(
                         tag: 'arabic_${widget.name.number}',
                         child: Material(
                           color: Colors.transparent,
                           child: Text(
                            widget.name.arabic,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              // fontFamily: 'Amiri', // Add font later
                            ),
                          ),
                         ),
                       ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
                
                Text(
                  widget.name.transliteration,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                ).animate().fadeIn(delay: 200.ms),
                  
                  const SizedBox(height: 5),
                  
                  Text(
                    widget.name.meaning,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.pastelBlue,
                    ),
                  ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 30),

            _buildInfoSection(context, "Explanation", widget.name.explanation, 0),
            _buildInfoSection(context, "Benefit", widget.name.benefit, 1),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Gamification reward
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Name Marked as Learned! (+10 XP)")),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Mark as Learned"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.pastelGreen,
                ),
              ),
            ).animate().slideY(begin: 1, delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            ),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (400 + (index * 100)).ms).slideX(begin: 0.1);
  }
}
