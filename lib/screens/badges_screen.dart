import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/user_progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_wrapper.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Collection"),
        backgroundColor: AppTheme.creamBackground,
      ),
      backgroundColor: AppTheme.creamBackground,
      body: Consumer<UserProgressService>(
        builder: (context, progress, child) {
          final allBadges = UserProgressService.badgeDetails.keys.toList();
          
          return ResponsiveWrapper(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: allBadges.length,
              itemBuilder: (context, index) {
                final badgeId = allBadges[index];
                final isUnlocked = progress.unlockedBadges.contains(badgeId);
                final name = badgeId.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join(' ');
                final desc = UserProgressService.badgeDetails[badgeId];
                final icon = UserProgressService.badgeIcons[badgeId] ?? Icons.stars;

                return Card(
                  color: isUnlocked ? Colors.white : Colors.grey[200],
                  elevation: isUnlocked ? 4 : 0,
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon, 
                          size: 48, 
                          color: isUnlocked ? AppTheme.pastelPurple : Colors.grey[400],
                        ).animate(target: isUnlocked ? 1 : 0).scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut),
                        const SizedBox(height: 12),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isUnlocked ? Colors.black87 : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          desc ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: isUnlocked ? Colors.black54 : Colors.grey,
                          ),
                        ),
                        if (isUnlocked)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Icon(Icons.check_circle, color: AppTheme.pastelGreen, size: 20),
                          ).animate().fadeIn(delay: 500.ms),
                      ],
                    ),
                  ),
                ).animate().slideY(delay: (100 * index).ms);
              },
            ),
          );
        },
      ),
    );
  }
}
