import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/links.dart';
import '../../utils/url_utils.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/section_title.dart';

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
            const SectionTitle(title: 'Resume'),
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
              openExternalUrl(resumeDownloadUrl);
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }
}
