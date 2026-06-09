import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad  = Responsive.hPad(context);
    final isMob = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 52),
      decoration: const BoxDecoration(
        color: Color(0xFF040A09),
        border: Border(top: BorderSide(color: Color(0xFF1A3832))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
          child: isMob ? _MobileFooter() : _DesktopFooter(),
        ),
      ),
    );
  }
}

class _DesktopFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _FooterLogo(),
      const Spacer(),
      _FooterLinks(),
      const Spacer(),
      Text(
        '© 2026 ${QAConstants.appName}. Made with ♥ for the Ummah.',
        style: QATextStyles.body(12, color: QAColors.textFaint, height: 1),
      ),
    ],
  );
}

class _MobileFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _FooterLogo(),
      const SizedBox(height: 24),
      _FooterLinks(),
      const SizedBox(height: 24),
      Text(
        '© 2026 ${QAConstants.appName}.\nMade with ♥ for the Ummah.',
        style: QATextStyles.body(12, color: QAColors.textFaint),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

class _FooterLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/icons/app_icon.png',
              width: 28, height: 28,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                Text('قرآن', style: QATextStyles.arabic(16, color: QAColors.tealGlow)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            QAConstants.appName.toUpperCase(),
            style: QATextStyles.cinzel(14, color: QAColors.goldLight),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(QAConstants.tagline, style: QATextStyles.body(12, color: QAColors.textFaint, height: 1)),
    ],
  );
}

class _FooterLinks extends StatelessWidget {
  static const _links = ['Privacy Policy', 'Terms of Service', 'Contact', 'Support'];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 28,
    runSpacing: 12,
    alignment: WrapAlignment.center,
    children: _links.map((l) => _FooterLink(l)).toList(),
  );
}

class _FooterLink extends StatefulWidget {
  final String text;
  const _FooterLink(this.text);
  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hover = true),
    onExit:  (_) => setState(() => _hover = false),
    cursor: SystemMouseCursors.click,
    child: AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: QATextStyles.body(
        13,
        color: _hover ? QAColors.textMuted : QAColors.textFaint,
        height: 1,
      ),
      child: Text(widget.text),
    ),
  );
}
