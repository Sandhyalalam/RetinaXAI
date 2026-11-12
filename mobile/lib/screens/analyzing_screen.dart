import 'package:flutter/material.dart';

import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class AnalyzingScreen extends StatelessWidget {
  const AnalyzingScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final scan = state.current;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        ScreenHeader(
          title: 'Analyzing Image',
          onBack: state.backFromFlow,
        ),
        AppCard(
          child: Column(
            children: [
              FundusView(bytes: scan?.originalBytes, size: 220),
              const SizedBox(height: 12),
              Text(
                '${scan?.fileName ?? 'fundus.png'} • 1024×1024',
                style: const TextStyle(color: RxColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: SizedBox(
            width: 78,
            height: 78,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              color: RxColors.tealDark,
              backgroundColor: RxColors.mint,
              value: state.analyzeStep == 0
                  ? 0.18
                  : state.analyzeStep == 1
                      ? 0.45
                      : state.analyzeStep == 2
                          ? 0.72
                          : 1,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          state.analyzeLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: RxColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Preprocessing → Prediction → Grad-CAM',
          textAlign: TextAlign.center,
          style: TextStyle(color: RxColors.muted),
        ),
        const SizedBox(height: 22),
        _Check(
          done: state.analyzeStep >= 1,
          label: 'Image quality checked',
          loading: state.analyzeStep == 0,
        ),
        _Check(
          done: state.analyzeStep >= 2,
          label: 'Resized & normalized',
          loading: state.analyzeStep == 1,
        ),
        _Check(
          done: state.analyzeStep >= 3,
          label: 'Generating heatmap',
          loading: state.analyzeStep >= 2 && state.analyzeStep < 3,
          hourglass: true,
        ),
      ],
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({
    required this.done,
    required this.label,
    required this.loading,
    this.hourglass = false,
  });

  final bool done;
  final bool loading;
  final bool hourglass;
  final String label;

  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (done) {
      leading = const Icon(Icons.check_circle, color: Color(0xFF2FA36B), size: 22);
    } else if (hourglass) {
      leading = const Text('⏳', style: TextStyle(fontSize: 18));
    } else {
      leading = const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 28, bottom: 10),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: done ? RxColors.navy : RxColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
