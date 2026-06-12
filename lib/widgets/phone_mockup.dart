import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PhoneMockup extends StatelessWidget {
  const PhoneMockup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Ambient glow behind the phone
          Positioned(
            left: -50,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    QAColors.tealGlow.withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Gold glow accent bottom-right
          Positioned(
            bottom: -30,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    QAColors.gold.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // The screenshot — it already has the phone frame baked in
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 60,
                  offset: const Offset(0, 30),
                ),
                BoxShadow(
                  color: QAColors.tealGlow.withOpacity(0.12),
                  blurRadius: 40,
                  spreadRadius: -5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(48),
              child: Image.asset(
                'assets/screens/screen_dashboard.png',
                width: 300,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  width: 300, height: 600,
                  decoration: BoxDecoration(
                    color: QAColors.bgCard,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  alignment: Alignment.center,
                  child: const Text('📱', style: TextStyle(fontSize: 60)),
                ),
              ),
            ),
          ),
          // Floating stat badge — top right
          const Positioned(
            right: -24,
            top: 80,
            child: _FloatingBadge(
              value: '114',
              label: 'Surahs',
              icon: '📖',
            ),
          ),
          // Floating stat badge — bottom left
          const Positioned(
            left: -24,
            bottom: 120,
            child: _FloatingBadge(
              value: '50+',
              label: 'Reciters',
              icon: '🎤',
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  final String value, label, icon;
  const _FloatingBadge({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: QAColors.bgCard,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: QAColors.gold.withOpacity(0.3)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: QATextStyles.cinzel(18, color: QAColors.goldLight)),
            Text(label, style: QATextStyles.label(9, color: QAColors.textMuted)),
          ],
        ),
      ],
    ),
  );
}
