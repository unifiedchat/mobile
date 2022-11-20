import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:unifiedchat/screens/login.dart";
import "package:unifiedchat/router.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox("twitchBox");
  await Hive.openBox("settingsBox");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _settingsBox = Hive.box("settingsBox");

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = _settingsBox.get("dark_mode", defaultValue: false);
    String token = _settingsBox.get("access_token", defaultValue: "");

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: token.isEmpty ? const LoginScreen() : const MyRouter(),
    );
  }
}
