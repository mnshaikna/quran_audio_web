import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.hPad(context);
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
                  eyebrow: 'EVERYTHING YOU NEED',
                  title: 'A complete Quran ',
                  italicPart: 'experience',
                ),
              ),
              const SizedBox(height: 60),
              _FeaturesGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final isTab = Responsive.isTablet(context);

    if (isMob) {
      return Column(
        children: QAConstants.features
            .asMap().entries
            .map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: RevealWidget(
                delay: Duration(milliseconds: e.key * 60),
                child: _FeatureCard(e.value, wide: false),
              ),
            ))
            .toList(),
      );
    }

    // Desktop/tablet: custom grid layout
    // First card is wide (spans 2 cols), rest are 3-column
    final cols = isTab ? 2 : 3;
    final rest  = QAConstants.features.skip(1).toList();

    return Column(
      children: [
        // Wide first card
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: RevealWidget(
            child: _FeatureCard(QAConstants.features.first, wide: true),
          ),
        ),
        const SizedBox(height: 2),
        // Grid for remaining
        _buildGrid(context, rest, cols),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List items, int cols) {
    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += cols) {
      final rowItems = items.skip(i).take(cols).toList();
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rowItems.asMap().entries.map((e) {
              final isLast = i + e.key == items.length - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: e.key < rowItems.length - 1 ? 2 : 0),
                  child: RevealWidget(
                    delay: Duration(milliseconds: (i + e.key) * 60),
                    child: ClipRRect(
                      borderRadius: isLast && items.length % cols != 0
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))
                          : BorderRadius.zero,
                      child: _FeatureCard(items[e.key + i], wide: false),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
      if (i + cols < items.length) rows.add(const SizedBox(height: 2));
    }

    // Wrap in a rounded border container
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        border: Border.all(color: QAColors.tealGlow.withOpacity(0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: rows),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final dynamic feature;
  final bool wide;
  const _FeatureCard(this.feature, {required this.wide});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        padding: EdgeInsets.all(isMob ? 28 : 40),
        decoration: BoxDecoration(
          color: _hover ? const Color(0xFF132828) : QAColors.bgCard,
          border: Border(
            top: BorderSide(
              color: _hover
                  ? QAColors.tealGlow.withOpacity(0.4)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: widget.wide ? _WideContent(widget.feature) : _NormalContent(widget.feature),
      ),
    );
  }
}

class _NormalContent extends StatelessWidget {
  final dynamic f;
  const _NormalContent(this.f);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        children: [
          Positioned(
            right: 0, top: 0,
            child: Text(f.arabic,
              style: QATextStyles.arabic(26, color: QAColors.gold.withOpacity(0.25)),
              textDirection: TextDirection.rtl,
            ),
          ),
          Text(f.emoji, style: const TextStyle(fontSize: 34)),
        ],
      ),
      const SizedBox(height: 18),
      Text(f.title, style: QATextStyles.display(22, color: QAColors.textMain)),
      const SizedBox(height: 10),
      Text(f.desc, style: QATextStyles.body(14)),
      const SizedBox(height: 16),
      FeatureTag(f.tag),
    ],
  );
}

class _WideContent extends StatelessWidget {
  final dynamic f;
  const _WideContent(this.f);

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return isMob
        ? _NormalContent(f)
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _NormalContent(f)),
              const SizedBox(width: 40),
              _MushafPreview(),
            ],
          );
  }
}

class _MushafPreview extends StatefulWidget {
  @override
  State<_MushafPreview> createState() => _MushafPreviewState();
}

class _MushafPreviewState extends State<_MushafPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _activeIdx = 1;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() => _activeIdx = (_activeIdx + 1) % 4);
              _ctrl.forward(from: 0);
            }
          });
        }
      });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lines = ['100%', '85%', '90%', '70%'];
    return Container(
      width: 220, height: 180,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [QAColors.teal, Color(0xFF1F5C52)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: QAColors.teal.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          // Arabic watermark
          Positioned(
            right: -8, bottom: -16,
            child: Text('قرآن',
              style: QATextStyles.arabic(64, color: Colors.white.withOpacity(0.04)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: lines.asMap().entries.map((e) {
              final isActive = e.key == _activeIdx;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isActive
                      ? QAColors.gold.withOpacity(0.65)
                      : Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
