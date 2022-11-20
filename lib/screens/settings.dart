import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:unifiedchat/controllers/message_controller.dart";
import "package:unifiedchat/screens/login.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _titlePadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16);
  final _fieldPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
  final _biggerFont = const TextStyle(fontSize: 24);
  final _bigFont = const TextStyle(fontSize: 18);

  final _channelController = TextEditingController();

  final _twitchBox = Hive.box("twitchBox");
  final _settingsBox = Hive.box("settingsBox");

  final MessageController _messageController = Get.put(MessageController());

  bool _darkMode = false;

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
                foregroundColor: Colors.blue,
                side: const BorderSide(
                  color: Colors.blue,
                ),
              ),
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
          Padding(
            padding: _titlePadding,
            child: Text(
              "Dark Mode",
              style: _bigFont,
            ),
          ),
          CupertinoSwitch(
            value: _darkMode,
            onChanged: _onToggleDarkMode,
          ),
          Padding(
            padding: _titlePadding,
            child: Text(
              "Logged in as: ${_settingsBox.get("username")}",
              style: _bigFont,
            ),
          ),
          Padding(
            padding: _fieldPadding,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(
                  color: Colors.red,
                ),
              ),
              onPressed: _onLogout,
              child: Text(
                "Logout",
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

    bool isDark = _settingsBox.get(
      "dark_mode",
      defaultValue: false,
    );
    _darkMode = isDark;

    String channel = _twitchBox.get(
      "channel",
      defaultValue: "",
    );

    _channelController.text = channel;
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
    String channel = _channelController.text.toString();

    if (channel.isEmpty) {
      return;
    }

    Get.snackbar(
      "Connected",
      "Connected to Twitch!",
      duration: const Duration(
        seconds: 2,
      ),
    );

    _twitchBox.put("channel", channel);
  }

  void _onLogout() {
    _settingsBox.put("username", "");
    _settingsBox.put("access_token", "");

    Get.snackbar(
      "Logged Out!",
      "Successfully logged out!",
      duration: const Duration(
        seconds: 3,
      ),
    );

    Get.offAll(() => const LoginScreen());
  }

  void _onToggleDarkMode(bool isDark) {
    setState(() {
      _darkMode = isDark;
    });

    _settingsBox.put("dark_mode", isDark);

    Get.changeTheme(isDark ? ThemeData.dark() : ThemeData.light());
  }
}
