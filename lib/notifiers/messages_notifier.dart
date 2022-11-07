import "dart:collection";

import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:intl/intl.dart";
import "package:multi_stream_chat/notifiers/scroll_notifier.dart";

class MessagesNotifier extends ChangeNotifier {
  final ScrollNotifier scrollNotifier;
  final Map<String, ListTile> _messages = <String, ListTile>{};

  final _biggerFont = const TextStyle(fontSize: 20.0);

  MessagesNotifier(this.scrollNotifier);

  void addMessage(String message, String username, String platform) {
    DateTime now = DateTime.now();

    String id = now.microsecondsSinceEpoch.toString();

    DateFormat formatter = DateFormat("HH:mm:ss");
    String timestmap = formatter.format(now);

    _messages[id] = ListTile(
      leading: FaIcon(
          platform == "twitch"
              ? FontAwesomeIcons.twitch
              : platform == "youtube"
                  ? FontAwesomeIcons.youtube
                  : FontAwesomeIcons.message,
          color: platform == "twitch"
              ? Colors.purple
              : platform == "youtube"
                  ? Colors.red
                  : Colors.black),
      trailing: IconButton(
        icon: const FaIcon(
          FontAwesomeIcons.trash,
          color: Colors.red,
          size: 20.0,
        ),
        onPressed: () => _onDelete(id),
      ),
      title: Text(message, style: _biggerFont),
      subtitle: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: username,
              style: const TextStyle(color: Colors.blue),
            ),
            const TextSpan(
              text: " at ",
            ),
            TextSpan(
              text: timestmap,
              style: const TextStyle(color: Colors.black54),
            ),
            const TextSpan(
              text: " on ",
            ),
            TextSpan(
              text: platform,
              style: TextStyle(
                color: platform == "twitch"
                    ? Colors.purple
                    : platform == "youtube"
                        ? Colors.red
                        : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );

    if (_messages.length > 100) {
      _messages.remove(_messages.keys.first);
    }

    scrollNotifier.setScroll(true, true);
  }

  UnmodifiableListView<ListTile> messages() {
    List<ListTile> list = _messages.values.toList();

    return UnmodifiableListView(list);
  }

  void _onDelete(String id) {
    _messages.remove(id);

    notifyListeners();
  }
}
