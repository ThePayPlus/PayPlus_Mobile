import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_bot_controller.dart';

class ChatBotView extends StatelessWidget {
  const ChatBotView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBotView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // List to display chat messages
          Expanded(
            child: ListView.builder(
              itemCount: 5, // This is just a placeholder for the chat messages
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text('Message #$index', style: TextStyle(fontSize: 18)),
                );
              },
            ),
          ),

          // Input field to type a message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Ask about financial management",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Send message when pressed
                    String message = messageController.text;
                    if (message.isNotEmpty) {
                      print(
                          'Message sent: $message'); // For now, just print the message
                      messageController.clear();
                    }
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
