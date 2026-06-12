import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

// ── Arabic names ───────────────────────────────────────────────────────────────
const _arabicNames = {
  'Fajr': 'الفجر',
  'Sunrise': 'الشروق',
  'Dhuhr': 'الظهر',
  'Asr': 'العصر',
  'Maghrib': 'المغرب',
  'Isha': 'العشاء',
};

// ── Data model ─────────────────────────────────────────────────────────────────
class _Prayer {
  final String name;
  final DateTime dt;
  bool isNext;
  bool isPast;

  _Prayer(
      {required this.name,
      required this.dt,
      this.isNext = false,
      this.isPast = false});

  String get arabic => _arabicNames[name] ?? '';

  String get time12 {
    final h = dt.hour, m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$h12:$m $period';
  }

  String get timeShort {
    final h = dt.hour, m = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$h12:$m $period';
  }
}

// ── Section ────────────────────────────────────────────────────────────────────
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

// ── Left text ──────────────────────────────────────────────────────────────────
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
          ].map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✦',
                        style: TextStyle(
                            color: QAColors.gold, fontSize: 16, height: 1.6)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(t, style: QATextStyles.body(14))),
                  ],
                ),
              )),
        ],
      );
}

// ── Live prayer card ───────────────────────────────────────────────────────────
class _PrayerCard extends StatefulWidget {
  const _PrayerCard();

  @override
  State<_PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<_PrayerCard> {
  List<_Prayer> _prayers = [];
  String _city = '';
  String _hijri = '';
  String _greg = '';
  String _countdown = '--:--';
  bool _loading = true;
  bool _error = false;
  Timer? _timer;

  static const _cardBg = Color(0xFF0E1B2E);
  static const _accent = Color(0xFF7DC4F5);
  static const _subC = Color(0xFF4FA3D1);
  static const _borderC = Color(0xFF1A3A5C);

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── 1. Ask browser for GPS ─────────────────────────────────────────────────
  void _requestLocation() {
    try {
      web.window.navigator.geolocation.getCurrentPosition(
        (web.GeolocationPosition pos) {
          final lat = pos.coords.latitude.toDouble();
          final lng = pos.coords.longitude.toDouble();
          _fetchTimes(lat, lng);
        }.toJS,
        (web.GeolocationPositionError _) {
          // GPS denied → fall back to IP geolocation
          _fetchByIp();
        }.toJS,
      );
    } catch (_) {
      _fetchByIp();
    }
  }

  // ── 2a. IP fallback ────────────────────────────────────────────────────────
  Future<void> _fetchByIp() async {
    try {
      final res = await http.get(Uri.parse('https://ipapi.co/json/'));
      if (res.statusCode == 200) {
        final d = json.decode(res.body);
        await _fetchTimes(
          (d['latitude'] as num).toDouble(),
          (d['longitude'] as num).toDouble(),
          cityOverride: d['city'] as String? ?? '',
        );
      } else {
        _setError();
      }
    } catch (_) {
      _setError();
    }
  }

  // ── 2b. AlAdhan API ────────────────────────────────────────────────────────
  Future<void> _fetchTimes(double lat, double lng,
      {String? cityOverride}) async {
    try {
      final now = DateTime.now();
      final url = Uri.parse(
        'https://api.aladhan.com/v1/timings'
        '/${now.day}-${now.month}-${now.year}'
        '?latitude=$lat&longitude=$lng&method=2',
      );

      final res = await http.get(url);
      if (res.statusCode != 200) {
        _setError();
        return;
      }

      final body = json.decode(res.body);
      final timings = body['data']['timings'] as Map<String, dynamic>;
      final dateData = body['data']['date'];

      // Dates
      final hijri = dateData['hijri'];
      final greg = dateData['gregorian'];
      final hijriStr =
          '${hijri['day']} ${hijri['month']['en']} ${hijri['year']} AH';
      final gregStr =
          '${greg['weekday']['en']}, ${greg['day']} ${greg['month']['en']} ${greg['year']}';

      // Reverse geocode for city name (best-effort)
      String city = cityOverride ?? '';
      if (city.isEmpty) {
        try {
          final geo = await http.get(Uri.parse(
            'https://nominatim.openstreetmap.org/reverse'
            '?lat=$lat&lon=$lng&format=json',
          ));
          if (geo.statusCode == 200) {
            final g = json.decode(geo.body);
            city = g['address']['city'] ??
                g['address']['town'] ??
                g['address']['state'] ??
                '';
          }
        } catch (_) {}
      }

      // Build prayer list
      const names = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
      final prayers = names.map((name) {
        final raw = (timings[name] as String).split(':');
        final dt = DateTime(
            now.year, now.month, now.day, int.parse(raw[0]), int.parse(raw[1]));
        return _Prayer(name: name, dt: dt);
      }).toList();

      _markStates(prayers);

      if (mounted) {
        setState(() {
          _prayers = prayers;
          _city = city;
          _hijri = hijriStr;
          _greg = gregStr;
          _loading = false;
          _error = false;
        });
        _startTimer();
      }
    } catch (_) {
      _setError();
    }
  }

  // ── Mark next / past ───────────────────────────────────────────────────────
  void _markStates(List<_Prayer> prayers) {
    final now = DateTime.now();
    int nextIdx = -1;

    // Find first prayer (excluding Sunrise) that hasn't passed yet
    for (int i = 0; i < prayers.length; i++) {
      if (prayers[i].name == 'Sunrise') continue;
      if (prayers[i].dt.isAfter(now)) {
        nextIdx = i;
        break;
      }
    }

    // All prayers passed today → next is Fajr (tomorrow)
    if (nextIdx == -1) nextIdx = 0;

    for (int i = 0; i < prayers.length; i++) {
      prayers[i].isNext = (i == nextIdx);
      prayers[i].isPast = prayers[i].dt.isBefore(now) && !prayers[i].isNext;
    }
  }

  // ── Countdown timer ────────────────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_prayers.isEmpty || !mounted) return;
    final next =
        _prayers.firstWhere((p) => p.isNext, orElse: () => _prayers.first);
    final now = DateTime.now();
    var target = next.dt;
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    final diff = target.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    final s = diff.inSeconds.remainder(60);
    setState(() => _countdown = h > 0
        ? '${h}h ${m.toString().padLeft(2, '0')}m'
        : '${m}m ${s.toString().padLeft(2, '0')}s');

    // Re-mark states each tick so "next" updates automatically at prayer time
    _markStates(_prayers);
  }

  void _setError() {
    if (mounted)
      setState(() {
        _loading = false;
        _error = true;
      });
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_loading) return _buildLoading();
    if (_error) return _buildError();
    return _buildCard();
  }

  Widget _buildLoading() => Container(
        height: 360,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _borderC),
        ),
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2, color: _accent)),
          const SizedBox(height: 16),
          Text('Fetching your prayer times…',
              style: TextStyle(fontSize: 13, color: _subC)),
          const SizedBox(height: 6),
          Text('Please allow location access',
              style: TextStyle(fontSize: 11, color: _subC.withOpacity(0.6))),
        ]),
      );

  Widget _buildError() => Container(
        height: 220,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _borderC),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🕌', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text('Could not fetch prayer times',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Allow location access and reload the page',
              style: TextStyle(fontSize: 12, color: _subC.withOpacity(0.7)),
              textAlign: TextAlign.center),
        ]),
      );

  Widget _buildCard() {
    final next =
        _prayers.firstWhere((p) => p.isNext, orElse: () => _prayers.first);

    // Progress: fraction through the window before next prayer
    final now = DateTime.now();
    final prev = _prayers.lastWhere((p) => p.dt.isBefore(now),
        orElse: () => _prayers.first);
    final windowTotal = next.dt.difference(prev.dt).inSeconds.toDouble();
    final windowDone = now.difference(prev.dt).inSeconds.toDouble();
    final progress =
        (windowTotal > 0 ? (windowDone / windowTotal).clamp(0.0, 1.0) : 0.0);

    // Time-of-day icon
    final hour = now.hour;
    final icon = hour >= 18 || hour < 5
        ? '🌙'
        : hour >= 5 && hour < 7
            ? '🌅'
            : '☀️';

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _borderC),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 12)),
          BoxShadow(
              color: _accent.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          // ── Top ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: label + location pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NEXT PRAYER',
                        style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                            color: _subC)),
                    if (_city.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _borderC),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                  color: _accent, shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Text(_city,
                              style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.7))),
                        ]),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Prayer name + Arabic
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(next.name.toUpperCase(),
                        style: GoogleFonts.montserrat(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1)),
                    const SizedBox(width: 8),
                    Text(next.arabic,
                        style: const TextStyle(
                            fontSize: 16,
                            color: _accent,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),

                // Countdown + icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(_countdown,
                        style: GoogleFonts.montserrat(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1)),
                    const SizedBox(width: 6),
                    Text('away', style: TextStyle(fontSize: 13, color: _subC)),
                    const Spacer(),
                    Text(icon, style: const TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 14),

                // Progress bar: prev prayer → next prayer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: Colors.white.withOpacity(0.09),
                        valueColor: const AlwaysStoppedAnimation(_accent),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${prev.name}  ${prev.timeShort}',
                            style: TextStyle(
                                fontSize: 10, color: _subC.withOpacity(0.7))),
                        Text('${next.name}  ${next.timeShort}',
                            style: TextStyle(
                                fontSize: 10, color: _subC.withOpacity(0.7))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ── All 6 prayer times row ───────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              border: Border(top: BorderSide(color: _borderC)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _prayers
                  .map((p) => _PrayerCol(prayer: p, accent: _accent))
                  .toList(),
            ),
          ),

          // ── Hijri date ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_greg,
                      style: TextStyle(
                          fontSize: 11, color: _subC.withOpacity(0.7))),
                  Text(_hijri,
                      style: const TextStyle(
                          fontSize: 11,
                          color: _accent,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerCol extends StatelessWidget {
  final _Prayer prayer;
  final Color accent;

  const _PrayerCol({required this.prayer, required this.accent});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(prayer.name,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: prayer.isNext ? FontWeight.w700 : FontWeight.w500,
                  color: prayer.isNext
                      ? accent
                      : Colors.white.withOpacity(prayer.isPast ? 0.3 : 0.55))),
          const SizedBox(height: 5),
          Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: prayer.isNext
                      ? accent
                      : Colors.white.withOpacity(prayer.isPast ? 0.2 : 0.35))),
          const SizedBox(height: 5),
          Text(prayer.timeShort,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: prayer.isNext ? FontWeight.w800 : FontWeight.w500,
                  color: prayer.isNext
                      ? accent
                      : Colors.white.withOpacity(prayer.isPast ? 0.3 : 0.55))),
        ],
      );
}
