import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:multi_stream_chat/notifiers/messages_notifier.dart";
import "package:multi_stream_chat/notifiers/scroll_notifier.dart";
import "package:provider/provider.dart";

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

  @override
  Widget build(BuildContext context) {
    ScrollNotifier scrollNotifier =
        Provider.of<ScrollNotifier>(context, listen: true);

    if (scrollNotifier.needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

      scrollNotifier.setScroll(false, false);
    }

    return Consumer<MessagesNotifier>(
      builder: (context, messagesNotifier, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: "Scroll to bottom",
          onPressed: () {
            messagesNotifier.addMessage(
                "Hello, world!", "barbarbar338", "twitch");
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
