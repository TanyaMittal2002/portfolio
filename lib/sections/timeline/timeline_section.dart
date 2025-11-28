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
        _ParallaxTimeline(items: items),
      ],
    );
  }
}

class _ParallaxTimeline extends StatefulWidget {
  final List<Map<String, String>> items;
  const _ParallaxTimeline({required this.items});

  @override
  State<_ParallaxTimeline> createState() => _ParallaxTimelineState();
}

class _ParallaxTimelineState extends State<_ParallaxTimeline> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.04),
                    Colors.white.withOpacity(0.08)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (_) {
              setState(() {});
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.items.length,
              padding: const EdgeInsets.only(right: 10),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return _ParallaxCard(
                  controller: _scrollController,
                  index: index,
                  company: item['company']!,
                  role: item['role']!,
                  duration: item['duration']!,
                  desc: item['desc']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ParallaxCard extends StatelessWidget {
  final ScrollController controller;
  final int index;
  final String company;
  final String role;
  final String duration;
  final String desc;

  const _ParallaxCard({
    required this.controller,
    required this.index,
    required this.company,
    required this.role,
    required this.duration,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final depth = index.isEven ? 1.0 : 1.6;
    final scrollOffset = controller.hasClients ? controller.offset : 0.0;
    final parallax = (scrollOffset / 35) / depth;
    final tilt = (scrollOffset / 900) / depth;
    final fromLeft = index.isEven;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + index * 120),
      builder: (context, value, child) {
        final entryOffset = Offset(fromLeft ? -24 : 24, 20) * (1 - value);
        final opacity = value;
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(entryOffset.dx, entryOffset.dy + parallax),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..rotateY(fromLeft ? tilt : -tilt),
              child: child,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: fromLeft ? 12 : 32,
          right: fromLeft ? 32 : 12,
          bottom: 18,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey.withAlpha((0.82 * 255).toInt()),
          border: Border.all(
            color: Colors.white.withAlpha((0.22 * 255).toInt()),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.14 * 255).toInt()),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 6, right: 12),
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
      ),
    );
  }
}
