import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myveteran/core/models/user/user_model.dart';
import 'package:myveteran/core/provider/response.dart';
import 'package:myveteran/core/services/user/user_service.dart';

class UserBloc {
  UserService? _userService;
  final _resultController = StreamController<Response<UserModel>>();
  final _resultControllerResponse = StreamController<Response<UserResponseModel>>();

  StreamSink<Response<UserModel>> get resultSink => _resultController.sink;
  Stream<Response<UserModel?>> get resultStream => _resultController.stream;

  StreamSink<Response<UserResponseModel>> get resultSinkResponse => _resultControllerResponse.sink;
  Stream<Response<UserResponseModel?>> get resultStreamResponse => _resultControllerResponse.stream;

  UserBloc() {
    _userService = UserService();
  }

  loadUserProfile({String? token}) async {
    resultSink.add(Response.loading('Getting token...'));
    try {
      UserModel record = await _userService!.fetchUserProfileData(token: token);
      resultSink.add(Response.completed(record));
    } catch (e) {
      resultSink.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  createUserProfile({Map? body}) async {
    resultSinkResponse.add(Response.loading('Create record...'));
    try {
      UserResponseModel record = await _userService!.createUserProfileData(body: body);
      resultSinkResponse.add(Response.completed(record));
    } catch (e) {
      resultSinkResponse.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  forgetPassword({Map? body}) async {
    resultSinkResponse.add(Response.loading('Forget password record...'));
    try {
      UserResponseModel record = await _userService!.forgetPasswordData(body: body);
      resultSinkResponse.add(Response.completed(record));
    } catch (e) {
      resultSinkResponse.add(Response.error(e.toString()));
      debugPrint(e.toString());
    }
  }

  dispose() {
    _resultController.close();
    _resultControllerResponse.close();
  }
}