import "package:flutter/material.dart";
import "package:get/get.dart";

class MyScrollController extends GetxController {
  final ScrollController _scrollController = ScrollController();

  get scrollController => _scrollController;

  Future<void> scrollToBottom() async {
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 100,
        ),
        curve: Curves.easeOut,
      );
    }
  }
}
