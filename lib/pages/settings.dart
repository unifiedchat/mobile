import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:hive/hive.dart";
import "package:multi_stream_chat/controllers/message_controller.dart";
import "package:tmi_dart/tmi.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _titlePadding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h);
  final _fieldPadding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h);
  final _biggerFont = TextStyle(fontSize: 24.w);
  final _bigFont = TextStyle(fontSize: 18.w);

  final _channelController = TextEditingController();

  final _twitchBox = Hive.box("twitchBox");

  final MessageController _messageController = Get.put(MessageController());

  bool _connecting = false;
  bool _error = false;
  bool _connected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: _titlePadding,
            child: Text(
              "Twitch Settings",
              style: _biggerFont,
            ),
          ),
          Padding(
            padding: _fieldPadding,
            child: TextField(
              controller: _channelController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Channel",
              ),
            ),
          ),
          Padding(
            padding: _fieldPadding,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: _connected
                    ? Colors.green
                    : _error
                        ? Colors.red
                        : Colors.blue,
                side: BorderSide(
                  color: _connected
                      ? Colors.green
                      : _error
                          ? Colors.red
                          : Colors.blue,
                ),
              ),
              onPressed: _onConnect,
              child: Text(
                _connected
                    ? "Connected"
                    : _connecting
                        ? "Connecting"
                        : "Connect",
                style: _bigFont,
              ),
            ),
          ),
          Padding(
            padding: _titlePadding,
            child: Text(
              "Other Settings",
              style: _biggerFont,
            ),
          ),
          Padding(
            padding: _fieldPadding,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(
                  color: Colors.orange,
                ),
              ),
              onPressed: _onClear,
              child: Text(
                "Clear Messages",
                style: _bigFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _channelController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    String channel = _twitchBox.get(
      "channel",
      defaultValue: "",
    );

    _channelController.text = channel;
    if (channel.isNotEmpty) {
      _onConnect();
    }
  }

  void _onClear() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Messages"),
        content: const Text("Are you sure you want to delete all messages?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              _messageController.emptyMessages();

              Get.back();

              Get.snackbar(
                "Cleared",
                "All messages cleared!",
                duration: const Duration(
                  seconds: 2,
                ),
              );
            },
            child: const Text("Delete"),
          ),
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  void _onConnect() {
    if (_connecting) {
      return;
    }

    String channel = _channelController.text;

    if (channel.isEmpty) {
      return;
    }

    setState(() {
      _connecting = true;
      _connected = false;
      _error = false;
    });

    Client client = Client(
      channels: [
        channel,
      ],
      connection: Connection(
        secure: true,
        reconnect: false,
      ),
    );

    client.connect();

    client.on("connected", (address, port) {
      Get.snackbar(
        "Connected",
        "Connected to Twitch!",
        duration: const Duration(
          seconds: 2,
        ),
      );

      _twitchBox.put("channel", channel);

      setState(() {
        _connecting = false;
        _connected = true;
        _error = false;
      });

      client.close();
    });

    client.on("disconnected", (reason) {
      if (reason != "Connection closed.") {
        Get.snackbar(
          "Error",
          "Can not connect to Twitch: $reason",
          duration: const Duration(
            seconds: 3,
          ),
        );

        _twitchBox.delete("channel");

        setState(() {
          _connecting = false;
          _connected = false;
          _error = true;
        });
      }
    });
  }
}
