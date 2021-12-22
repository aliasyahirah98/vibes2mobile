import 'package:myveteran/core/provider/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:myveteran/shared/config/constant.dart';

class ApiSync {
  final String _baseUrl = apiUrl;

  Future<dynamic> get(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWithHeader(String url, String token) async {
    dynamic responseJson;
    var header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: header);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map body) async {
    dynamic responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url), body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, Map body) async {
    dynamic responseJson;
    try {
      final response = await http.put(Uri.parse(_baseUrl + url), body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postWithHeader(String url, String token, {Map? body}) async {
    dynamic responseJson;
    var header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(Uri.parse(_baseUrl + url), headers: header, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putWithHeader(String url, String token, {Map? body}) async {
    dynamic responseJson;
    var header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.put(Uri.parse(_baseUrl + url), headers: header, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        // print('responseJson $responseJson');
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}