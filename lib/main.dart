
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const PortfolioApp());

final themeModeNotifier = ValueNotifier(ThemeMode.system);

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tanya — Flutter Portfolio',
          theme: ThemeData(
            brightness: Brightness.light,
            textTheme: GoogleFonts.interTextTheme(),
            scaffoldBackgroundColor: const Color(0xFFF7F7FC),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            textTheme: GoogleFonts.interTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
            scaffoldBackgroundColor: const Color(0xFF0E0E12),
          ),
          themeMode: mode, // 👈 controlled by toggle
          home: const HomePage(),

        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _introController;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.vertical),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AppLogo(),
                      _TopActions(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _introController,
                    builder: (_, child) => Opacity(
                      opacity: _introController.value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - _introController.value) * 20),
                        child: child,
                      ),
                    ),
                    child: _HeroSection(),
                  ),
                  const SizedBox(height: 28),
                  _GlassSection(
                    child: ResponsiveLayout(
                      mobile: Column(
                        children: const [
                          SkillsSection(),
                          SizedBox(height: 20),
                          ProjectsSection(),
                          SizedBox(height: 20),
                          TimelineSection(),
                          SizedBox(height: 20),
                        ],
                      ),
                      desktop: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(flex: 3, child: SkillsSection()),
                          SizedBox(width: 18),
                          Expanded(flex: 5, child: ProjectsSection()),
                          SizedBox(width: 18),
                          Expanded(flex: 4, child: TimelineSection()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const ContactSection(),
                  const SizedBox(height: 36),
                  const Footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Simple app logo
class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(colors: [Color(0xFF5B6EF5), Color(0xFFFF8F3C)]),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0,4))],
          ),
          child: Center(
            child: Text('T', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Text('Tanya', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _TopActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        IconButton(
          onPressed: () => _openUrl('https://github.com/'),
          icon: const Icon(Icons.code),
          tooltip: 'GitHub',
        ),
        IconButton(
          onPressed: () => _openUrl('https://www.linkedin.com/'),
          icon: const Icon(Icons.business),
          tooltip: 'LinkedIn',
        ),

        // 🌙 / ☀️ THEME TOGGLE BUTTON
        IconButton(
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            themeModeNotifier.value =
            isDark ? ThemeMode.light : ThemeMode.dark;
          },
        ),

        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _openUrl('mailto:youremail@example.com'),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B6EF5),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: const Text('Hire Me'),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _IntroCard(centered: true),
        ],
      ),
      desktop: Row(
        children: [
          Expanded(child: _IntroCard()),
          const SizedBox(width: 20),
          Expanded(child: _ProfileAnimation()),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  final bool centered;
  const _IntroCard({this.centered = false});

  @override
  @override
  Widget build(BuildContext context) {
    final nameStyle = GoogleFonts.poppins(
      fontSize: 38,
      fontWeight: FontWeight.w800,
      height: 1.2,
    );

    final subStyle = GoogleFonts.inter(
      fontSize: 17,
      height: 1.5,
      fontWeight: FontWeight.w500,
    );

    final bodyStyle = GoogleFonts.inter(
      fontSize: 15.5,
      height: 1.6,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : Colors.black87,
    );

    return Glassmorphism(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text('Hi, I\'m Tanya 👋', style: nameStyle),
            const SizedBox(height: 10),

            Text(
              'Flutter Developer • Mobile & Web',
              style: subStyle,
            ),

            const SizedBox(height: 18),

            Text(
              'I craft modern, smooth and visually rich Flutter applications — built with clean architecture, pixel-perfect UI, and delightful animations. \n\n'
                  'My focus is always on performance, usability, and creating meaningful digital experiences.',
              style: bodyStyle,
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () => _openUrl('mailto:youremail@example.com'),
                  child: const Text('Contact'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class _ProfileAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      child: SizedBox(
        height: 260,
        child: Center(
          child: Lottie.asset('assets/animations/intro.json', width: 220, height: 220, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// Reusable glass container with blur + border
class Glassmorphism extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const Glassmorphism({required this.child, this.borderRadius = 20, this.padding = const EdgeInsets.all(0), super.key});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.35);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0,6))],
          ),
          child: child,
        ),
      ),
    );
  }
}

// A thin glass section wrapper that adjusts padding
class _GlassSection extends StatelessWidget {
  final Widget child;
  const _GlassSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: child,
      ),
    );
  }
}

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
        SectionTitle(title: 'Skills'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills.map((s) => _SkillCard(name: s['name'] as String, level: s['level'] as double)).toList(),
        )
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  final String name;
  final double level;
  const _SkillCard({required this.name, required this.level});

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: level, minHeight: 8),
            const SizedBox(height: 8),
            Text('${(level * 100).toInt()}% experience', style: GoogleFonts.inter(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {'title': 'Stack61', 'desc': 'Inspection & tracking app', 'tech': 'Flutter, Firebase'},
      {'title': 'Portfolio', 'desc': 'This portfolio app', 'tech': 'Flutter, Web'},
      {'title': 'PipeFlow', 'desc': 'Industrial tools', 'tech': 'Flutter, SQLite'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Projects'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: projects.map((p) => _ProjectCard(title: p['title'] as String, description: p['desc'] as String, tech: p['tech'] as String)).toList(),
        )
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String tech;
  const _ProjectCard({required this.title, required this.description, required this.tech});

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
                Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(description, style: GoogleFonts.inter(fontSize: 14)),
                const SizedBox(height: 12),
                Text(tech, style: GoogleFonts.inter(fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showProjectDetails(BuildContext context, String title, String desc, String tech) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Glassmorphism(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(desc, style: GoogleFonts.inter(fontSize: 14)),
              const SizedBox(height: 12),
              Text('Tech: $tech', style: GoogleFonts.inter(fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(onPressed: () => _openUrl('https://github.com/'), child: const Text('View on GitHub')),
                  const SizedBox(width: 8),
                  OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'company': 'Company A', 'role': 'Flutter Developer', 'duration': '2022 - Present', 'desc': 'Worked on Stack61 app.'},
      {'company': 'Company B', 'role': 'Mobile Developer', 'duration': '2020 - 2022', 'desc': 'Built user-facing features.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Experience'),
        const SizedBox(height: 12),
        Column(
          children: items.map((it) => _TimelineItem(company: it['company'] as String, role: it['role'] as String, duration: it['duration'] as String, desc: it['desc'] as String)).toList(),
        )
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String company, role, duration, desc;
  const _TimelineItem({required this.company, required this.role, required this.duration, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF5B6EF5), shape: BoxShape.circle)),
              Container(width: 2, height: 60, color: Colors.grey.withOpacity(0.3))
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Glassmorphism(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('$role • $company', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(duration, style: GoogleFonts.inter(fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(desc, style: GoogleFonts.inter(fontSize: 13)),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionTitle(title: 'Contact'),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 8),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 8),
              TextFormField(controller: _message, decoration: const InputDecoration(labelText: 'Message'), maxLines: 4),
              const SizedBox(height: 12),
              Row(children: [
                ElevatedButton(onPressed: _sendMail, child: const Text('Send')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () { _name.clear(); _email.clear(); _message.clear(); }, child: const Text('Clear'))
              ])
            ]),
          )
        ]),
      ),
    );
  }

  void _sendMail() {
    final subject = Uri.encodeComponent('Portfolio contact from ${_name.text}');
    final body = Uri.encodeComponent('${_message.text}\n\nFrom: ${_name.text} <${_email.text}>');
    final mailto = 'mailto:youremail@example.com?subject=$subject&body=$body';
    _openUrl(mailto);
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('© ${DateTime.now().year} Tanya • Built with Flutter', style: GoogleFonts.inter(fontSize: 13)),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5B6EF5), Color(0xFFFF8F3C)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}


class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  const ResponsiveLayout({required this.mobile, required this.desktop, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 900) return desktop;
      return mobile;
    });
  }
}

// helper to open urls
Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    // ignore: avoid_print
    print('Could not launch $url');
  }
}
