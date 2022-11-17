import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:unifiedchat/pages/login.dart";
import "package:unifiedchat/router.dart";
import "package:window_size/window_size.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox("twitchBox");
  await Hive.openBox("settingsBox");

  setupWindow();

  runApp(MyApp());
}

const double maxHeight = 1080;
const double maxWidth = 1920;
const double minHeight = 800;
const double minWidth = 500;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    WidgetsFlutterBinding.ensureInitialized();

    setWindowTitle("Unified Chat");

    setWindowMaxSize(const Size(maxWidth, maxHeight));
    setWindowMinSize(const Size(minWidth, minHeight));

    getCurrentScreen().then(
      (screen) => {
        setWindowFrame(
          Rect.fromCenter(
            center: screen!.frame.center,
            width: minWidth,
            height: minHeight,
          ),
        ),
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final _settingsBox = Hive.box("settingsBox");

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = _settingsBox.get("dark_mode", defaultValue: false);
    String token = _settingsBox.get("access_token", defaultValue: "");

    return ScreenUtilInit(
      designSize: const Size(minWidth, minHeight),
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: token.isEmpty ? const LoginPage() : const MyRouter(),
      ),
    );
  }
}
