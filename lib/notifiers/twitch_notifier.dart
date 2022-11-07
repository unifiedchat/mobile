import "package:flutter/material.dart";

class TwitchNotifier extends ChangeNotifier {
  String _username = "";
  String _token = "";
  String _channel = "";

  String get channel => _channel;
  String get token => _token;
  String get username => _username;

  void setCredentials(String username, String token, String channel) {
    _username = username;
    _token = token;
    _channel = channel;

    notifyListeners();
  }
}
