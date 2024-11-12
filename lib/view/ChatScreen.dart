import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      body: Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/chat111.png'),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'Danny Hopkins',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Quicksand',
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.search_rounded,
                    color: Colors.white70,
                    size: 40,
                  )
                ],
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  '1 FEB 12:00',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMessageBubble(
                        'I want to discuss the design.',
                        const Color(0xff373E4E),
                      ),
                      const SizedBox(height: 10),
                      _buildMessageBubble(
                        'Sure, let\'s schedule a meeting.',
                        const Color(0xff7A8194),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildInputField(),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo một khung chat
  Widget _buildMessageBubble(String message, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Hàm tạo trường nhập tin nhắn với bàn phím và các icon
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xff3D4354),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.camera_alt_outlined),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.send,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
