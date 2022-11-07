import "package:flutter/material.dart";

class ScrollNotifier extends ChangeNotifier {
  bool _needsScroll = false;

  get needsScroll => _needsScroll;

  void setScroll(bool value, bool notifyMe) {
    _needsScroll = value;

    if (notifyMe) {
      notifyListeners();
    }
  }
}
