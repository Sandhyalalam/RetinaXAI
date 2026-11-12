import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';
import 'sample_fundus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.state});

  final AppState state;

  Future<void> _pick(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: source, imageQuality: 92);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      await state.startAnalysis(bytes, file.name);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open picker: $e')),
      );
    }
  }

  Future<void> _sample() async {
    final bytes = await ensureSampleFundus();
    await state.startAnalysis(bytes, 'fundus_0231.png');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: RxColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.remove_red_eye_outlined,
                  color: RxColors.tealDark),
            ),
            const SizedBox(width: 10),
            const Text(
              'RetinaXAI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: RxColors.tealDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Diabetic Retinopathy\nScreening Support',
          style: TextStyle(
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: RxColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload a retinal fundus image to get the DR severity level, probabilities and a visual Grad-CAM explanation.',
          style: TextStyle(color: RxColors.muted, height: 1.4, fontSize: 14),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: () => _pick(context, ImageSource.gallery),
          child: DashedRRect(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFFAF6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Column(
                children: [
                  Icon(Icons.file_upload_outlined,
                      size: 42, color: RxColors.tealDark),
                  SizedBox(height: 10),
                  Text(
                    'Tap to upload fundus image',
                    style: TextStyle(
                      color: RxColors.tealDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'JPG / PNG • clear, well-lit retina',
                    style: TextStyle(color: RxColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TealButton(
          label: 'Choose from Gallery',
          icon: Icons.photo_camera_outlined,
          onTap: () => _pick(context, ImageSource.gallery),
        ),
        const SizedBox(height: 12),
        OutlinePillButton(
          label: 'Take Photo',
          onTap: () => _pick(context, ImageSource.camera),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: _sample,
            child: const Text(
              'Use demo fundus image',
              style: TextStyle(
                color: RxColors.tealDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(child: _Step(n: '1', label: 'Upload')),
            SizedBox(width: 10),
            Expanded(child: _Step(n: '2', label: 'AI Analysis')),
            SizedBox(width: 10),
            Expanded(child: _Step(n: '3', label: 'Explain')),
          ],
        ),
        const SizedBox(height: 14),
        const DisclaimerBanner(),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.n, required this.label});

  final String n;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: RxColors.mint,
            child: Text(
              n,
              style: const TextStyle(
                color: RxColors.tealDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: RxColors.navySoft,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
