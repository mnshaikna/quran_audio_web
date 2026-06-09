import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

class PrayerSection extends StatelessWidget {
  const PrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.hPad(context);
    final isMob = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            QAColors.teal.withOpacity(0.06),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
          child: isMob
              ? Column(
                  children: [
                    RevealWidget(child: _PrayerText()),
                    const SizedBox(height: 48),
                    RevealWidget(child: const _PrayerCard()),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: RevealWidget(child: _PrayerText())),
                    const SizedBox(width: 80),
                    Expanded(child: RevealWidget(child: const _PrayerCard())),
                  ],
                ),
        ),
      ),
    );
  }
}

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
              style:
                  QATextStyles.display(Responsive.clampFont(context, 28, 48)),
              children: const [
                TextSpan(text: 'Prayer times,\n'),
                TextSpan(
                    text: 'always ',
                    style: TextStyle(color: Colors.transparent)),
                TextSpan(
                    text: 'accurate',
                    style: TextStyle(
                        color: QAColors.goldLight,
                        fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Precise prayer times calculated for your exact location. The app shows you the Hijri date, the next Salah, and how long you have — right on your dashboard.',
            style: QATextStyles.body(15),
          ),
          const SizedBox(height: 28),
          ..._bullets(),
        ],
      );

  List<Widget> _bullets() {
    const items = [
      'GPS-based calculation for any city in the world',
      'Hijri and Gregorian date displayed together',
      'Smart Salah notifications — contextual, never spammy',
      'Countdown timer to the next prayer always visible',
    ];
    return items
        .map((text) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✦',
                      style: TextStyle(
                          color: QAColors.gold, fontSize: 16, height: 1.6)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(text, style: QATextStyles.body(14))),
                ],
              ),
            ))
        .toList();
  }
}

class _PrayerCard extends StatefulWidget {
  const _PrayerCard();

  @override
  State<_PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<_PrayerCard> {
  late Timer _timer;
  String _countdown = '00:00:00';

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void _update() {
    final now = DateTime.now();
    final target = DateTime(now.year, now.month, now.day, 12, 27);
    final next =
        now.isAfter(target) ? target.add(const Duration(days: 1)) : target;
    final diff = next.difference(now);
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    if (mounted) setState(() => _countdown = '$h:$m:$s');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: QAColors.bgCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: QAColors.tealGlow.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
                color: QAColors.teal.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10)),
          ],
        ),
        child: Stack(
          children: [
            // Arabic watermark
            Positioned(
              right: -10,
              bottom: -20,
              child: Text(
                'الصلاة',
                style: QATextStyles.arabic(88,
                    color: QAColors.gold.withOpacity(0.04)),
                textDirection: TextDirection.rtl,
              ),
            ),
            Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tuesday, 9 June 2026',
                              style: QATextStyles.body(12,
                                  color: QAColors.textFaint, height: 1)),
                        ]),
                    Text(
                      '١٣ ذو الحجة ١٤٤٧',
                      style: QATextStyles.arabic(16, color: QAColors.gold),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(height: 1, color: QAColors.tealGlow.withOpacity(0.1)),
                const SizedBox(height: 4),
                // Prayer rows
                ...QAConstants.prayers.map((p) => _PrayerRow(prayer: p)),
                const SizedBox(height: 4),
                Container(height: 1, color: QAColors.tealGlow.withOpacity(0.1)),
                const SizedBox(height: 20),
                // Countdown
                Column(children: [
                  Text('TIME UNTIL DHUHR',
                      style: QATextStyles.label(11, color: QAColors.textFaint)),
                  const SizedBox(height: 8),
                  Text(
                    _countdown,
                    style: QATextStyles.cinzel(32, color: QAColors.goldLight),
                  ),
                ]),
              ],
            ),
          ],
        ),
      );
}

class _PrayerRow extends StatelessWidget {
  final dynamic prayer;

  const _PrayerRow({required this.prayer});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
            vertical: 13, horizontal: prayer.isNext ? 0 : 0),
        decoration: BoxDecoration(
          color: prayer.isNext
              ? QAColors.gold.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                prayer.name,
                style: QATextStyles.label(
                  15,
                  color: prayer.isNext ? QAColors.goldLight : QAColors.textMain,
                ),
              ),
            ),
            if (prayer.isNext)
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: QAColors.gold.withOpacity(0.1),
                  border: Border.all(color: QAColors.gold.withOpacity(0.25)),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text('Next',
                    style: QATextStyles.label(9, color: QAColors.gold)),
              ),
            Text(
              prayer.time,
              style: QATextStyles.label(
                15,
                color: prayer.isNext ? QAColors.goldLight : QAColors.textMuted,
              ),
            ),
          ],
        ),
      );
}
