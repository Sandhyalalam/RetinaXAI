import 'package:flutter/material.dart';

import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.state});

  final AppState state;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final controller = TextEditingController(text: widget.state.apiUrl);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: RxColors.navy,
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: RxColors.mint,
                child: Text(
                  'LS',
                  style: TextStyle(
                    color: RxColors.tealDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'L Sandhya',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: RxColors.navy,
                      ),
                    ),
                    Text(
                      'UI & Integration  •  Batch A8',
                      style: TextStyle(color: RxColors.muted),
                    ),
                    Text(
                      '23P31A4243',
                      style: TextStyle(color: RxColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Backend connection',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: state.backendOnline
                        ? const Color(0xFF2FA36B)
                        : const Color(0xFFE8A317),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    state.backendOnline ? 'Online' : 'Demo mode',
                    style: TextStyle(
                      color: state.backendOnline
                          ? const Color(0xFF2FA36B)
                          : const Color(0xFFE8A317),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'FastAPI POST /predict returns level, probabilities and heatmap_base64.',
                style: TextStyle(color: RxColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'API base URL',
                  hintText: 'http://127.0.0.1:8000',
                ),
              ),
              const SizedBox(height: 10),
              TealButton(
                label: 'Save & ping backend',
                onTap: () async {
                  await state.setApiUrl(controller.text);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.backendOnline
                            ? 'Backend is online.'
                            : 'Backend not reachable — app will use demo inference.',
                      ),
                    ),
                  );
                },
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
                'About RetinaXAI',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explainable AI-based diabetic retinopathy screening support. EfficientNet classifies 5 DR levels and Grad-CAM highlights the regions that influenced the prediction.',
                style: TextStyle(color: RxColors.muted, height: 1.4),
              ),
              const SizedBox(height: 10),
              Text(
                '${state.history.length} scan(s) stored on this device',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              OutlinePillButton(
                label: 'Clear scan history',
                onTap: () async {
                  await state.clearHistory();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History cleared.')),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const DisclaimerBanner(),
      ],
    );
  }
}
