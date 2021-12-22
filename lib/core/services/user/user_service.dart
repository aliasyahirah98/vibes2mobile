import 'dart:async';
import 'package:myveteran/core/models/user/user_model.dart';
import 'package:myveteran/core/provider/api_sync.dart';

class UserService {
  final ApiSync _provider = ApiSync();

  Future<UserModel> fetchUserProfileData({String? token}) async {
    final response = await _provider.getWithHeader('login/userdetail', token!);
    return UserModel.fromJson(response);
  }

  Future<UserResponseModel> createUserProfileData({Map? body}) async {
    final response = await _provider.post('login/register', body!);
    return UserResponseModel.fromJson(response);
  }

  Future<UserResponseModel> forgetPasswordData({Map? body}) async {
    final response = await _provider.put('login/forgetpassword', body!);
    return UserResponseModel.fromJson(response);
  }

  Future<UserVerifyModel> verifyUser({Map? body}) async {
    final response = await _provider.put('login/verifyuser', body!);
    return UserVerifyModel.fromJson(response);
  }

  Future<UserVerifyModel> userUpdateProfile({String? token, Map? body}) async {
    final response = await _provider.putWithHeader('login/updateprofile', token!, body: body!);
    return UserVerifyModel.fromJson(response);
  }

  Future<UserVerifyModel> userChangepassword({String? token, Map? body}) async {
    final response = await _provider.putWithHeader('login/changepassword', token!, body: body!);
    return UserVerifyModel.fromJson(response);
  }
}