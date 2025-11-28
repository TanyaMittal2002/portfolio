import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/links.dart';
import '../../utils/url_utils.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/section_title.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': 'Stack61',
        'desc':
            'Dynamic inspection & tracking app built with advanced state management (Provider, GetX, BLoC), optimized APIs, caching, and smooth UI/UX.',
        'tech': 'Flutter, SQLite, REST APIs',
      },
      {
        'title': 'Platform',
        'desc':
            'Designed modern UI screens, improved navigation flow, and integrated real-time data handling with scalable Flutter components.',
        'tech': 'Flutter, Animations, Firebase',
      },
      {
        'title': 'Pipetrack',
        'desc':
            'End-to-end app with secure authentication, efficient API handling, and offline-first features for reliable data management.',
        'tech': 'Flutter, Secure APIs, Local Cache',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Projects'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: projects
              .map(
                (p) => ProjectCard(
                  title: p['title'] as String,
                  description: p['desc'] as String,
                  tech: p['tech'] as String,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String tech;
  const ProjectCard({
    required this.title,
    required this.description,
    required this.tech,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      child: SizedBox(
        width: 320,
        child: InkWell(
          onTap: () => _showProjectDetails(context, title, description, tech),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(description, style: GoogleFonts.inter(fontSize: 14)),
                const SizedBox(height: 12),
                Text(
                  tech,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showProjectDetails(
  BuildContext context,
  String title,
  String desc,
  String tech,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Glassmorphism(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(desc, style: GoogleFonts.inter(fontSize: 14)),
              const SizedBox(height: 12),
              Text('Tech: $tech', style: GoogleFonts.inter(fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => openExternalUrl(githubProfileUrl),
                    child: const Text('View on GitHub'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
