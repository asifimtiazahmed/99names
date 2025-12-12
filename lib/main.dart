import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/user_progress_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProgressService()),
      ],
      child: const NinetyNineNamesApp(),
    ),
  );
}

class NinetyNineNamesApp extends StatelessWidget {
  const NinetyNineNamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '99 Names of Allah',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
