import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';

class NavBar extends StatefulWidget {
  final ScrollController scrollController;
  final void Function(String anchor) onNavTap;
  final String activeAnchor;

  const NavBar({
    super.key,
    required this.scrollController,
    required this.onNavTap,
    required this.activeAnchor,
  });

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
    final hPad = Responsive.hPad(context);

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
          _Logo(onTap: () => widget.onNavTap('hero')),
          const Spacer(),
          if (!isMob) ...[
            _NavLink(
                'Features', 'features', widget.onNavTap, widget.activeAnchor),
            const SizedBox(width: 32),
            _NavLink(
                'Reciters', 'reciters', widget.onNavTap, widget.activeAnchor),
            const SizedBox(width: 32),
            _NavLink('Screenshots', 'screenshots', widget.onNavTap,
                widget.activeAnchor),
            const SizedBox(width: 32),
            _NavLink(
                'Prayer Times', 'prayer', widget.onNavTap, widget.activeAnchor),
            const SizedBox(width: 40),
          ],
          _CtaButton(onTap: () => widget.onNavTap('download')),
        ],
      ),
    );
  }
}

// ── Logo — tapping scrolls back to top ────────────────────────────────────────
class _Logo extends StatefulWidget {
  final VoidCallback onTap;

  const _Logo({required this.onTap});

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _hover ? 0.8 : 1.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/icons/app_icon.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Text('قرآن',
                        style:
                            QATextStyles.arabic(18, color: QAColors.tealGlow)),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      QAConstants.appName.toUpperCase(),
                      style: QATextStyles.cinzel(13,
                          color: QAColors.goldLight, weight: FontWeight.w600),
                    ),
                    Text(
                      QAConstants.appSubtitle.toUpperCase(),
                      style: QATextStyles.cinzel(8, color: QAColors.tealGlow),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

// ── Nav link — fires onNavTap(anchor) on click ────────────────────────────────
class _NavLink extends StatefulWidget {
  final String label, anchor, activeAnchor;
  final void Function(String) onNavTap;

  const _NavLink(this.label, this.anchor, this.onNavTap, this.activeAnchor);

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.activeAnchor == widget.anchor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onNavTap(widget.anchor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: QATextStyles.label(
                13,
                color: isActive
                    ? QAColors.goldLight
                    : _hover
                        ? QAColors.textMain
                        : QAColors.textMuted,
              ),
              child: Text(widget.label),
            ),
            const SizedBox(height: 3),
            // Active underline indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 2,
              width: isActive ? 24 : 0,
              decoration: BoxDecoration(
                color: QAColors.gold,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── CTA button — scrolls to Download section ─────────────────────────────────
class _CtaButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CtaButton({required this.onTap});

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [QAColors.gold, QAColors.goldLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: _hover
                  ? [
                      BoxShadow(
                          color: QAColors.gold.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2)
                    ]
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
