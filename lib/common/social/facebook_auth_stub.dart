class FacebookAuth {
  FacebookAuth._();

  static final FacebookAuth instance = FacebookAuth._();

  Future<void> webAndDesktopInitialize({
    required String appId,
    required bool cookie,
    required bool xfbml,
    required String version,
  }) async {}

  Future<LoginResult> login() async {
    return LoginResult(status: LoginStatus.failed);
  }

  Future<Map<String, dynamic>> getUserData() async {
    return <String, dynamic>{};
  }

  Future<void> logOut() async {}
}

class LoginResult {
  LoginResult({required this.status, this.accessToken});

  final LoginStatus status;
  final AccessToken? accessToken;
}

class AccessToken {
  AccessToken({required this.token, required this.userId});

  final String token;
  final String userId;
}

enum LoginStatus { success, cancelled, failed, operationInProgress }
