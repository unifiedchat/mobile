import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:multi_stream_chat/controllers/counter_controller.dart";
import "package:multi_stream_chat/controllers/message_controller.dart";
import "package:multi_stream_chat/widgets/messages.dart";

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final MessageController _messageController = Get.put(MessageController());
  final CounterController _counterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Obx(
            () => Text(
              "Twitch: ${_counterController.twitchCounter}, YouTube: ${_counterController.youtubeCounter}, Other: ${_counterController.otherCounter}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => MessagesWidget(
          messages: _messageController.messages,
        ),
      ),
    );
  }
}
