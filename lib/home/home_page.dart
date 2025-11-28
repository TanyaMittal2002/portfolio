import 'package:flutter/material.dart';

import '../sections/contact/contact_section.dart';
import '../sections/hero/hero_section.dart';
import '../sections/projects/projects_section.dart';
import '../sections/resume/resume_section.dart';
import '../sections/skills/skills_section.dart';
import '../sections/timeline/timeline_section.dart';
import '../widgets/app_logo.dart';
import '../widgets/footer.dart';
import '../widgets/glass_container.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/top_actions.dart';
import '../ai_chatbot/ai_chatbot.dart';
import '../ai_chatbot/chat_cta_section.dart';

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
  final _chatSectionKey = GlobalKey();

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
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppLogo(),
                          TopActions(
                            onResumeTap: _scrollToResumeSection,
                            onChatTap: _scrollToChatSection,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AnimatedBuilder(
                        animation: _introController,
                        builder: (_, child) => Opacity(
                          opacity: _introController.value,
                          child: Transform.translate(
                            offset:
                                Offset(0, (1 - _introController.value) * 20),
                            child: child,
                          ),
                        ),
                        child: const HeroSection(),
                      ),
                      const SizedBox(height: 28),
                      GlassSection(
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
                      ChatCtaSection(
                        key: _chatSectionKey,
                        onOpenChat: () => showAiChatDialog(context),
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
          const AiChatBotButton(),
        ],
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

  Future<void> _scrollToChatSection() async {
    final context = _chatSectionKey.currentContext;
    if (context != null) {
      await Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
