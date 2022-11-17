import "package:get/get.dart";

class BackendProvider extends GetConnect {
  final String apiUrl = "https://unifiedchat-backend.fly.dev/v1";

  Future<Response> authenticate({
    required String username,
    required String password,
  }) async {
    return await post(
      "$apiUrl/auth/login",
      {
        "username": username,
        "password": password,
      },
      contentType: "application/json",
    );
  }

  Future<Response> create({
    required String mail,
    required String username,
    required String password,
  }) async {
    return await post(
      "$apiUrl/auth/signup",
      {
        "username": username,
        "mail": mail,
        "password": password,
      },
      contentType: "application/json",
    );
  }
}
