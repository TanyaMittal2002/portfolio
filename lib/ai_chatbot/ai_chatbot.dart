import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/links.dart';

/// ---------------------- AI CHATBOT ----------------------

Future<void> showAiChatDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const AiChatWindow(),
  );
}

class AiChatBotButton extends StatelessWidget {
  const AiChatBotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF5B6EF5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () => showAiChatDialog(context),
        child:
            const Icon(Icons.chat_bubble_outline, size: 28, color: Colors.white),
      ),
    );
  }
}


class AiChatWindow extends StatefulWidget {
  const AiChatWindow({super.key});

  @override
  State<AiChatWindow> createState() => _AiChatWindowState();
}

class _AiChatWindowState extends State<AiChatWindow> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  String _buildBotReply(String rawText) {
    final text = rawText.toLowerCase();

    if (text.contains('hi') ||
        text.contains('hello') ||
        text.contains('hey') ||
        text.contains('namaste')) {
      return "Hi there! I am Tanya's portfolio AI. Ask me about my skills, projects, experience, or grab my resume.";
    }

    if (text.contains('skill') || text.contains('tech')) {
      return "My core skills: Flutter, Dart, Firebase, REST APIs, UI/UX, and motion/animation work. I focus on clean architecture and smooth user flows.";
    }

    if (text.contains('experience') || text.contains('work history')) {
      return "I am a Flutter Developer at Petro IT Solutions (Jul 2023–Present), working on Stack61 and Platform with performance and stability improvements. Before that I interned as a Flutter Developer at Petro IT (Feb 2023–Jul 2023).";
    }

    if (text.contains('project')) {
      return "Recent projects:\n- Stack61: inspection/tracking app with advanced state management and caching.\n- Platform: modern UI with real-time data flows.\n- Pipetrack: secure auth, robust API handling, offline-first features.\nHappy to dive deeper on any of these.";
    }

    if (text.contains('resume') || text.contains('cv')) {
      return "You can download my latest resume here: $resumeDownloadUrl\nLet me know if you want a quick summary.";
    }

    if (text.contains('contact') ||
        text.contains('reach') ||
        text.contains('email')) {
      return "You can reach me through the contact form on this page or email me at $hireMeEmail. I will get back to you soon.";
    }

    if (text.contains('hire') ||
        text.contains('freelance') ||
        text.contains('work with')) {
      return "I am open to Flutter roles and freelance work. Share a bit about your project scope and timeline, and I will let you know how I can help.";
    }

    return "Thanks for asking! I can tell you about my skills, projects (Stack61, Platform, Pipetrack), experience at Petro IT Solutions, or share my resume link: $resumeDownloadUrl. What would you like to know?";
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    _controller.clear();

    // ✨ Fake delay like ChatGPT typing
    await Future.delayed(const Duration(milliseconds: 700));

    // ✨ Simple rule-based reply for the portfolio assistant
    setState(() {
      messages.add({
        "role": "bot",
        "text": _buildBotReply(text),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white.withAlpha((0.95 * 255).toInt()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 380,
        height: 520,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tanya AI Assistant",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const Divider(),

            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[index];
                  final isUser = msg["role"] == "user";

                  return Align(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color(0xFF5B6EF5)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        msg["text"]!,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Input Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => sendMessage(_controller.text),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF5B6EF5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
