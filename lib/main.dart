import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/landing_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const QuranAudioWebApp());
}

class QuranAudioWebApp extends StatelessWidget {
  const QuranAudioWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Audio: Free Quran MP3',
      debugShowCheckedModeBanner: false,
      theme: QATheme.theme,
      home: const LandingPage(),
      builder: (context, child) {
        // Ensure text scales don't get crazy on web
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaleFactor.clamp(0.9, 1.1),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
