class AuthModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;

  AuthModel(
    {
      this.accessToken,
      this.tokenType,
      this.expiresIn
    }
  );

  factory AuthModel.fromJson(Map<String, dynamic> objJson) {
    return AuthModel(
      accessToken: objJson['access_token'],
      tokenType: objJson['token_type'],
      expiresIn: objJson['expires_in']
    );
  }
}
