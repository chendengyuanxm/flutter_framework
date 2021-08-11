import 'package:flutter_framework/generated/json/base/json_convert_content.dart';
import 'package:flutter_framework/net/abstract_http_client.dart';
import 'package:dio/dio.dart';
import 'http_request_exception.dart';

class DefaultHttpClient extends HttpClient {

  @override
  T parseResult<T>(Response resp) {
    int status = int.parse(resp.data['code']);
    String message = resp.data['message'] ?? resp.data['msg'];
    dynamic result = resp.data['body'];
    if (status == 100) {
      if (T == dynamic) {
        return result;
      } else {
        T bean = JsonConvert.fromJsonAsT<T>(result);
        return bean;
      }
    }

    throw HttpRequestException(status, status.toString(), message);
  }

}
final HttpClient http = new DefaultHttpClient();