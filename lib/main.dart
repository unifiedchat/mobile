import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:hive/hive.dart";
import "package:multi_stream_chat/router.dart";
import "package:path_provider/path_provider.dart";
import "package:window_size/window_size.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await Hive.openBox("twitchBox");

  setupWindow();

  runApp(const MyApp());
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
          setWindowFrame(
            Rect.fromCenter(
              center: screen!.frame.center,
              width: minWidth,
              height: minHeight,
            ),
          ),
        });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(minWidth, minHeight),
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const MyRouter(),
      ),
    );
  }
}
