import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class InfoPage extends StatelessWidget {
  final _title = const TextStyle(fontSize: 20, color: Colors.redAccent);
  final _padding = const EdgeInsets.all(8.0);

  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
        centerTitle: true,
        leading: IconButton(
          tooltip: "Go Back",
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: _padding,
            child: Text(
              "What is this?",
              style: _title,
            ),
          ),
          Padding(
            padding: _padding,
            child: const Text(
                "This is an experimental app useful for streamers who streams on multiple platform. This app allows you to show all of your chat (YouTube, Twitch etc.) in one place."),
          ),
          Padding(
            padding: _padding,
            child: Text(
              "Supported Platforms",
              style: _title,
            ),
          ),
          Padding(
            padding: _padding,
            child: const Text(
                "Currently supporting only Twitch chat (without emojis). More platforms will be added in the future."),
          ),
          Padding(
            padding: _padding,
            child: Text(
              "Features",
              style: _title,
            ),
          ),
          Padding(
            padding: _padding,
            child: const Text(
                "This app is built using Flutter, so it is natively available on Android, Windows, Linux and Web. You can download the app to your phone or can use it on your browser. Also you can embed the app on your stream."),
          ),
        ],
      ),
    );
  }
}
