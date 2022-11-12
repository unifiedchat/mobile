import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:hive/hive.dart";
import "package:multi_stream_chat/controllers/message_controller.dart";

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

  final _usernameController = TextEditingController();
  final _channelController = TextEditingController();
  final _oauthTokenController = TextEditingController();

  final _settingsBox = Hive.box("settingsBox");

  final MessageController _messageController = Get.put(MessageController());

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
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Username",
                ),
              )),
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
            child: TextField(
              controller: _oauthTokenController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "OAuth Token",
              ),
            ),
          ),
          Padding(
            padding: _fieldPadding,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue)),
              onPressed: _onConnect,
              child: Text(
                "Connect",
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
                  side: const BorderSide(color: Colors.orange)),
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
    _usernameController.dispose();
    _channelController.dispose();
    _oauthTokenController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _usernameController.text = _settingsBox.get("username");
    _channelController.text = _settingsBox.get("channel");
    _oauthTokenController.text = _settingsBox.get("oauthToken");
  }

  void _onClear() {
    _messageController.emptyMessages();

    Get.snackbar("Cleared", "All messages cleared!");
  }

  void _onConnect() {
    String username = _usernameController.text;
    String channel = _channelController.text;
    String oauthToken = _oauthTokenController.text;

    if (username.isEmpty && channel.isEmpty && oauthToken.isEmpty) {
      return;
    }

    Get.snackbar("Connected", "Connected to Twitch!");

    _messageController.addMessage(
      message: "Connected!",
      username: "Multi-Stream Chat",
      platform: "twitch",
    );

    _settingsBox.put("username", username);
    _settingsBox.put("channel", channel);
    _settingsBox.put("oauthToken", oauthToken);
  }
}
