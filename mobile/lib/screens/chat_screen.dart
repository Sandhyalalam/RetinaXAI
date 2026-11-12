import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../state.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.state});

  final AppState state;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _send([String? preset]) {
    final text = preset ?? controller.text;
    widget.state.sendChat(text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final scan = state.current;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            children: [
              const Text(
                'AI Assistant',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: RxColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Icon(Icons.circle, size: 10, color: Color(0xFF2FA36B)),
                  SizedBox(width: 6),
                  Text(
                    'Online • Explains results, not a doctor',
                    style: TextStyle(color: RxColors.muted, fontSize: 13),
                  ),
                ],
              ),
              if (scan != null && scan.id != 'pending') ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE4EE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '📄  Report: ${scan.title} • ${DateFormat('dd MMM').format(scan.createdAt)}',
                      style: const TextStyle(
                        color: RxColors.severe,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              for (final msg in state.messages) ...[
                Align(
                  alignment:
                      msg.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    constraints: const BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      color: msg.fromUser ? RxColors.chatBubble : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF12263F).withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.fromUser ? Colors.white : RxColors.navy,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                if (msg.cta != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TealButton(
                        label: msg.cta!,
                        icon: Icons.health_and_safety_outlined,
                        onTap: state.openDoctors,
                        expanded: false,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (final chip in [
                'Explain probabilities',
                'Next steps',
                'Diet & care tips',
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(chip),
                    onPressed: () => _send(chip),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: RxColors.line),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: RxColors.navy,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: 'Ask about your result...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 24,
                backgroundColor: RxColors.tealDark,
                child: IconButton(
                  onPressed: _send,
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
