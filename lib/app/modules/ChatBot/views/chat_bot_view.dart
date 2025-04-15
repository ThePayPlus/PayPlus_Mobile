import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_bot_controller.dart';

class ChatBotView extends GetView<ChatBotController> {
  const ChatBotView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBotView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChatBotView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
