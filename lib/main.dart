import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:multi_stream_chat/notifiers/messages_notifier.dart";
import "package:multi_stream_chat/notifiers/scroll_notifier.dart";
import 'package:multi_stream_chat/notifiers/twitch_notifier.dart';
import "package:multi_stream_chat/pages/Home.dart";
import "package:multi_stream_chat/pages/info.dart";
import "package:multi_stream_chat/pages/settings.dart";
import "package:provider/provider.dart";
import "package:window_size/window_size.dart";

void main() {
  setupWindow();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ScrollNotifier>(
            create: (context) => ScrollNotifier()),
        ChangeNotifierProvider<TwitchNotifier>(
          create: (context) => TwitchNotifier(),
        ),
        ChangeNotifierProxyProvider0<MessagesNotifier>(
          create: (context) => MessagesNotifier(
              Provider.of<ScrollNotifier>(context, listen: false)),
          update: (context, messagesNotifier) => MessagesNotifier(
              Provider.of<ScrollNotifier>(context, listen: false)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

const double maxHeight = 1080;
const double maxWidth = 1920;
const double minHeight = 800;
const double minWidth = 500;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    WidgetsFlutterBinding.ensureInitialized();

    setWindowTitle("Multi-Stream Chat");

    setWindowMaxSize(const Size(maxWidth, maxHeight));
    setWindowMinSize(const Size(minWidth, minHeight));

    getCurrentScreen().then((screen) => {
          setWindowFrame(Rect.fromCenter(
              center: screen!.frame.center, width: minWidth, height: minHeight))
        });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(),
        "/settings": (context) => const SettingsPage(),
        "/info": (context) => const InfoPage(),
      },
      title: "Multi-Stream Chat",
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.purple),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.purple)),
    );
  }
}
