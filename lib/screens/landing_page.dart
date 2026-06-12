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

  final _keyFeatures = GlobalKey();
  final _keyReciters = GlobalKey();
  final _keyScreenshots = GlobalKey();
  final _keyPrayer = GlobalKey();
  final _keyDownload = GlobalKey();

  // Which nav anchor is currently active
  String _activeAnchor = '';

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Detect which section is in view ───────────────────────────────────────
  void _onScroll() {
    final offset = _scrollCtrl.offset;
    final navHeight = 80.0; // approximate navbar height

    // Build a map of anchor → top-of-section scroll offset
    final sections = {
      'features': _sectionOffset(_keyFeatures),
      'reciters': _sectionOffset(_keyReciters),
      'screenshots': _sectionOffset(_keyScreenshots),
      'prayer': _sectionOffset(_keyPrayer),
      'download': _sectionOffset(_keyDownload),
    };

    String active = '';

    // Walk in reverse so the topmost visible section wins
    for (final entry in sections.entries.toList().reversed) {
      final top = entry.value;
      if (top == null) continue;
      // Section is "active" when its top edge has scrolled past the navbar
      if (offset >= top - navHeight - 40) {
        active = entry.key;
        break;
      }
    }

    if (active != _activeAnchor) {
      setState(() => _activeAnchor = active);
    }
  }

  // Returns the accumulated scroll offset of a section's top edge
  double? _sectionOffset(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    // Position relative to the scroll view's top
    final pos = box.localToGlobal(Offset.zero);
    return _scrollCtrl.offset + pos.dy;
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QAColors.bgDeep,
      body: Stack(
        children: [
          const Positioned.fill(child: GeoBg()),
          Positioned(
              top: -200,
              left: -150,
              child:
                  GlowBlob(color: QAColors.teal.withOpacity(0.32), size: 600)),
          Positioned(
              top: 600,
              right: -200,
              child:
                  GlowBlob(color: QAColors.gold.withOpacity(0.10), size: 500)),
          Positioned(
              bottom: -200,
              left: 300,
              child:
                  GlowBlob(color: QAColors.teal.withOpacity(0.18), size: 700)),
          SingleChildScrollView(
            controller: _scrollCtrl,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const HeroSection(),
                const QADivider(),
                const StatsBar(),
                const QADivider(),
                FeaturesSection(key: _keyFeatures),
                const QADivider(),
                RecitersSection(key: _keyReciters),
                const QADivider(),
                ScreenshotsSection(key: _keyScreenshots),
                const QADivider(),
                PrayerSection(key: _keyPrayer),
                const QADivider(),
                DownloadSection(key: _keyDownload),
                const FooterSection(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              scrollController: _scrollCtrl,
              activeAnchor: _activeAnchor,
              onNavTap: (anchor) {
                switch (anchor) {
                  case 'features':
                    _scrollTo(_keyFeatures);
                    break;
                  case 'reciters':
                    _scrollTo(_keyReciters);
                    break;
                  case 'screenshots':
                    _scrollTo(_keyScreenshots);
                    break;
                  case 'prayer':
                    _scrollTo(_keyPrayer);
                    break;
                  case 'download':
                    _scrollTo(_keyDownload);
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
