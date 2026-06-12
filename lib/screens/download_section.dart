import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';
import '../widgets/store_button.dart';

class DownloadSection extends StatelessWidget {
  const DownloadSection({super.key});

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
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              // Faded Arabic verse
              RevealWidget(
                child: Text(
                  QAConstants.downloadArabic,
                  style: QATextStyles.arabic(isMob ? 28 : 42,
                      color: QAColors.gold.withOpacity(0.28)),
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
              // Store buttons
              const RevealWidget(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    StoreButton(type: StoreType.android, large: true),
                    StoreButton(type: StoreType.ios, large: true),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              //  placeholders
              const RevealWidget(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _QrItem('Android'),
                    SizedBox(width: 48),
                    _QrItem('iOS'),
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

  const _QrItem(this.label);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Image.asset(
            'assets/qr/${label.toLowerCase()}.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 8),
          Text(label.toUpperCase(),
              style: QATextStyles.label(11, color: QAColors.textFaint)),
        ],
      );
}
