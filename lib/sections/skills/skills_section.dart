import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/glass_container.dart';
import '../../widgets/section_title.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      {'name': 'Flutter', 'level': 0.9},
      {'name': 'Dart', 'level': 0.88},
      {'name': 'Firebase', 'level': 0.75},
      {'name': 'REST APIs', 'level': 0.8},
      {'name': 'UI/UX', 'level': 0.85},
      {'name': 'Animations', 'level': 0.8},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Skills'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills
              .map(
                (s) => _SkillCard(
                  name: s['name'] as String,
                  level: s['level'] as double,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SkillCard extends StatefulWidget {
  final String name;
  final double level;
  const _SkillCard({required this.name, required this.level});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _animCtrl.forward();
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animCtrl,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut)),
        child: Glassmorphism(
          child: Container(
            width: 160,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: widget.level, minHeight: 8),
                const SizedBox(height: 8),
                Text(
                  '${(widget.level * 100).toInt()}% experience',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
