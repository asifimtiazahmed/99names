import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../data/names_data.dart';
import '../services/user_progress_service.dart';
import '../widgets/responsive_wrapper.dart';
import 'detail_screen.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn Names"),
        backgroundColor: AppTheme.creamBackground,
      ),
      backgroundColor: AppTheme.creamBackground,
      body: ResponsiveWrapper(
        child: Consumer<UserProgressService>(
          builder: (context, progress, child) {
            final unlockedCount = progress.unlockedNamesCount;
            
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: NamesData.names.length,
              itemBuilder: (context, index) {
                final name = NamesData.names[index];
                final isLocked = index >= unlockedCount;
                
                return Card(
                  color: isLocked ? Colors.grey[200] : null,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: isLocked ? Colors.grey : AppTheme.pastelBlue.withValues(alpha: 0.2),
                      child: isLocked 
                        ? const Icon(Icons.lock, color: Colors.white, size: 16)
                        : Text(
                          "${name.number}",
                          style: const TextStyle(
                            color: AppTheme.pastelBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                    title: Text(
                      isLocked ? "Locked" : name.transliteration,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18,
                        color: isLocked ? Colors.grey : null,
                      ),
                    ),
                    subtitle: isLocked 
                      ? Text("Reach Level ${ (index / 5).floor() + 1 } to unlock")
                      : Text(name.meaning),
                    trailing: isLocked 
                      ? null
                      : Hero(
                          tag: 'arabic_${name.number}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              name.arabic,
                              style: const TextStyle(
                                fontFamily: 'Amiri', // Or default if Arabic font not yet loaded specific
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    onTap: isLocked 
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text("Keep learning! Unlock this at Level ${(index / 5).floor() + 1}.")),
                          );
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailScreen(name: name)),
                          );
                        },
                  ),
                ).animate().slideX(delay: (50 * index).ms);
              },
            );
          },
        ),
      ),
    );
  }
}
