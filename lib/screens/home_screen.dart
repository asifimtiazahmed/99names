import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/user_progress_service.dart';
import '../services/ad_service.dart';
import '../theme/app_theme.dart';
import 'learning_screen.dart'; 
import 'trivia_screen.dart';
import 'badges_screen.dart';

import '../widgets/responsive_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ... (BannerAd code unchanged)
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = AdService.createBannerAd()
      ..load().then((_) {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: SafeArea(
        child: ResponsiveWrapper(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              const SizedBox(height: 20),
              // Header
              Text(
                '99 Names\nof Allah',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.pastelBlue,
                  height: 1.2,
                ),
              ).animate().fadeIn().slideY(begin: -0.2, end: 0),
              
              const SizedBox(height: 10),
              Text(
                'Learn, Play & Earn Rewards',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn(delay: 200.ms),

              const Spacer(),

              // Gamification Status Card
              Consumer<UserProgressService>(
                builder: (context, progress, child) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(context, 'Level', '${progress.level}'),
                        _buildStatItem(context, 'XP', '${progress.xp}'),
                        _buildStatItem(context, 'Highscore', '${progress.highscore}'),
                      ],
                    ),
                  ).animate().scale(delay: 400.ms);
                },
              ),

              const Spacer(),

              // Action Buttons
              _buildMenuButton(
                context, 
                'Start Learning', 
                Icons.menu_book_rounded, 
                AppTheme.pastelBlue,
                () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LearningScreen()),
                  );
                },
              ).animate().slideX(begin: -1, delay: 600.ms),
              
              const SizedBox(height: 16),
              
              _buildMenuButton(
                context, 
                'Trivia Challenge', 
                Icons.quiz_rounded, 
                AppTheme.pastelPurple,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TriviaScreen()),
                  );
                },
              ).animate().slideX(begin: 1, delay: 700.ms),

              const SizedBox(height: 16),

              _buildMenuButton(
                context, 
                'My Collection', 
                Icons.stars_rounded, 
                AppTheme.pastelPink,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BadgesScreen()),
                  );
                },
              ).animate().slideX(begin: -1, delay: 800.ms),

              if (_isAdLoaded && _bannerAd != null) ...[
                 const Spacer(),
                 SizedBox(
                   width: _bannerAd!.size.width.toDouble(),
                   height: _bannerAd!.size.height.toDouble(),
                   child: AdWidget(ad: _bannerAd!),
                 ),
              ] else ...[
                 const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.pastelGreen,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildMenuButton(
    BuildContext context, 
    String label, 
    IconData icon, 
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}
