import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

class RecitersSection extends StatelessWidget {
  const RecitersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.hPad(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 100, bottom: 100, left: hPad),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            QAColors.teal.withOpacity(0.07),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: hPad),
            child: RevealWidget(
              child: SectionHeader(
                eyebrow: 'CHOOSE YOUR VOICE',
                title: 'World\'s finest ',
                italicPart: 'Reciters',
                center: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(right: hPad),
            child: Text(
              '${QAConstants.qaris.length} renowned Qaris available in the app',
              style: QATextStyles.body(14, color: QAColors.textFaint),
            ),
          ),
          const SizedBox(height: 40),
          // Horizontal scroll row
          RevealWidget(
            child: SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: QAConstants.qaris.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 18),
                itemBuilder: (context, i) {
                  if (i == QAConstants.qaris.length) {
                    return SizedBox(width: Responsive.hPad(context));
                  }
                  return _QariCard(QAConstants.qaris[i]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QariCard extends StatefulWidget {
  final dynamic qari;
  const _QariCard(this.qari);
  @override
  State<_QariCard> createState() => _QariCardState();
}

class _QariCardState extends State<_QariCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: 158,
        transform: Matrix4.identity()..translate(0.0, _hover ? -8.0 : 0.0),
        decoration: BoxDecoration(
          color: _hover ? const Color(0xFF132828) : QAColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hover
                ? QAColors.tealGlow.withOpacity(0.45)
                : QAColors.tealGlow.withOpacity(0.12),
          ),
          boxShadow: _hover
              ? [BoxShadow(
                  color: QAColors.teal.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                )]
              : [],
        ),
        child: Column(
          children: [
            // Photo — fills top portion with rounded top corners
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
              child: SizedBox(
                height: 138,
                width: double.infinity,
                child: Image.asset(
                  widget.qari.imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => Container(
                    color: QAColors.teal,
                    alignment: Alignment.center,
                    child: Text(
                      widget.qari.name[0],
                      style: QATextStyles.display(32, color: QAColors.goldPale),
                    ),
                  ),
                ),
              ),
            ),
            // Name + info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.qari.name,
                      style: QATextStyles.label(12, color: QAColors.textMain),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: QAColors.gold.withOpacity(0.1),
                            border: Border.all(color: QAColors.gold.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            widget.qari.style,
                            style: QATextStyles.label(9, color: QAColors.gold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
