import "dart:collection";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:unifiedchat/controllers/scroll_controller.dart";

class MessagesWidget extends StatefulWidget {
  final UnmodifiableListView<ListTile> messages;

  const MessagesWidget({super.key, required this.messages});

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {
  final MyScrollController _scrollController = Get.put(MyScrollController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.scrollToBottom();
    });

    return ListView(
      controller: _scrollController.scrollController,
      children: widget.messages,
    );
  }
}
