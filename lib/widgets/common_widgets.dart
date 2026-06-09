import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

// ── Geometric background painter ──────────────────────────────────────────────
class GeoBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = QAColors.tealGlow.withOpacity(0.045)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const tileSize = 120.0;
    final cols = (size.width  / tileSize).ceil() + 1;
    final rows = (size.height / tileSize).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final cx = col * tileSize + tileSize / 2;
        final cy = row * tileSize + tileSize / 2;
        _drawHex(canvas, paint, cx, cy, tileSize / 2 - 4);
        _drawHex(canvas, paint, cx, cy, tileSize / 2 - 18);
        _drawHex(canvas, paint, cx, cy, tileSize / 2 - 32);
        // Cross lines
        canvas.drawLine(Offset(cx, cy - tileSize / 2 + 4), Offset(cx, cy + tileSize / 2 - 4), paint);
        canvas.drawLine(Offset(cx - tileSize / 2 + 4, cy - tileSize / 4), Offset(cx + tileSize / 2 - 4, cy + tileSize / 4), paint);
        canvas.drawLine(Offset(cx - tileSize / 2 + 4, cy + tileSize / 4), Offset(cx + tileSize / 2 - 4, cy - tileSize / 4), paint);
      }
    }
  }

  void _drawHex(Canvas canvas, Paint paint, double cx, double cy, double r) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = math.pi / 180 * (60 * i - 30);
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class GeoBg extends StatelessWidget {
  const GeoBg({super.key});
  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: CustomPaint(painter: GeoBgPainter()),
  );
}

// ── Glow blob ─────────────────────────────────────────────────────────────────
class GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const GlowBlob({super.key, required this.color, this.size = 500});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, Colors.transparent]),
    ),
  );
}

// ── Reveal on scroll ──────────────────────────────────────────────────────────
class RevealWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const RevealWidget({super.key, required this.child, this.delay = Duration.zero});

  @override
  State<RevealWidget> createState() => _RevealWidgetState();
}

class _RevealWidgetState extends State<RevealWidget> {
  bool _visible = false;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: _key,
    onVisibilityChanged: (info) {
      if (info.visibleFraction > 0.1 && !_visible) {
        Future.delayed(widget.delay, () {
          if (mounted) setState(() => _visible = true);
        });
      }
    },
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 700),
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 700),
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    ),
  );
}

// ── Section header ────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String eyebrow, title;
  final String? italicPart;
  final bool center;
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.italicPart,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: QATextStyles.cinzel(11, color: QAColors.tealGlow)),
        const SizedBox(height: 14),
        RichText(
          textAlign: center ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: QATextStyles.display(
              Responsive.clampFont(context, isMob ? 28 : 32, 52),
            ),
            children: [
              TextSpan(text: title.replaceAll(italicPart ?? '', '')),
              if (italicPart != null)
                TextSpan(
                  text: italicPart,
                  style: QATextStyles.display(
                    Responsive.clampFont(context, isMob ? 28 : 32, 52),
                    color: QAColors.goldLight,
                    style: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Feature tag pill ──────────────────────────────────────────────────────────
class FeatureTag extends StatelessWidget {
  final String label;
  const FeatureTag(this.label, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: QAColors.tealGlow.withOpacity(0.1),
      border: Border.all(color: QAColors.tealGlow.withOpacity(0.25)),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(label, style: QATextStyles.label(10, color: QAColors.tealGlow)),
  );
}

// ── Divider line ──────────────────────────────────────────────────────────────
class QADivider extends StatelessWidget {
  const QADivider({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    color: QAColors.tealGlow.withOpacity(0.1),
  );
}

// ── Thin gold horizontal rule ─────────────────────────────────────────────────
class GoldRule extends StatelessWidget {
  final double width;
  const GoldRule({super.key, this.width = 60});
  @override
  Widget build(BuildContext context) => Container(
    width: width, height: 1,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.transparent, QAColors.gold, Colors.transparent],
      ),
    ),
  );
}

// ── Float animation wrapper ───────────────────────────────────────────────────
class FloatWidget extends StatelessWidget {
  final Widget child;
  const FloatWidget({super.key, required this.child});
  @override
  Widget build(BuildContext context) => child
    .animate(onPlay: (c) => c.repeat(reverse: true))
    .slideY(
      begin: 0, end: -0.03,
      duration: 3.seconds,
      curve: Curves.easeInOut,
    );
}
