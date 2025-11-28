import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/section_title.dart';

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'company': 'Petro IT Solutions',
        'role': 'Flutter Developer (Full-Time)',
        'duration': 'Jul 2023 – Present',
        'desc':
            'Working on Stack61 and Platform projects. Improved UI/UX, implemented key modules, optimized performance, and strengthened application stability.',
      },
      {
        'company': 'Petro IT',
        'role': 'Flutter Developer Intern',
        'duration': 'Feb 2023 – Jul 2023',
        'desc':
            'Built UI components, handled bug fixes, learned production-level Flutter development and API integrations.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Experience'),
        const SizedBox(height: 12),
        Column(
          children: items.map((item) {
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: TimelineItem(
                company: item['company']!,
                role: item['role']!,
                duration: item['duration']!,
                desc: item['desc']!,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String company;
  final String role;
  final String duration;
  final String desc;

  const TimelineItem({
    required this.company,
    required this.role,
    required this.duration,
    required this.desc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey.withAlpha((0.8 * 255).toInt()),
        border: Border.all(
          color: Colors.white.withAlpha((0.2 * 255).toInt()),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.12 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4, right: 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
