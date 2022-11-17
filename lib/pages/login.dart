import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:unifiedchat/pages/signup.dart";
import "package:unifiedchat/providers/backend_provider.dart";
import "package:unifiedchat/router.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _settingsBox = Hive.box("settingsBox");

  final BackendProvider _backendProvider = Get.put(BackendProvider());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
              child: const FlutterLogo(
                size: 40,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextFormField(
                controller: _usernameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _usernameValidator,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  labelText: "Username",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextFormField(
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _passwordValidator,
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  labelText: "Password",
                ),
              ),
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _onLogin,
                child: const Text("Login"),
              ),
            ),
            TextButton(
              onPressed: _onCreate,
              child: Text(
                "Create an account",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _onCreate() {
    Get.to(
      () => const SignupPage(),
      transition: Transition.rightToLeftWithFade,
    );
  }

  Future<void> _onLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    String? isUsernameValid = _usernameValidator(username);

    if (isUsernameValid != null && isUsernameValid.isNotEmpty) {
      Get.snackbar(
        "Invalid Username",
        isUsernameValid,
        duration: const Duration(
          seconds: 3,
        ),
      );
      return;
    }

    String? isPasswordValid = _passwordValidator(password);

    if (isPasswordValid != null && isPasswordValid.isNotEmpty) {
      Get.snackbar(
        "Invalid Password",
        isPasswordValid,
        duration: const Duration(
          seconds: 3,
        ),
      );
      return;
    }

    Response res = await _backendProvider.authenticate(
      username: username,
      password: password,
    );

    int statusCode = res.statusCode ?? 500;

    if (statusCode < 200 || statusCode >= 300) {
      String message = res.body["message"] ??
          "An error occurred while creating an account, please try again later.";

      Get.snackbar(
        "Error",
        message,
        duration: const Duration(
          seconds: 3,
        ),
      );
      return;
    }
    String accessToken = res.body["data"]["access_token"];

    _settingsBox.put("access_token", accessToken);
    _settingsBox.put("username", username);

    Get.snackbar(
      "Logged In!",
      "Logged in as $username, welcome back!",
      duration: const Duration(
        seconds: 3,
      ),
    );

    Get.offAll(() => const MyRouter());
  }

  String? _passwordValidator(String? value) {
    int length = value?.length ?? 0;
    if (length < 8) return "Password must be at least 8 characters long";
    if (length > 32) return "Password must be at most 32 characters long";
    return null;
  }

  String? _usernameValidator(String? value) {
    int length = value?.length ?? 0;
    if (length < 3) return "Username must be at least 3 characters long";
    if (length > 32) return "Username must be at most 32 characters long";
    return null;
  }
}
