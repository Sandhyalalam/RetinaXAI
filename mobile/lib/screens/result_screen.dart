import 'package:flutter/material.dart';

import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final scan = state.current!;
    final pct = (scan.confidence * 100);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        ScreenHeader(title: 'Result', onBack: state.backFromFlow),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF12263F).withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 7,
                  decoration: const BoxDecoration(
                    color: RxColors.severe,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PREDICTED LEVEL',
                          style: TextStyle(
                            color: RxColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scan.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: RxColors.navy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDE4EE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Confidence ${pct.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  color: RxColors.severe,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Refer for clinical review',
                                style: TextStyle(
                                  color: RxColors.muted,
                                  fontSize: 12,
                                ),
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
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Original vs Grad-CAM',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: RxColors.navy,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: state.showExplain,
                          child: FundusView(
                            bytes: scan.originalBytes,
                            size: 120,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Original',
                            style: TextStyle(color: RxColors.muted)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: state.showExplain,
                          child: FundusView(
                            bytes: scan.heatmapBytes ?? scan.originalBytes,
                            heatmap: scan.heatmapBytes == null,
                            size: 120,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Heatmap',
                            style: TextStyle(color: RxColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Class Probabilities',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: RxColors.navy,
                ),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < 5; i++)
                _ProbRow(
                  index: i,
                  label: DrLevel.short[i],
                  value: scan.probabilities.length > i
                      ? scan.probabilities[i]
                      : 0,
                  highlight: i == scan.level,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinePillButton(
                label: 'Ask AI',
                icon: Icons.chat_bubble_outline,
                onTap: state.openChat,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TealButton(
                label: 'Consult Doctor',
                icon: Icons.health_and_safety_outlined,
                onTap: state.openDoctors,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const DisclaimerBanner(compact: true),
      ],
    );
  }
}

class _ProbRow extends StatelessWidget {
  const _ProbRow({
    required this.index,
    required this.label,
    required this.value,
    required this.highlight,
  });

  final int index;
  final String label;
  final double value;
  final bool highlight;

  static const colors = [
    Color(0xFF7BD389),
    Color(0xFF3CB371),
    Color(0xFFE8A317),
    Color(0xFFE11D5A),
    Color(0xFF7B61FF),
  ];

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(
              '$index – $label',
              style: TextStyle(
                fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                color: highlight ? RxColors.severe : RxColors.navy,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: value.clamp(0, 1),
                color: colors[index],
                backgroundColor: const Color(0xFFEEF2F6),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: Text(
              '$pct%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: highlight ? RxColors.severe : RxColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
