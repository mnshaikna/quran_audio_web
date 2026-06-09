import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import '../widgets/navbar.dart';
import '../screens/hero_section.dart';
import '../screens/stats_section.dart';
import '../screens/features_section.dart';
import '../screens/reciters_section.dart';
import '../screens/screenshots_section.dart';
import '../screens/prayer_section.dart';
import '../screens/download_section.dart';
import '../screens/footer_section.dart';
import '../theme/app_theme.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QAColors.bgDeep,
      body: Stack(
        children: [
          // Fixed geometric background
          const Positioned.fill(child: GeoBg()),

          // Fixed glow blobs
          Positioned(
            top: -200, left: -150,
            child: GlowBlob(color: QAColors.teal.withOpacity(0.32), size: 600),
          ),
          Positioned(
            top: 600, right: -200,
            child: GlowBlob(color: QAColors.gold.withOpacity(0.10), size: 500),
          ),
          Positioned(
            bottom: -200, left: 300,
            child: GlowBlob(color: QAColors.teal.withOpacity(0.18), size: 700),
          ),

          // Scrollable content
          SingleChildScrollView(
            controller: _scrollCtrl,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // Spacer for fixed navbar
                const SizedBox(height: 0),
                const HeroSection(),
                const QADivider(),
                const StatsBar(),
                const QADivider(),
                const FeaturesSection(),
                const QADivider(),
                const RecitersSection(),
                const QADivider(),
                const ScreenshotsSection(),
                const QADivider(),
                const PrayerSection(),
                const QADivider(),
                const DownloadSection(),
                const FooterSection(),
              ],
            ),
          ),

          // Fixed navbar overlay
          Positioned(
            top: 0, left: 0, right: 0,
            child: NavBar(scrollController: _scrollCtrl),
          ),
        ],
      ),
    );
  }
}
