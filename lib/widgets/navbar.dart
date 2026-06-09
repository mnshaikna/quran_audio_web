import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

class NavBar extends StatefulWidget {
  final ScrollController scrollController;
  const NavBar({super.key, required this.scrollController});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final s = widget.scrollController.offset > 60;
    if (s != _scrolled) setState(() => _scrolled = s);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final hPad  = Responsive.hPad(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: _scrolled ? 14 : 20,
      ),
      decoration: BoxDecoration(
        color: QAColors.bgDeep.withOpacity(_scrolled ? 0.92 : 0.7),
        border: Border(
          bottom: BorderSide(
            color: QAColors.tealGlow.withOpacity(_scrolled ? 0.15 : 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          _Logo(),
          const Spacer(),
          // Links (desktop only)
          if (!isMob) ...[
            _NavLink('Features',     '#features'),
            const SizedBox(width: 32),
            _NavLink('Reciters',     '#reciters'),
            const SizedBox(width: 32),
            _NavLink('Prayer Times', '#prayer'),
            const SizedBox(width: 40),
          ],
          // CTA button
          _CtaButton(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/icons/app_icon.png',
          width: 36, height: 36,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
            Text('قرآن', style: QATextStyles.arabic(18, color: QAColors.tealGlow)),
        ),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            QAConstants.appName.toUpperCase(),
            style: QATextStyles.cinzel(13, color: QAColors.goldLight, weight: FontWeight.w600),
          ),
          Text(
            QAConstants.appSubtitle.toUpperCase(),
            style: QATextStyles.cinzel(8, color: QAColors.tealGlow),
          ),
        ],
      ),
    ],
  );
}

class _NavLink extends StatefulWidget {
  final String label, anchor;
  const _NavLink(this.label, this.anchor);
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hover = true),
    onExit:  (_) => setState(() => _hover = false),
    cursor: SystemMouseCursors.click,
    child: AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: QATextStyles.label(
        13,
        color: _hover ? QAColors.goldLight : QAColors.textMuted,
      ),
      child: Text(widget.label),
    ),
  );
}

class _CtaButton extends StatefulWidget {
  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hover = true),
    onExit:  (_) => setState(() => _hover = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => launchUrl(Uri.parse(QAConstants.playStoreUrl)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [QAColors.gold, QAColors.goldLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: _hover
              ? [BoxShadow(color: QAColors.gold.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)]
              : [],
        ),
        transform: Matrix4.identity()..translate(0.0, _hover ? -2.0 : 0.0),
        child: Text(
          'Download Free',
          style: QATextStyles.label(13, color: QAColors.bgDeep),
        ),
      ),
    ),
  );
}
