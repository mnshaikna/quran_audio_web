import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../widgets/common_widgets.dart';

class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.hPad(context);
    final isMob = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 36),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: QAColors.tealGlow.withOpacity(0.1)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxWidth(context)),
          child: RevealWidget(
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              runSpacing: 28,
              spacing: 16,
              children: [
                for (int i = 0; i < QAConstants.stats.length; i++) ...[
                  if (i > 0 && !isMob)
                    Container(
                      width: 1, height: 60,
                      color: QAColors.tealGlow.withOpacity(0.18),
                    ),
                  _StatItem(QAConstants.stats[i]),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final dynamic stat;
  const _StatItem(this.stat);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 140,
    child: Column(
      children: [
        Text(stat.value,
          style: QATextStyles.display(
            Responsive.clampFont(context, 36, 48),
            color: QAColors.goldLight,
          ),
        ),
        const SizedBox(height: 6),
        Text(stat.label.toUpperCase(),
          style: QATextStyles.label(11, color: QAColors.textFaint),
        ),
      ],
    ),
  );
}
