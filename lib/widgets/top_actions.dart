import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/links.dart';
import '../state/theme_mode_notifier.dart';
import '../utils/url_utils.dart';

class TopActions extends StatelessWidget {
  final VoidCallback onResumeTap;
  final VoidCallback onChatTap;

  const TopActions({
    required this.onResumeTap,
    required this.onChatTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        IconButton(
          onPressed: () => openExternalUrl(githubProfileUrl),
          icon: const Icon(Icons.code),
          tooltip: 'GitHub',
        ),
        IconButton(
          onPressed: () => openExternalUrl(linkedinProfileUrl),
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
        TextButton.icon(
          onPressed: onChatTap,
          icon: const Icon(Icons.chat_bubble_outline, size: 18),
          label: Text(
            'Chat',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
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
          onPressed: () => openExternalUrl('mailto:$hireMeEmail'),
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
