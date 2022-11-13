import "dart:collection";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:multi_stream_chat/controllers/counter_controller.dart";

class MessageController extends GetxController {
  final Map<String, ListTile> _messages = <String, ListTile>{}.obs;

  final CounterController _counterController = Get.put(CounterController());

  UnmodifiableListView<ListTile> get messages =>
      UnmodifiableListView<ListTile>(_messages.values.toList());

  void addMessage({
    required String message,
    required String username,
    required String platform,
  }) {
    DateTime now = DateTime.now();

    String id = now.microsecondsSinceEpoch.toString();

    DateFormat formatter = DateFormat("HH:mm:ss");
    String timestamp = formatter.format(now);

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
                : Colors.black,
      ),
      trailing: IconButton(
        icon: const FaIcon(
          FontAwesomeIcons.trash,
          color: Colors.red,
        ),
        onPressed: () => removeMessage(
          id: id,
        ),
      ),
      title: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.w,
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16.w,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: username,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
            const TextSpan(
              text: " at ",
            ),
            TextSpan(
              text: timestamp,
              style: const TextStyle(
                color: Colors.black54,
              ),
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

    switch (platform) {
      case "twitch":
        _counterController.incrementTwitchCounter();
        break;
      case "youtube":
        _counterController.incrementYoutubeCounter();
        break;
      default:
        _counterController.incrementOtherCounter();
    }
  }

  void emptyMessages() {
    _messages.clear();
  }

  void removeMessage({required String id}) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("Delete Message"),
        content: const Text("Are you sure you want to delete this message?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              _messages.remove(id);
              Get.back();
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
}
