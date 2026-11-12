import 'package:flutter/material.dart';

import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class ExplainScreen extends StatefulWidget {
  const ExplainScreen({super.key, required this.state});

  final AppState state;

  @override
  State<ExplainScreen> createState() => _ExplainScreenState();
}

class _ExplainScreenState extends State<ExplainScreen> {
  double opacity = 0.7;

  @override
  Widget build(BuildContext context) {
    final scan = widget.state.current!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        ScreenHeader(title: 'Explainable AI', onBack: widget.state.backFromFlow),
        AppCard(
          child: Column(
            children: [
              FundusView(
                bytes: scan.heatmapBytes ?? scan.originalBytes,
                heatmap: scan.heatmapBytes == null,
                opacity: opacity,
                size: 260,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Text(
                    'Heatmap opacity',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: RxColors.navy,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(opacity * 100).round()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: RxColors.muted,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: RxColors.tealDark,
                  thumbColor: RxColors.tealDark,
                  inactiveTrackColor: const Color(0xFFD9E2EA),
                ),
                child: Slider(
                  value: opacity,
                  onChanged: (v) => setState(() => opacity = v),
                ),
              ),
              Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2B6CB0),
                      Color(0xFF48BB78),
                      Color(0xFFECC94B),
                      Color(0xFFED8936),
                      Color(0xFFE53E3E),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text('Low influence',
                      style: TextStyle(color: RxColors.muted, fontSize: 12)),
                  Spacer(),
                  Text('High influence',
                      style: TextStyle(color: RxColors.muted, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What does this show?',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: RxColors.navy,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Red/yellow areas are the regions that most influenced the model’s prediction. Grad-CAM highlights influence — it does not prove a specific lesion.',
                style: TextStyle(color: RxColors.muted, height: 1.45),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TealButton(
                label: 'Save Report',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report saved privately on this device.'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinePillButton(
                label: 'New Scan',
                onTap: widget.state.newScan,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
