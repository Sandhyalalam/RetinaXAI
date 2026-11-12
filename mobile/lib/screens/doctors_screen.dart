import 'package:flutter/material.dart';

import '../models.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key, required this.state});

  final AppState state;

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  String query = '';
  int chip = 0;

  @override
  Widget build(BuildContext context) {
    final chips = ['Retina Specialist', 'Near me', 'Online', 'Top rated'];
    final doctors = sampleDoctors.where((d) {
      final q = query.toLowerCase();
      final matchesQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.hospital.toLowerCase().contains(q) ||
          d.role.toLowerCase().contains(q);
      if (!matchesQuery) return false;
      if (chip == 0) return d.role.contains('Retina');
      if (chip == 2) return d.video;
      if (chip == 3) return d.rating >= 4.7;
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const Text(
          'Consult a Doctor',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: RxColors.navy,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          onChanged: (v) => setState(() => query = v),
          decoration: InputDecoration(
            hintText: 'Search ophthalmologists, hospitals...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: RxColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: RxColors.line),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < chips.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(chips[i]),
                    selected: chip == i,
                    onSelected: (_) => setState(() => chip = i),
                    selectedColor: RxColors.mint,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: chip == i ? RxColors.tealDark : RxColors.navy,
                      fontWeight: FontWeight.w700,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: chip == i ? const Color(0xFFB7E6DC) : RxColors.line,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RxColors.mint,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            '🔒  Your RetinaXAI report is shared only with your consent.',
            style: TextStyle(color: RxColors.tealDeep, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 14),
        for (final doctor in doctors) ...[
          _DoctorCard(
            doctor: doctor,
            onVideo: () => widget.state.beginBooking(doctor),
            onBook: () => widget.state.beginBooking(doctor),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.doctor,
    required this.onVideo,
    required this.onBook,
  });

  final Doctor doctor;
  final VoidCallback onVideo;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: RxColors.mint,
                child: Text('👩‍⚕️', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: RxColors.navy,
                      ),
                    ),
                    Text(
                      '${doctor.role} • ${doctor.years} yrs',
                      style: const TextStyle(color: RxColors.muted),
                    ),
                    Text(
                      '${doctor.hospital} • ${doctor.distanceKm} km',
                      style: const TextStyle(color: RxColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFF5C518), size: 18),
              const SizedBox(width: 4),
              Text(
                '${doctor.rating}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 10),
              if (doctor.video)
                const _Tag(label: 'Video'),
              if (doctor.inClinic) ...[
                const SizedBox(width: 6),
                const _Tag(label: 'In-clinic'),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinePillButton(
                  label: 'Video Consult',
                  onTap: onVideo,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TealButton(label: 'Book Visit', onTap: onBook),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: RxColors.muted, fontWeight: FontWeight.w600),
    );
  }
}
