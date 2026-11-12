import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('h:mm').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 18, 4),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: RxColors.navy,
            ),
          ),
          const Spacer(),
          const Icon(Icons.signal_cellular_alt, size: 16, color: RxColors.navy),
          const SizedBox(width: 4),
          const Text(
            '5G',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: RxColors.navy,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 22,
            height: 11,
            decoration: BoxDecoration(
              border: Border.all(color: RxColors.navy, width: 1.2),
              borderRadius: BorderRadius.circular(3),
            ),
            padding: const EdgeInsets.all(1.5),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: ColoredBox(color: RxColors.navy),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.index,
    required this.onTap,
  });

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.access_time_rounded, 'History'),
      (Icons.chat_bubble_outline_rounded, 'AI Chat'),
      (Icons.health_and_safety_outlined, 'Doctors'),
      (Icons.person_outline_rounded, 'Profile'),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: RxColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 12),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].$1,
                        color: i == index ? RxColors.tealDark : const Color(0xFFB0B8C4),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              i == index ? FontWeight.w700 : FontWeight.w500,
                          color: i == index
                              ? RxColors.tealDark
                              : const Color(0xFFB0B8C4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TealButton extends StatelessWidget {
  const TealButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        gradient: RxGradients.teal,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: RxColors.teal.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class OutlinePillButton extends StatelessWidget {
  const OutlinePillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: RxColors.navy,
          side: const BorderSide(color: Color(0xFFD5DEE8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.color});

  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12263F).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class DashedRRect extends StatelessWidget {
  const DashedRRect({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashPainter(),
      child: child,
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(28),
    );
    final paint = Paint()
      ..color = const Color(0xFF8FD4C6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    const dash = 8.0;
    const gap = 6.0;
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        canvas.drawPath(
          metric.extractPath(dist, math.min(dist + dash, metric.length)),
          paint,
        );
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FundusView extends StatelessWidget {
  const FundusView({
    super.key,
    this.bytes,
    this.heatmap = false,
    this.opacity = 1,
    this.size = 160,
  });

  final Uint8List? bytes;
  final bool heatmap;
  final double opacity;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (bytes != null)
              Image.memory(bytes!, fit: BoxFit.cover)
            else
              CustomPaint(painter: FundusPainter()),
            if (heatmap)
              Opacity(
                opacity: opacity,
                child: CustomPaint(painter: HeatmapPainter()),
              ),
          ],
        ),
      ),
    );
  }
}

class FundusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.shortestSide / 2;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFE8A15A), Color(0xFFC44B12), Color(0xFF7A2208)],
        ).createShader(rect),
    );
    final disc = Offset(size.width * 0.72, size.height * 0.46);
    canvas.drawCircle(
      disc,
      radius * 0.16,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFFFFE7A3), Color(0xFFE8B14A)],
        ).createShader(Rect.fromCircle(center: disc, radius: radius * 0.16)),
    );
    final vessel = Paint()
      ..color = const Color(0xFF5A1A12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.018
      ..strokeCap = StrokeCap.round;
    final vessel2 = Paint()
      ..color = const Color(0xFF7A2A18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.012
      ..strokeCap = StrokeCap.round;
    Path branch(Offset a, Offset b, Offset c) {
      return Path()
        ..moveTo(a.dx, a.dy)
        ..quadraticBezierTo(b.dx, b.dy, c.dx, c.dy);
    }
    canvas.drawPath(
      branch(disc, Offset(size.width * 0.48, size.height * 0.32), Offset(size.width * 0.22, size.height * 0.18)),
      vessel,
    );
    canvas.drawPath(
      branch(disc, Offset(size.width * 0.52, size.height * 0.58), Offset(size.width * 0.24, size.height * 0.78)),
      vessel,
    );
    canvas.drawPath(
      branch(disc, Offset(size.width * 0.58, size.height * 0.28), Offset(size.width * 0.42, size.height * 0.10)),
      vessel2,
    );
    canvas.drawPath(
      branch(Offset(size.width * 0.40, size.height * 0.42), Offset(size.width * 0.28, size.height * 0.50), Offset(size.width * 0.16, size.height * 0.46)),
      vessel2,
    );
    final specks = Paint()..color = const Color(0xFFD9A15A);
    canvas.drawCircle(Offset(size.width * 0.34, size.height * 0.40), 4, specks);
    canvas.drawCircle(Offset(size.width * 0.30, size.height * 0.48), 3, specks);
    canvas.drawCircle(Offset(size.width * 0.38, size.height * 0.52), 5, specks);
    canvas.drawCircle(Offset(size.width * 0.44, size.height * 0.44), 2.5, specks);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blobs = [
      (Offset(size.width * 0.62, size.height * 0.42), size.width * 0.28, 0.7),
      (Offset(size.width * 0.40, size.height * 0.52), size.width * 0.22, 0.55),
      (Offset(size.width * 0.48, size.height * 0.38), size.width * 0.16, 0.4),
    ];
    for (final blob in blobs) {
      canvas.drawCircle(
        blob.$1,
        blob.$2,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFEB3B).withValues(alpha: blob.$3),
              const Color(0xFFFF5722).withValues(alpha: blob.$3 * 0.7),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: blob.$1, radius: blob.$2)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: RxColors.warnBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        compact
            ? '⚠  Screening support only — not a medical diagnosis.'
            : '⚠  Screening-support prototype. Not a substitute for professional medical diagnosis.',
        style: const TextStyle(
          color: RxColors.warnText,
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.subtitle,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left, size: 28),
            )
          else
            const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: RxColors.navy,
                  ),
                ),
                if (subtitle != null) subtitle!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    late String label;
    late Color bg;
    late Color fg;
    if (level >= 3) {
      label = 'Review';
      bg = const Color(0xFFFDE4EE);
      fg = RxColors.severe;
    } else if (level == 2) {
      label = 'Monitor';
      bg = const Color(0xFFFFF1D6);
      fg = const Color(0xFFD98912);
    } else if (level == 1) {
      label = 'Low';
      bg = const Color(0xFFE3F7EA);
      fg = RxColors.ok;
    } else {
      label = 'Normal';
      bg = const Color(0xFFE3F7EA);
      fg = RxColors.ok;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
