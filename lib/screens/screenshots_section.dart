import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

class ScreenshotsSection extends StatelessWidget {
  const ScreenshotsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad  = Responsive.hPad(context);
    final isMob = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 100),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
          child: Column(
            children: [
              RevealWidget(
                child: SectionHeader(
                  eyebrow: 'SEE IT IN ACTION',
                  title: 'Beautifully ',
                  italicPart: 'crafted',
                ),
              ),
              const SizedBox(height: 64),
              isMob ? _MobileRow() : _DesktopRow(),
            ],
          ),
        ),
      ),
    );
  }
}

// Desktop: 5 screens in a staggered row
class _DesktopRow extends StatelessWidget {
  // vertical offsets to create a wave/stagger effect
  static const _offsets = [48.0, 0.0, 48.0, 16.0, 0.0];

  @override
  Widget build(BuildContext context) {
    final screens = QAConstants.screens;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(screens.length, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: _offsets[i],
              left: i > 0 ? 12 : 0,
              right: i < screens.length - 1 ? 12 : 0,
            ),
            child: RevealWidget(
              delay: Duration(milliseconds: i * 90),
              child: _ScreenCard(
                imagePath: screens[i].imagePath,
                label: screens[i].label,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// Mobile: horizontal scroll of 3 screens
class _MobileRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screens = QAConstants.screens.take(3).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(screens.length, (i) => Padding(
          padding: EdgeInsets.only(right: i < screens.length - 1 ? 16 : 0),
          child: _ScreenCard(
            imagePath: screens[i].imagePath,
            label: screens[i].label,
            width: 220,
          ),
        )),
      ),
    );
  }
}

class _ScreenCard extends StatefulWidget {
  final String imagePath;
  final String label;
  final double? width;

  const _ScreenCard({
    required this.imagePath,
    required this.label,
    this.width,
  });

  @override
  State<_ScreenCard> createState() => _ScreenCardState();
}

class _ScreenCardState extends State<_ScreenCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              ..translate(0.0, _hover ? -14.0 : 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_hover ? 0.6 : 0.35),
                  blurRadius: _hover ? 50 : 24,
                  offset: const Offset(0, 16),
                ),
                if (_hover)
                  BoxShadow(
                    color: QAColors.tealGlow.withOpacity(0.18),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _hover
                        ? QAColors.tealGlow.withOpacity(0.4)
                        : QAColors.tealGlow.withOpacity(0.15),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.label,
            style: QATextStyles.label(12, color: QAColors.textFaint),
          ),
        ],
      ),
    );
  }
}
