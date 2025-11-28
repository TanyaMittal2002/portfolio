import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/responsive_layout.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

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
              children: const [
                _HeroText(centered: true),
                SizedBox(height: 22),
                HeroImage(),
              ],
            ),
            desktop: Row(
              children: const [
                Expanded(flex: 6, child: _HeroText()),
                SizedBox(width: 30),
                Expanded(flex: 5, child: HeroImage()),
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

class HeroImage extends StatefulWidget {
  const HeroImage({super.key});

  @override
  State<HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage>
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
        final hop = -12 * sin(t * pi);
        final waveTilt = 0.05 * sin(t * 2 * pi);

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
