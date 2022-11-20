import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:unifiedchat/controllers/counter_controller.dart";
import "package:unifiedchat/controllers/message_controller.dart";
import "package:unifiedchat/widgets/messages.dart";

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final MessageController _messageController = Get.put(MessageController());
  final CounterController _counterController = Get.put(CounterController());

  final _twitchBox = Hive.box("twitchBox");

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

  @override
  void initState() {
    super.initState();

    String channel = _twitchBox.get(
      "channel",
      defaultValue: "",
    );

    print(channel);
  }
}
