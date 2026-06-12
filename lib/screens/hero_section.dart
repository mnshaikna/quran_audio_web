import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/phone_mockup.dart';
import '../widgets/store_button.dart';
import '../widgets/common_widgets.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final hPad  = Responsive.hPad(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(hPad, isMob ? 100 : 130, hPad, isMob ? 80 : 100),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
          child: isMob ? _MobileHero() : _DesktopHero(),
        ),
      ),
    );
  }
}

class _DesktopHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(child: _HeroText()),
      const SizedBox(width: 80),
      FloatWidget(child: const PhoneMockup()),
    ],
  );
}

class _MobileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      FloatWidget(child: const PhoneMockup()),
      const SizedBox(height: 60),
      _HeroText(),
    ],
  );
}

class _HeroText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: isMob ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Eyebrow
        Text(
          'THE QURAN. IN YOUR POCKET.',
          style: QATextStyles.cinzel(11, color: QAColors.tealGlow),
        ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 20),
        // Arabic opening
        Text(
          QAConstants.heroArabic,
          style: QATextStyles.arabic(isMob ? 22 : 28, color: QAColors.goldPale),
          textDirection: TextDirection.rtl,
          textAlign: isMob ? TextAlign.center : TextAlign.right,
        ).animate().fadeIn(delay: 350.ms, duration: 800.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 18),
        // Main title
        RichText(
          textAlign: isMob ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: QATextStyles.display(
              Responsive.clampFont(context, isMob ? 48 : 56, 84),
            ),
            children: [
              const TextSpan(text: 'Listen.\n'),
              TextSpan(
                text: 'Learn.',
                style: QATextStyles.display(
                  Responsive.clampFont(context, isMob ? 48 : 56, 84),
                  color: QAColors.goldLight,
                  style: FontStyle.italic,
                ),
              ),
              const TextSpan(text: '\nReflect.'),
            ],
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 800.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 24),
        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            'Beautiful recitations from the world\'s finest Qaris, verse-by-verse Mushaf view, prayer times, and tools to deepen your connection with the Quran — all in one app. Free, forever.',
            style: QATextStyles.body(16),
            textAlign: isMob ? TextAlign.center : TextAlign.left,
          ),
        ).animate().fadeIn(delay: 650.ms, duration: 800.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 44),
        // Store buttons
        Wrap(
          spacing: 16, runSpacing: 12,
          alignment: isMob ? WrapAlignment.center : WrapAlignment.start,
          children: const [
            StoreButton(type: StoreType.android),
            StoreButton(type: StoreType.ios),
            StoreButton(type: StoreType.web),
          ],
        ).animate().fadeIn(delay: 800.ms, duration: 800.ms).slideY(begin: 0.3, end: 0),
      ],
    );
  }
}