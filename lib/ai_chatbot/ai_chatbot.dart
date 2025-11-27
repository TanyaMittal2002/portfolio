import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ---------------------- AI CHATBOT ----------------------

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
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AiChatWindow(),
          );
        },
        child: const Icon(Icons.chat_bubble_outline, size: 28, color: Colors.white),
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

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    _controller.clear();

    // ✨ Fake delay like ChatGPT typing
    await Future.delayed(const Duration(milliseconds: 700));

    // ✨ Simple AI reply — You can later replace this with OpenAI API
    setState(() {
      messages.add({
        "role": "bot",
        "text": "Thanks for your message! I’m Tanya’s Portfolio AI.\nHow can I assist you today?"
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white.withOpacity(0.95),
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
