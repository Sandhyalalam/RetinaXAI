import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    const filters = ['All', 'Level 0–1', 'Level 2', 'Level 3–4'];
    final items = state.filteredHistory;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const Text(
          'Scan History',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: RxColors.navy,
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < filters.length; i++) ...[
                ChoiceChip(
                  label: Text(filters[i]),
                  selected: state.historyFilter == i,
                  onSelected: (_) => state.setHistoryFilter(i),
                  selectedColor: RxColors.mint,
                  labelStyle: TextStyle(
                    color: state.historyFilter == i
                        ? RxColors.tealDark
                        : RxColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                  side: BorderSide(
                    color: state.historyFilter == i
                        ? const Color(0xFFB7E6DC)
                        : RxColors.line,
                  ),
                  backgroundColor: Colors.white,
                  showCheckmark: false,
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              'No scans yet. Upload a fundus image on Home to start.',
              style: TextStyle(color: RxColors.muted),
            ),
          )
        else
          for (final scan in items) ...[
            _HistoryTile(
              scan: scan,
              onTap: () => state.openResult(scan),
              onDelete: () => state.deleteScan(scan.id),
            ),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔒  '),
            Expanded(
              child: Text(
                'History is stored privately on your device. You can delete it anytime.',
                style: TextStyle(color: RxColors.muted, height: 1.4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.scan,
    required this.onTap,
    required this.onDelete,
  });

  final ScanResult scan;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy').format(scan.createdAt);
    final conf = (scan.confidence * 100).round();
    return Dismissible(
      key: ValueKey(scan.id),
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE4EE),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.delete_outline, color: RxColors.severe),
      ),
      child: AppCard(
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              FundusView(bytes: scan.originalBytes, size: 54),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: RxColors.navy,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$date • $conf% confidence',
                      style: const TextStyle(
                        color: RxColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              LevelBadge(level: scan.level),
            ],
          ),
        ),
      ),
    );
  }
}
