import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

// ── Static dummy prayer data (matches your app's design) ──────────────────────
const _prayerNames   = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
const _prayerArabic  = ['الفجر', 'الشروق', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
const _prayerTimes   = ['3:56 AM', '5:27 AM', '12:18 PM', '3:41 PM', '7:08 PM', '8:38 PM'];
const _nextIdx       = 2; // Dhuhr is "next"
const _nextName      = 'Dhuhr';
const _nextArabic    = 'الظهر';
const _suggest       = 'Recite Al-Kahf before Dhuhr';

// ── Section ────────────────────────────────────────────────────────────────────
class PrayerSection extends StatelessWidget {
  const PrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad  = Responsive.hPad(context);
    final isMob = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [QAColors.teal.withOpacity(0.06), Colors.transparent],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
          child: isMob
              ? Column(children: [
                  RevealWidget(child: _PrayerText()),
                  const SizedBox(height: 48),
                  const RevealWidget(child: _PrayerCard()),
                ])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: RevealWidget(child: _PrayerText())),
                    const SizedBox(width: 80),
                    const Expanded(child: RevealWidget(child: _PrayerCard())),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Left text column ───────────────────────────────────────────────────────────
class _PrayerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('NEVER MISS SALAH',
        style: QATextStyles.cinzel(11, color: QAColors.tealGlow)),
      const SizedBox(height: 14),
      RichText(
        text: TextSpan(
          style: QATextStyles.display(Responsive.clampFont(context, 28, 48)),
          children: [
            const TextSpan(text: 'Prayer times,\n'),
            TextSpan(
              text: 'always accurate',
              style: QATextStyles.display(
                Responsive.clampFont(context, 28, 48),
                color: QAColors.goldLight,
                style: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Text(
        'Precise prayer times calculated for your exact location. The app shows you the Hijri date, the next Salah, and how long you have — right on your dashboard.',
        style: QATextStyles.body(15),
      ),
      const SizedBox(height: 28),
      ...[
        'GPS-based calculation for any city in the world',
        'Hijri and Gregorian date displayed together',
        'Smart Salah notifications — contextual, never spammy',
        'Countdown timer to the next prayer always visible',
      ].map((text) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✦', style: TextStyle(color: QAColors.gold, fontSize: 16, height: 1.6)),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: QATextStyles.body(14))),
          ],
        ),
      )),
    ],
  );
}

// ── Prayer card — cloned from your mobile _PrayerTimeCard design ───────────────
class _PrayerCard extends StatefulWidget {
  const _PrayerCard();
  @override
  State<_PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<_PrayerCard> {
  late Timer _timer;
  String _countdown = '';

  // Simulate progress between Dhuhr (prev = Sunrise) and Asr
  // Hardcoded for demo: ~40% through the Dhuhr → Asr window
  final double _progress = 0.38;

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  void _updateCountdown() {
    // Count down to next occurrence of 12:18 PM
    final now    = DateTime.now();
    var   target = DateTime(now.year, now.month, now.day, 12, 18);
    if (now.isAfter(target)) target = target.add(const Duration(days: 1));
    final diff = target.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    if (mounted) setState(() => _countdown = h > 0 ? '${h}h ${m}m' : '${m}m');
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    // Navy card colours matching the mobile dark theme
    const cardBg  = Color(0xFF0E1B2E);
    const accentC = Color(0xFF7DC4F5); // sky blue
    const textC   = Colors.white;
    const subC    = Color(0xFF4FA3D1);
    const borderC = Color(0xFF1A3A5C);
    const rowBg   = Color(0x0AFFFFFF);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderC),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 12)),
          BoxShadow(color: const Color(0xFF7DC4F5).withOpacity(0.06), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          // ── Top section: next prayer + countdown ─────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: NEXT PRAYER label + location pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NEXT PRAYER',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        color: subC,
                      ),
                    ),
                    // Location pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderC),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5, height: 5,
                            decoration: const BoxDecoration(
                              color: accentC, shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text('Dubai',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: textC.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Prayer name + Arabic
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _nextName.toUpperCase(),
                      style: GoogleFonts.montserrat(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: textC,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _nextArabic,
                      style: const TextStyle(
                        fontSize: 16,
                        color: accentC,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Countdown
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _countdown.isEmpty ? '1h 31m' : _countdown,
                      style: GoogleFonts.montserrat(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: textC,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('away',
                      style: TextStyle(fontSize: 13, color: subC)),
                    const Spacer(),
                    // Sun/moon icon
                    Text('☀️', style: const TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 14),

                // Progress bar (Sunrise → Dhuhr)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 5,
                        backgroundColor: Colors.white.withOpacity(0.09),
                        valueColor: const AlwaysStoppedAnimation(accentC),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sunrise  5:27 AM',
                          style: TextStyle(fontSize: 10, color: subC.withOpacity(0.7))),
                        Text('Dhuhr  12:18 PM',
                          style: TextStyle(fontSize: 10, color: subC.withOpacity(0.7))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ── Prayer time row (all 6) ────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              border: Border(top: BorderSide(color: borderC)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_prayerNames.length, (i) {
                final isNext = i == _nextIdx;
                final isPast = i < _nextIdx;
                return _PrayerTimeCol(
                  name:   _prayerNames[i],
                  time:   _prayerTimes[i],
                  isNext: isNext,
                  isPast: isPast,
                  accent: accentC,
                );
              }),
            ),
          ),

          // ── Suggest row ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderC),
              ),
              child: Row(
                children: [
                  const Text('🕌', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('RECITE BEFORE DHUHR',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: subC.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text('Al-Kahf',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: accentC.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.play_arrow_rounded,
                      color: accentC, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerTimeCol extends StatelessWidget {
  final String name, time;
  final bool isNext, isPast;
  final Color accent;
  const _PrayerTimeCol({
    required this.name,
    required this.time,
    required this.isNext,
    required this.isPast,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(name,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
          color: isNext ? accent : Colors.white.withOpacity(isPast ? 0.3 : 0.55),
        ),
      ),
      const SizedBox(height: 5),
      // Dot indicator
      Container(
        width: 5, height: 5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isNext ? accent : Colors.white.withOpacity(isPast ? 0.2 : 0.35),
        ),
      ),
      const SizedBox(height: 5),
      Text(time,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isNext ? FontWeight.w800 : FontWeight.w500,
          color: isNext ? accent : Colors.white.withOpacity(isPast ? 0.3 : 0.55),
        ),
      ),
    ],
  );
}
