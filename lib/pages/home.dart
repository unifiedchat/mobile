import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:multi_stream_chat/notifiers/messages_notifier.dart";
import "package:multi_stream_chat/notifiers/scroll_notifier.dart";
import "package:multi_stream_chat/notifiers/twitch_notifier.dart";
import "package:provider/provider.dart";
import "package:tmi_dart/tmi.dart";

class MessageContainer extends StatefulWidget {
  const MessageContainer({super.key});

  @override
  State<MessageContainer> createState() => _MessageContainerState();
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi-Stream Chat"),
        centerTitle: true,
      ),
      body: const MessageContainer(),
    );
  }
}

class _MessageContainerState extends State<MessageContainer> {
  final ScrollController _scrollController = ScrollController();
  String _lastChannel = "";

  @override
  Widget build(BuildContext context) {
    ScrollNotifier scrollNotifier =
        Provider.of<ScrollNotifier>(context, listen: true);
    TwitchNotifier twitchNotifier =
        Provider.of<TwitchNotifier>(context, listen: true);
    MessagesNotifier messagesNotifier =
        Provider.of<MessagesNotifier>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollNotifier.needsScroll) {
        _scrollToEnd();

        scrollNotifier.setScroll(false, false);
      }

      if (twitchNotifier.channel.isNotEmpty &&
          _lastChannel != twitchNotifier.channel) {
        final client = Client(
          channels: [twitchNotifier.channel],
          connection: Connection(
            secure: true,
            reconnect: false,
          ),
          identity: Identity(twitchNotifier.username, twitchNotifier.token),
        );

        client.on("connected", (address, port) {
          messagesNotifier.addMessage("Connected to ${twitchNotifier.channel}",
              "Multi-Stream Chat", "twitch");

          setState(() {
            _lastChannel = twitchNotifier.channel;
          });
        });

        client.on("disconnected", (reason) {
          messagesNotifier.addMessage(
              "Disconnected from Twitch, configure your Twitch account again.",
              "Multi-Stream Chat",
              "twitch");

          setState(() {
            _lastChannel = "";
          });

          client.close();

          twitchNotifier.setCredentials("", "", "");
        });

        client.on("message", (channel, userstate, message, self) {
          if (self) return;

          String username = userstate["display-name"];
          messagesNotifier.addMessage(message, username, "twitch");
        });

        client.connect();
      }
    });

    return Consumer<MessagesNotifier>(
      builder: (context, messagesNotifier, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: "Scroll to bottom",
          onPressed: () {
            scrollNotifier.setScroll(true, true);
          },
          child: const FaIcon(FontAwesomeIcons.arrowDown),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          selectedIconTheme: const IconThemeData(color: Colors.black54),
          selectedItemColor: Colors.black54,
          items: const [
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.circleInfo),
                label: "Info",
                tooltip: "Info"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.gear),
                label: "Configure",
                tooltip: "Configure"),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: ListView(
            padding: const EdgeInsets.all(16.0),
            controller: _scrollController,
            children: messagesNotifier.messages().toList()),
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/info");
        break;
      case 1:
        Navigator.pushNamed(context, "/settings");
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }

  _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50), curve: Curves.easeIn);
  }
}
