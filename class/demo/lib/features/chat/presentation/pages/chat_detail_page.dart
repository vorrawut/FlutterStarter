import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  final String chatId;
  final bool isGroupChat;

  const ChatDetailPage({
    super.key,
    required this.chatId,
    this.isGroupChat = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat $chatId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Chat Detail Page - Coming Soon'),
            Text('Chat ID: $chatId'),
            Text('Group Chat: $isGroupChat'),
          ],
        ),
      ),
    );
  }
}
