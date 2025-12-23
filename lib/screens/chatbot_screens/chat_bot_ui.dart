import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/services/chat_bot_service.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatBotService _chatService = ChatBotService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add({
          "role": "assistant",
          "content":
              "Halo 🤍 Aku di sini sebagai teman curhat kamu.\n\n"
              "Kamu bebas cerita apa pun yang sedang kamu rasakan. "
              "Aku akan mendengarkan tanpa menghakimi 🌱",
        });
      });
    });
  }

  final List<Map<String, String>> _messages = [
    {
      "role": "system",
      "content":
          "Anda adalah Psikolog Klinis dan Konselor Kesehatan Mental yang empatik, bijaksana, dan profesional. "
          "Tugas utama Anda adalah mendengarkan curhatan pengguna, memberikan validasi emosional, saran koping stres, dan wawasan psikologis. "
          "PENTING: Jika pengguna bertanya tentang coding, matematika, politik, resep masakan, atau hal teknis lainnya, "
          "TOLAK dengan halus. Katakan: 'Maaf, sebagai asisten kesehatan mental, saya hanya fokus pada perasaan dan kesejahteraan Anda.' "
          "Gunakan bahasa yang menenangkan dan suportif.",
    },
  ];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": text});
      _isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    final reply = await _chatService.getReply(_messages);

    if (mounted) {
      setState(() {
        _messages.add({
          "role": "assistant",
          "content": reply ?? "Terjadi kesalahan.",
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _messages.add({
        "role": "system",
        "content":
            "Anda adalah Psikolog Klinis dan Konselor Kesehatan Mental yang empatik. "
            "Tolak topik selain psikologi/curhat dengan sopan.",
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
        leading: SizedBox(),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        actions: [
          Container(
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(2, 0),
                  inset: true,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(-2, 0),
                  inset: true,
                ),
              ],
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.reply, color: Color(0xFF73a664)),
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Kembali",
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF73a664)),
                  onPressed: _resetChat,
                  tooltip: "Clear Chat",
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              decoration: inset.BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                color: Color(0xFF73a664),
                boxShadow: [
                  inset.BoxShadow(
                    color: Colors.black45.withOpacity(0.5),
                    blurRadius: 2,
                    offset: Offset(2, 0),
                    inset: false,
                  ),
                  inset.BoxShadow(
                    color: Colors.black45.withOpacity(0.5),
                    blurRadius: 2,
                    offset: Offset(-2, 0),
                    inset: false,
                  ),
                  inset.BoxShadow(
                    color: Colors.black45.withOpacity(0.5),
                    blurRadius: 2,
                    offset: Offset(0, -2),
                    inset: true,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                        Icons.psychology,
                        color: Color(0xFFacc990),
                        size: 40,
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scaleXY(begin: 0.9, end: 1.1, duration: 1000.ms)
                      .tint(color: Colors.white, duration: 1000.ms),
                  const SizedBox(width: 8),
                  Text(
                    "Your AI Friend",
                    style: GoogleFonts.modernAntiqua(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];

                  if (msg["role"] == "system") {
                    return const SizedBox.shrink();
                  }

                  final isUser = msg["role"] == "user";
                  return ChatBubble(
                        message: msg["content"] ?? "",
                        isUser: isUser,
                      )
                      .animate()
                      .fade(duration: 600.ms)
                      .slideY(begin: 0.2, curve: Curves.easeOut);
                },
              ),
            ),
            if (_isLoading)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: const TypingIndicator().animate().fade(),
                ),
              ),

            Container(
              decoration: inset.BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                color: Color(0xFF73a664),
                boxShadow: [
                  inset.BoxShadow(
                    color: Colors.black45.withOpacity(0.5),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                    inset: true,
                  ),
                ],
              ),

              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: inset.BoxDecoration(
                        color: const Color(0xFF252A34),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          inset.BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 3,
                            offset: Offset(3, 2),
                            inset: true,
                          ),
                          inset.BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 3,
                            offset: Offset(-3, -2),
                            inset: true,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.bricolageGrotesque(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Tell me what you feel...",
                          hintStyle: TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: sendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => sendMessage(_controller.text),
                    child:
                        Container(
                              padding: const EdgeInsets.all(12),
                              decoration: inset.BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  inset.BoxShadow(
                                    color: Colors.black45.withOpacity(0.5),
                                    blurRadius: 2,
                                    offset: Offset(2, 0),
                                    inset: true,
                                  ),
                                  inset.BoxShadow(
                                    color: Colors.black45.withOpacity(0.5),
                                    blurRadius: 2,
                                    offset: Offset(-2, 0),
                                    inset: true,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.send_rounded,
                                color: Color(0xFF73a664),
                                size: 22,
                              ),
                            )
                            .animate(target: _isLoading ? 0 : 1)
                            .scale(duration: 200.ms),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.70,
        ),
        padding: const EdgeInsets.all(16),
        decoration: inset.BoxDecoration(
          color: isUser ? Color(0xFFacc990) : Color(0xFF2B303A),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(40),
            topRight: const Radius.circular(40),
            bottomLeft: isUser
                ? const Radius.circular(40)
                : const Radius.circular(2),
            bottomRight: isUser
                ? const Radius.circular(2)
                : const Radius.circular(40),
          ),
          boxShadow: [
            inset.BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 3,
              offset: Offset(3, 2),
              inset: true,
            ),
            inset.BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 3,
              offset: Offset(-3, -2),
              inset: true,
            ),
          ],
        ),
        child: isUser
            ? Text(
                message,
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )
            : MarkdownBody(
                data: message,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.bricolageGrotesque(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  strong: GoogleFonts.bricolageGrotesque(
                    color: Color(0xFFacc990),
                    fontWeight: FontWeight.bold,
                  ),
                  listBullet: GoogleFonts.bricolageGrotesque(
                    color: Color(0xFFacc990),
                  ),
                ),
              ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B303A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dot(0),
          const SizedBox(width: 4),
          _dot(200),
          const SizedBox(width: 4),
          _dot(400),
        ],
      ),
    );
  }

  Widget _dot(int delay) {
    return Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(begin: 0.5, end: 1.0, duration: 600.ms, delay: delay.ms)
        .tint(color: Color(0xFFacc990), duration: 600.ms);
  }
}
