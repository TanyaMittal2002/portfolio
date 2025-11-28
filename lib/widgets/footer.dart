import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
