import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:product_app/data/app_exceptions.dart';
import 'package:product_app/data/remote/api_url.dart';
import 'package:product_app/data/remote/base_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/models/auth/Login_response.dart';
import 'package:product_app/models/post/login/Refresh_token_request.dart';
import 'package:product_app/models/post/login/login_res.dart';
import 'package:product_app/routes/app_routes.dart';

class NetworkApiService implements BaseApiServer {
  @override
  Future getApi(String url) async {
    if (kDebugMode) {
      print("GET REQUEST URL $url\n");
    }
    dynamic responseJson;
    try {
      var response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 120));
      switch (response.statusCode) {
        case 200:
          responseJson = jsonDecode(response.body);
          break;
        case 400:
          throw UnAuthorization();
        case 500:
          throw InternalServerException();
        default:
          throw Exception('Error occurred with status code: ${response.statusCode}');
      }
    } on SocketException {
      throw NoInternetConnectionException();
    } on TimeoutException {
      throw RequestTimeOutException();
    }
    if (kDebugMode) {
      print("GET RESPONSE BODY $responseJson\n");
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(String url, requestBody) async {
    if (kDebugMode) {
      print("GET REQUEST URL $url BODY : $requestBody\n");
    }
    dynamic responseJson;
    try {
      var storage = GetStorage();
      var user = LoginRes.fromJson(storage.read("USER_KEY"));
      var token = "";
      if(null != user.refreshToken){
        token = user.accessToken??"";
      }
      var headers = {'Content-Type': 'application/json','Authorization':'Bearer ${token}'};
      var response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      )
          .timeout(const Duration(seconds: 120));

      switch (response.statusCode) {
        case 200:
          responseJson = jsonDecode(response.body);
          break;
        case 401:
          if (await refreshTokenApi() == true) {
            print("ON REFRESH TOKEN");
            responseJson = _retry(url, requestBody);
          } else {
            print("Logout");
          }
          break;
        case 500:
          throw InternalServerException();
      }
    } on SocketException {
      throw NoInternetConnectionException();
    } on TimeoutException {
      throw RequestTimeOutException();
    }
    return responseJson;
  }

  Future _retry(String url, requestBody) async {
    dynamic responseJson;
    try {
      var storage = GetStorage();
      var user = LoginResponse.fromJson(storage.read("USER_KEY"));
      var token = "";
      if(null != user.refreshToken){
        token = user.accessToken??"";
      }
      var headers = {'Content-Type': 'application/json','Authorization':'Bearer ${token}'};
      var response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      )
          .timeout(const Duration(seconds: 120));

      switch (response.statusCode) {
        case 200:
          responseJson = jsonDecode(response.body);
          break;
        case 500:
          throw InternalServerException();
      }
    } on SocketException {
      throw NoInternetConnectionException();
    } on TimeoutException {
      throw RequestTimeOutException();
    }
    return responseJson;
  }

  @override
  Future LoginApi(String url, requestBody) async {
    dynamic responseJson;
    if (kDebugMode) {
      print("GET REQUEST URL: $url\nBODY: $requestBody\n");
    }
    try {
      var headers = {'Content-Type': 'application/json',};
      var response = await http
          .post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
      ) // Encode the request body
          .timeout(const Duration(seconds: 120));
      switch (response.statusCode) {
        case 200:
          responseJson = jsonDecode(response.body);
          break;
        case 401:
          throw UnAuthorization();
        case 500:
          throw InternalServerException();
        default:
          // throw Exception('Error occurred with status code: ${response.statusCode}');
      }
    } on SocketException {
      throw NoInternetConnectionException();
    } on TimeoutException {
      throw RequestTimeOutException();
    }
    if (kDebugMode) {
      print("GET RESPONSE BODY $responseJson\n");
    }
    return responseJson;
  }

  Future<bool> refreshTokenApi() async {
    var storage = GetStorage();
    dynamic responseJson;
    try {
      var headers = {'Content-Type': 'application/json'};
      var user = LoginRes.fromJson(storage.read("USER_KEY"));
      var refreshTokenRequest =
          RefreshTokenRequest(refreshToken: user.refreshToken);
      var response = await http
          .post(
        Uri.parse(ApiUrl.postAppRefreshTokenPath),
        headers: headers,
        body: jsonEncode(refreshTokenRequest),
      )
          .timeout(const Duration(seconds: 120));
      switch (response.statusCode) {
        case 200:
          LoginRes responseJson = LoginRes.fromJson(jsonDecode(response.body));
          await storage.write("USER_KEY", responseJson.toJson());
          return true;
        case 401:
          await storage.remove("USER_KEY");
          Get.offAllNamed(RouteName.postSplash);
          return false;
        case 500:
          throw InternalServerException();
        // default:
        //   throw Exception('Error occurred with status code: ${response.statusCode}');
      }
    } on SocketException {
      throw NoInternetConnectionException();
    } on TimeoutException {
      throw RequestTimeOutException();
    }
    return responseJson;
  }

}