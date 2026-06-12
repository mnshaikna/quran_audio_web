import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

enum StoreType { android, ios }

class StoreButton extends StatefulWidget {
  final StoreType type;
  final bool large;

  const StoreButton({super.key, required this.type, this.large = false});

  @override
  State<StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<StoreButton> {
  bool _hover = false;

  String get _url => widget.type == StoreType.android
      ? 'https://play.google.com/store/apps/details?id=com.appswella.quran_audio'
      : '';

  @override
  Widget build(BuildContext context) {
    final isAndroid = widget.type == StoreType.android;
    final large = widget.large;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (_url.trim().isNotEmpty) {
            final uri = Uri.parse(_url);
            if (await canLaunchUrl(uri)) launchUrl(uri);
          } else {
            final customSnackBar = SnackBar(
              content: const Text('COMING SOON on iOS'),
              behavior: SnackBarBehavior.floating,
              //backgroundColor: Colors.redAccent,
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              showCloseIcon: true,
            );

            ScaffoldMessenger.of(context).showSnackBar(customSnackBar);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(
            horizontal: large ? 32 : 22,
            vertical: large ? 18 : 13,
          ),
          decoration: BoxDecoration(
            gradient: isAndroid
                ? const LinearGradient(
                    colors: [QAColors.teal, QAColors.tealMid],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isAndroid ? null : QAColors.gold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isAndroid
                  ? QAColors.tealGlow.withOpacity(0.4)
                  : QAColors.gold.withOpacity(0.35),
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: (isAndroid ? QAColors.tealGlow : QAColors.gold)
                          .withOpacity(0.2),
                      blurRadius: 24,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          transform: Matrix4.identity()..translate(0.0, _hover ? -3.0 : 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isAndroid ? Icons.android_sharp : Icons.apple_sharp),
              SizedBox(width: large ? 14 : 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isAndroid ? 'GET IT ON' : 'DOWNLOAD ON THE',
                    style: QATextStyles.label(
                      large ? 10 : 9,
                      color: QAColors.textMuted,
                    ),
                  ),
                  Text(
                    isAndroid ? 'Google Play' : 'App Store',
                    style: QATextStyles.label(
                      large ? 18 : 15,
                      color: QAColors.textMain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
