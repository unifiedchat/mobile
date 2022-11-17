import "package:email_validator/email_validator.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:unifiedchat/providers/backend_provider.dart";
import "package:unifiedchat/router.dart";

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _settingsBox = Hive.box("settingsBox");

  final BackendProvider _backendProvider = Get.put(BackendProvider());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Signup"),
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
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _emailValidator,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  labelText: "Email",
                ),
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
                child: const Text("Signup"),
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
    _emailController.dispose();

    super.dispose();
  }

  String? _emailValidator(String? value) {
    bool isValid = EmailValidator.validate(value ?? "");
    return isValid ? null : "Invalid email";
  }

  Future<void> _onLogin() async {
    String mail = _emailController.text;
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

    String? isEmailValid = _emailValidator(mail);

    if (isEmailValid != null && isEmailValid.isNotEmpty) {
      Get.snackbar(
        "Invalid Email",
        isEmailValid,
        duration: const Duration(
          seconds: 3,
        ),
      );
      return;
    }

    Response res = await _backendProvider.create(
      mail: mail,
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
      "Account Created!",
      "Account created successfully, hello $username!",
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
