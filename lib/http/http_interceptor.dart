import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:http_interceptor/models/retry_policy.dart';
import 'package:tracking_mobile/main.dart';
import 'package:tracking_mobile/screens/login_screen.dart';
import 'package:tracking_mobile/constants.dart';

class HttpInterceptor implements InterceptorContract {
  final BuildContext context;

  HttpInterceptor({required this.context});

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers['Authorization'] =
        "Bearer " + (prefs?.getString("access_token"))!;
    data.headers['Content-Type'] = "application/json";
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 200) {
      return data;
    } else if (data.statusCode == 401) {
      if (data.url == "http://${ip}:${port}/api/user/refreshToken") {
        prefs?.clear();
        Navigator.of(navigatorKey.currentContext!)
            .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );*/
      } else if (data.url != "http://${ip}:${port}/login") {
        var url = Uri.parse('http://${ip}:${port}/api/user/refreshToken');
        var response = await client!.get(url, headers: {
          //"Content-Type": "application/json",
          "Authorization": "Bearer " + (prefs?.getString("refresh_token"))!
        });
        prefs!.setString(
            'access_token', jsonDecode(response.body)['access_token']);
      }
    }
    return data;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      // Perform your token refresh here.

      return true;
    }

    return false;
  }
}
