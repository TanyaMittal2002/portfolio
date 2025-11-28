import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/glass_container.dart';
import '../widgets/section_title.dart';

class ChatCtaSection extends StatelessWidget {
  final VoidCallback onOpenChat;
  const ChatCtaSection({required this.onOpenChat, super.key});

  @override
  Widget build(BuildContext context) {
    return Glassmorphism(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Chat with me'),
            const SizedBox(height: 12),
            Text(
              'Ask me anything about my work, experience, or the projects you see here.',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onOpenChat,
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Start chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B6EF5),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
