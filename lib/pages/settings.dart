import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:multi_stream_chat/notifiers/twitch_notifier.dart";
import "package:provider/provider.dart";
import "package:tmi_dart/tmi.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final _usernameController = TextEditingController();
  final _tokenController = TextEditingController();
  final _channelController = TextEditingController();

  final _biggerFont = const TextStyle(fontSize: 20);
  bool _loading = false;
  bool _connected = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    TwitchNotifier twitchNotifier =
        Provider.of<TwitchNotifier>(context, listen: false);

    if (twitchNotifier.username.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _usernameController.text = twitchNotifier.username;
        _channelController.text = twitchNotifier.channel;
        _tokenController.text = twitchNotifier.token;

        _authenticate();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        leading: IconButton(
          tooltip: "Go Back",
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              "Twitch Settings",
              style: _biggerFont,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Username",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "OAuth Token",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _channelController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Channel",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: _biggerFont),
                    onPressed:
                        _loading || _connected ? null : () => _authenticate(),
                    child: Text(_loading
                        ? "Connecting"
                        : _error
                            ? "Error, try again"
                            : _connected
                                ? "Connected"
                                : "Connect"),
                  ),
                ],
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
    _tokenController.dispose();
    _channelController.dispose();

    super.dispose();
  }

  void _authenticate() {
    if (_loading || _connected) return;

    final String username = _usernameController.text;
    final String token = _tokenController.text;
    final String channel = _channelController.text;

    if (username.isEmpty || token.isEmpty || channel.isEmpty) return;

    setState(() {
      _loading = true;
      _connected = false;
      _error = false;
    });

    final client = Client(
      channels: [channel],
      connection: Connection(
        secure: true,
        reconnect: false,
      ),
      identity: Identity(username, token),
    );

    TwitchNotifier twitchNotifier =
        Provider.of<TwitchNotifier>(context, listen: false);

    client.on("connected", (address, port) {
      setState(() {
        _loading = false;
        _error = false;
        _connected = true;
      });

      client.close();

      twitchNotifier.setCredentials(username, token, channel);
    });

    client.on("disconnected", (reason) {
      setState(() {
        _loading = false;
        _error = true;
        _connected = false;
      });

      client.close();

      twitchNotifier.setCredentials("", "", "");
    });

    client.connect();
  }
}
