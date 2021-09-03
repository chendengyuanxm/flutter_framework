import 'package:dio/dio.dart';
import 'package:flutter_framework/config.dart';
import 'package:flutter_framework/util/index.dart';

class TokenInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await LocalStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = token;
      options.queryParameters.putIfAbsent("token", () => token);
    }
    super.onRequest(options, handler);
  }
}
