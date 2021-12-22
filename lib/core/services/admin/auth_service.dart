import 'dart:async';
import 'package:myveteran/core/models/admin/auth_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';

class AuthService {
  final ApiSync _provider = ApiSync();

  Future<AuthModel> authUserLogin({Map? body}) async {
    final response = await _provider.post('login/auth', body!);
    return AuthModel.fromJson(response);
  }
}