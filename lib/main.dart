import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

const resumeDownloadUrl =
    'https://drive.google.com/uc?export=download&id=1oLvNMtq6gUgPthxO8x90ACJfLS1rDRoI';
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5B6EF5),
              secondary: Color(0xFFFF8F3C),
              onBackground: Colors.black87,
              onSurface: Colors.black87,
            ),
            scaffoldBackgroundColor: const Color(0xFFF7F7FC),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            textTheme: GoogleFonts.interTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF5B6EF5),
              secondary: Color(0xFFFF8F3C),
              onBackground: Colors.white,
              onSurface: Colors.white70,
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _introController;
  late final ScrollController _scrollController;
  final _resumeSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AppLogo(),
                      _TopActions(onResumeTap: _scrollToResumeSection),
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
                  ResumeSection(key: _resumeSectionKey),
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

  Future<void> _scrollToResumeSection() async {
    final context = _resumeSectionKey.currentContext;
    if (context != null) {
      await Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(
                  0xFF5B6EF5,
                ).withOpacity(0.15 + _controller.value * 0.1),
                const Color(0xFFFF8F3C).withOpacity(0.12),
              ],
            ),
          ),
        );
      },
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
            gradient: const LinearGradient(
              colors: [Color(0xFF5B6EF5), Color(0xFFFF8F3C)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'T',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Tanya',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _TopActions extends StatelessWidget {
  final VoidCallback onResumeTap;

  const _TopActions({required this.onResumeTap});

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
        TextButton(
          onPressed: onResumeTap,
          child: Text(
            'Resume',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),

        // 🌙 / ☀️ THEME TOGGLE BUTTON
        IconButton(
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () {
            themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
          },
        ),

        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _openUrl('mailto:youremail@example.com'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B6EF5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Hire Me',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4B2EFF), Color(0xFF7A4DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ResponsiveLayout(
            mobile: Column(
              children: [
                _HeroText(centered: true),
                SizedBox(height: 22),
                _HeroImage(),
              ],
            ),
            desktop: Row(
              children: [
                Expanded(flex: 6, child: _HeroText()),
                SizedBox(width: 30),
                Expanded(flex: 5, child: _HeroImage()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final bool centered;
  const _HeroText({this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Hi, I'm Tanya!",
          style: GoogleFonts.poppins(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "FLUTTER DEVELOPER",
          style: GoogleFonts.poppins(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6737FF),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I build modern, high-quality Flutter applications with smooth animations, clean architecture, and elegant UI. \n"
          "I focus on performance, usability, and crafting experiences that feel fast, intuitive, and visually polished.",
          style: GoogleFonts.inter(
            fontSize: 16,
            height: 1.5,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _HeroImage extends StatefulWidget {
  @override
  State<_HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<_HeroImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pandaController;

  @override
  void initState() {
    super.initState();
    _pandaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pandaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pandaController,
      builder: (_, child) {
        final t = _pandaController.value;
        final hop = -12 * sin(t * pi); // gentle hop
        final waveTilt = 0.05 * sin(t * 2 * pi); // subtle wave tilt

        return Transform.translate(
          offset: Offset(0, hop.abs()),
          child: Transform.rotate(angle: waveTilt, child: child),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.asset(
          "assets/images/panda.jpg",
          fit: BoxFit.cover,
          height: 360,
        ),
      ),
    );
  }
}

class _ProfileAnimation extends StatefulWidget {
  @override
  State<_ProfileAnimation> createState() => _ProfileAnimationState();
}

class _ProfileAnimationState extends State<_ProfileAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, -10 * _floatCtrl.value),
          child: child,
        );
      },
      child: Glassmorphism(
        child: Container(
          height: 260,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Colors.white.withOpacity(0.28)),
          ),
          child: Center(
            child: Lottie.asset(
              'assets/animations/intro.json',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
          ),
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

  const Glassmorphism({
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.06)
        : Colors.white.withOpacity(0.35);
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
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
      child: Padding(padding: const EdgeInsets.all(18.0), child: child),
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
        SectionTitle(title: 'Projects'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: projects
              .map(
                (p) => _ProjectCard(
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

class _ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String tech;
  const _ProjectCard({
    required this.title,
    required this.description,
    required this.tech,
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
                    onPressed: () => _openUrl('https://github.com/'),
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
        SectionTitle(title: 'Experience'),
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
              child: _TimelineItem(
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

class _TimelineItem extends StatelessWidget {
  final String company;
  final String role;
  final String duration;
  final String desc;

  const _TimelineItem({
    required this.company,
    required this.role,
    required this.duration,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey.withOpacity(0.8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4, right: 16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),

          // Content
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

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'Resume'),
            const SizedBox(height: 12),
            Text(
              'View or download my latest resume with one tap.',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.download_rounded, size: 18),
                  onPressed: () => _confirmResumeDownload(context),
                  label: const Text(
                    'Download Resume',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B6EF5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmResumeDownload(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Download resume?'),
        content: const Text('Grab a copy of the latest PDF.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _openUrl(resumeDownloadUrl);
            },
            child: const Text('Download'),
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'Contact'),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _message,
                    decoration: const InputDecoration(labelText: 'Message'),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _sendMail,
                        child: const Text('Send'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          _name.clear();
                          _email.clear();
                          _message.clear();
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMail() {
    final subject = Uri.encodeComponent('Portfolio contact from ${_name.text}');
    final body = Uri.encodeComponent(
      '${_message.text}\n\nFrom: ${_name.text} <${_email.text}>',
    );
    final mailto = 'mailto:youremail@example.com?subject=$subject&body=$body';
    _openUrl(mailto);
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '© ${DateTime.now().year} Tanya • Built with Flutter',
        style: GoogleFonts.inter(fontSize: 13),
      ),
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
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  const ResponsiveLayout({
    required this.mobile,
    required this.desktop,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) return desktop;
        return mobile;
      },
    );
  }
}

// helper to open urls
Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    // ignore: avoid_print
    print('Could not launch $url');
  }
}
