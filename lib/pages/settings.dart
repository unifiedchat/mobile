import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:tmi_dart/tmi.dart";

// TODO: settings page twitch integration is not working
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final _biggerFont = const TextStyle(fontSize: 20);
  bool _connecting = false;

  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Username",
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "OAuth Token",
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
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
                    onPressed: _connecting ? null : _authenticate,
                    child: Text(_connecting ? "Connecting" : "Connect"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _authenticate() {
    if (_connecting) {
      return;
    }
    setState(() {
      _connecting = true;
    });

    final client = Client(
      channels: ["real_barbarbar338"],
      connection: Connection(
        secure: true,
        reconnect: true,
      ),
      identity: Identity("username", "oauth:token"),
    );

    client.connect();

    client.on("connected", (channel, user, message) {
      print("Connected to $channel as $user");
      setState(() {
        _connecting = false;
      });
    });

    client.on("message", (channel, userstate, message, self) {
      print("$channel, $userstate, $message, $self");
    });
  }
}
