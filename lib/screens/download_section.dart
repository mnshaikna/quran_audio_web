import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';
import '../widgets/store_button.dart';

class DownloadSection extends StatelessWidget {
  const DownloadSection({super.key}); // key passed from LandingPage

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.hPad(context);
    final isMob = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 120),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            QAColors.teal.withOpacity(0.15),
            QAColors.gold.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            children: [
              // Arabic verse
              RevealWidget(
                child: Text(
                  QAConstants.downloadArabic,
                  style: QATextStyles.arabic(
                    isMob ? 28 : 42,
                    color: QAColors.gold.withOpacity(0.28),
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              RevealWidget(
                child: Column(children: [
                  Text(
                    QAConstants.downloadArabicTrans,
                    style: QATextStyles.body(14, color: QAColors.goldPale),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    QAConstants.downloadArabicRef,
                    style: QATextStyles.label(12, color: QAColors.goldPale),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
              const SizedBox(height: 40),
              // Title
              RevealWidget(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: QATextStyles.display(
                      Responsive.clampFont(context, isMob ? 36 : 42, 64),
                    ),
                    children: const [
                      TextSpan(text: 'Start your journey\nwith the '),
                      TextSpan(
                        text: 'Quran',
                        style: TextStyle(
                          color: QAColors.goldLight,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(text: ' today.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RevealWidget(
                child: Text(
                  'Free. No ads. No subscriptions.\nJust you and the Word of Allah.',
                  style: QATextStyles.body(16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),

              // ── 3 store buttons ──────────────────────────────────
              RevealWidget(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: const [
                    StoreButton(type: StoreType.android, large: true),
                    StoreButton(type: StoreType.ios, large: true),
                    StoreButton(type: StoreType.web, large: true),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // ── 3 QR codes ───────────────────────────────────────
              const RevealWidget(
                child: Wrap(
                  spacing: 40,
                  runSpacing: 32,
                  alignment: WrapAlignment.center,
                  children: [
                    _QrItem(
                        label: 'Android',
                        isPlaceholder: false,
                        assetPath: 'assets/qr/android.png'),
                    _QrItem(
                        label: 'iOS',
                        isPlaceholder: false,
                        assetPath: 'assets/qr/ios.png'),
                    _QrItem(
                        label: 'Web',
                        isPlaceholder: false,
                        assetPath: 'assets/qr/web.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrItem extends StatelessWidget {
  final String label;
  final bool isPlaceholder;
  final String? assetPath;

  const _QrItem({
    required this.label,
    required this.isPlaceholder,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isPlaceholder ? QAColors.bgCard : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isPlaceholder
                    ? QAColors.tealGlow.withOpacity(0.25)
                    : QAColors.gold.withOpacity(0.4),
                width: isPlaceholder ? 1 : 2,
              ),
              boxShadow: isPlaceholder
                  ? []
                  : [
                      BoxShadow(
                        color: QAColors.gold.withOpacity(0.15),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ],
            ),
            child: isPlaceholder
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('▦',
                          style: TextStyle(
                              fontSize: 28, color: QAColors.textFaint)),
                      Text(
                        'Coming soon',
                        style: QATextStyles.body(8,
                            color: QAColors.textFaint, height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      assetPath!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.qr_code_2_rounded,
                        color: QAColors.tealGlow,
                        size: 48,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            label.toUpperCase(),
            style: QATextStyles.label(
              11,
              color: isPlaceholder ? QAColors.textFaint : QAColors.goldLight,
            ),
          ),
        ],
      );
}
