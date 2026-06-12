import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

enum StoreType { android, ios, web }

class StoreButton extends StatefulWidget {
  final StoreType type;
  final bool large;

  const StoreButton({super.key, required this.type, this.large = false});

  @override
  State<StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<StoreButton> {
  bool _hover = false;

  String get _url {
    switch (widget.type) {
      case StoreType.android:
        return QAConstants.playStoreUrl;
      case StoreType.ios:
        return QAConstants.appStoreUrl;
      case StoreType.web:
        return QAConstants.webAppUrl;
    }
  }

  Icon get _emoji {
    switch (widget.type) {
      case StoreType.android:
        return const Icon(Icons.android,size: 35,);
      case StoreType.ios:
        return const Icon(Icons.apple,size: 35);
      case StoreType.web:
        return const Icon(Icons.language,size: 35);
    }
  }

  String get _topLabel {
    switch (widget.type) {
      case StoreType.android:
        return 'GET IT ON';
      case StoreType.ios:
        return 'DOWNLOAD ON THE';
      case StoreType.web:
        return 'ACCESS ON';
    }
  }

  String get _bottomLabel {
    switch (widget.type) {
      case StoreType.android:
        return 'Google Play';
      case StoreType.ios:
        return 'App Store';
      case StoreType.web:
        return 'Web Browser';
    }
  }

  // Each platform gets a distinct colour treatment
  BoxDecoration get _decoration {
    final hover = _hover;
    switch (widget.type) {
      case StoreType.android:
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [QAColors.teal, QAColors.tealMid],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QAColors.tealGlow.withOpacity(0.4)),
          boxShadow: hover
              ? [
                  BoxShadow(
                      color: QAColors.tealGlow.withOpacity(0.25),
                      blurRadius: 24,
                      spreadRadius: 2)
                ]
              : [],
        );
      case StoreType.ios:
        return BoxDecoration(
          color: QAColors.gold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QAColors.gold.withOpacity(0.35)),
          boxShadow: hover
              ? [
                  BoxShadow(
                      color: QAColors.gold.withOpacity(0.2),
                      blurRadius: 24,
                      spreadRadius: 2)
                ]
              : [],
        );
      case StoreType.web:
        return BoxDecoration(
          color: QAColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QAColors.tealGlow.withOpacity(0.25)),
          boxShadow: hover
              ? [
                  BoxShadow(
                      color: QAColors.tealGlow.withOpacity(0.15),
                      blurRadius: 24,
                      spreadRadius: 2)
                ]
              : [],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              content:  Center(
                  child: Text(
                    ('We are Coming Soon!!!').toString().toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
              )),
              behavior: SnackBarBehavior.floating,
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
          decoration: _decoration,
          transform: Matrix4.identity()..translate(0.0, _hover ? -3.0 : 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _emoji,
              SizedBox(width: large ? 14 : 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_topLabel,
                      style: QATextStyles.label(large ? 10 : 9,
                          color: QAColors.textMuted)),
                  Text(_bottomLabel,
                      style: QATextStyles.label(large ? 18 : 15,
                          color: QAColors.textMain)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
