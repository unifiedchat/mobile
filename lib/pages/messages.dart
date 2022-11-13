import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:multi_stream_chat/controllers/counter_controller.dart";
import "package:multi_stream_chat/controllers/message_controller.dart";
import "package:multi_stream_chat/widgets/messages.dart";
import "package:tmi_dart/tmi.dart";

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final MessageController _messageController = Get.put(MessageController());
  final CounterController _counterController = Get.put(CounterController());

  final _twitchBox = Hive.box("twitchBox");

  Function _onDisposeTwitch = () {
    print("Twitch disposed");
  };

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
  void dispose() {
    super.dispose();

    _onDisposeTwitch();
  }

  @override
  void initState() {
    super.initState();

    String channel = _twitchBox.get(
      "channel",
      defaultValue: "",
    );

    if (channel.isNotEmpty) {
      Client client = Client(
        channels: [
          channel,
        ],
        connection: Connection(
          secure: true,
          reconnect: true,
        ),
      );

      _onDisposeTwitch = client.close;

      client.connect();

      client.on("message", (channel, userstate, message, self) {
        if (self) return;

        _messageController.addMessage(
          message: message,
          platform: "twitch",
          username: userstate["display-name"],
        );
      });
    }
  }
}
