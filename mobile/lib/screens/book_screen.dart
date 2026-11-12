import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final draft = state.booking!;
    final dates = List.generate(5, (i) => DateTime(2026, 11, 13 + i));
    const slots = ['10:00', '10:30', '11:00', '12:00', '4:00', '4:30'];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        ScreenHeader(title: 'Book Consultation', onBack: state.closeBooking),
        AppCard(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: RxColors.mint,
                child: Text('👩‍⚕️', style: TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: RxColors.navy,
                      ),
                    ),
                    Text(
                      '${draft.doctor.role} • ${draft.doctor.hospital}',
                      style: const TextStyle(color: RxColors.muted),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFF5C518), size: 16),
                        Text(
                          '  ${draft.doctor.rating}  •  ${draft.doctor.years} yrs experience',
                          style: const TextStyle(color: RxColors.muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Consultation type',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _TypeChip(
                label: 'Video',
                icon: Icons.videocam_outlined,
                selected: draft.video,
                onTap: () {
                  draft.video = true;
                  state.updateBooking(draft);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _TypeChip(
                label: 'In-clinic',
                icon: Icons.calendar_month_outlined,
                selected: !draft.video,
                onTap: () {
                  draft.video = false;
                  state.updateBooking(draft);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Select date • ${DateFormat('MMM yyyy').format(draft.date)}',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final date in dates)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () {
                      draft.date = date;
                      state.updateBooking(draft);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _sameDay(date, draft.date)
                            ? RxColors.tealDark
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _sameDay(date, draft.date)
                              ? RxColors.tealDark
                              : RxColors.line,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('E').format(date),
                            style: TextStyle(
                              fontSize: 11,
                              color: _sameDay(date, draft.date)
                                  ? Colors.white70
                                  : RxColors.muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: _sameDay(date, draft.date)
                                  ? Colors.white
                                  : RxColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Available slots',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            for (final slot in slots)
              GestureDetector(
                onTap: () {
                  draft.slot = slot;
                  state.updateBooking(draft);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: draft.slot == slot ? RxColors.tealDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: draft.slot == slot ? RxColors.tealDark : RxColors.line,
                    ),
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: draft.slot == slot ? Colors.white : RxColors.navy,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Share RetinaXAI report',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      state.current == null
                          ? 'No scan attached'
                          : 'Level ${state.current!.level} result + Grad-CAM heatmap',
                      style: const TextStyle(color: RxColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Switch(
                value: draft.shareReport,
                activeColor: RxColors.tealDark,
                onChanged: (v) {
                  draft.shareReport = v;
                  state.updateBooking(draft);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TealButton(
          label: 'Confirm Appointment',
          onTap: () {
            state.confirmBooking();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Appointment booked with ${draft.doctor.name} on ${DateFormat('d MMM').format(draft.date)} at ${draft.slot}.',
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: selected ? RxGradients.teal : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? Colors.transparent : RxColors.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : RxColors.navy, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : RxColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
