import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_framework/common/index.dart';
import 'package:flutter_framework/generated/json/base/json_convert_content.dart';
import 'package:flutter_framework/util/index.dart';
import 'http_request_exception.dart';
import 'interceptors/log_interceptor.dart';
import 'interceptors/token_interceptor.dart';

const baseUrl = '';

class HttpClient {
  static final Dio _dio = HttpClient._singleInstance();
  static const VALIDATE_STATUS = [200, 201, 204];

  static final BaseOptions _baseOptions = new BaseOptions(
    contentType: ContentType.json.toString(),
    connectTimeout: 60 * 1000,
    baseUrl: baseUrl,
    headers: {"accept": "application/json"},
    validateStatus: (status) => VALIDATE_STATUS.contains(status),
  );

  static _singleInstance() {
    var dio = new Dio(_baseOptions);
    dio.transformer = DefaultTransformer(
      jsonDecodeCallback: (String responseBody) {
        return json.decode(responseBody);
      },
    );
    dio.interceptors.add(TokenInterceptor());
    dio.interceptors.add(LogsInterceptors());
    return dio;
  }

  Future<T?> get<T>(String url, Map<String, dynamic> queryParams, {Options? options, bool isShowProgress = true}) {
    return _request<T>("get", url, queryParameters: queryParams, options: options, isShowProgress: isShowProgress);
  }

  Future<T?> post<T>(String url, Map<String, dynamic> queryParams, {dynamic body, Options? options, bool isShowProgress = true}) {
    return _request<T>("post", url, data: body == null ? {} : body, queryParameters: queryParams, options: options, isShowProgress: isShowProgress);
  }

  Future<T?> delete<T>(String url, Map<String, dynamic> queryParams, {dynamic body, Options? options, bool isShowProgress = true}) {
    return _request<T>("delete", url, data: body, queryParameters: queryParams, options: options, isShowProgress: isShowProgress);
  }

  Future<T?> put<T>(String url, Map<String, dynamic> queryParams, {dynamic body, Options? options, bool isShowProgress = true}) {
    return _request<T>("put", url, data: body == null ? {} : body, queryParameters: queryParams, options: options, isShowProgress: isShowProgress);
  }

  Future<T?> _request<T>(String method, path,
      {data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Options? options,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool isShowProgress = true}) async {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    try {
      _showProgress(isShowProgress);
      Response resp = await _dio.request(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
      if (resp.data == null || resp.data == '') {
        throw HttpRequestException(-1, ErrorCode.HTTP_NOT_CONTENT, 'HTTP NOT CONTENT');
      } else {
        int status = resp.data['code'];
        String message = resp.data['message'];
        dynamic result = resp.data['result'];
        if (status == 200) {
          if (T == dynamic) {
            return result;
          } else {
            T bean = JsonConvert.fromJsonAsT<T>(result);
            return bean;
          }
        }
        throw HttpRequestException(status, status.toString(), message);
      }
    } on DioError catch (dioErr) {
      LogUtil.e(dioErr);
      if (dioErr.response != null) {
        var errorResponse = dioErr.response;
        var statusCode = errorResponse?.statusCode;
        var errorCode = ErrorCode.ERROR_CODE_UNKNOWN;
        var errorMsg = errorResponse.toString();
        throw HttpRequestException(statusCode!, errorCode, errorMsg);
      }
    } on Error catch (e) {
      LogUtil.e(e.stackTrace.toString());
      throw HttpRequestException(-1, ErrorCode.ERROR_CODE_UNKNOWN, e.toString());
    } finally {
      _dismissProgress();
    }
  }

  _showProgress(bool isShowProgress) {
  }

  _dismissProgress() {
  }
}

final HttpClient http = new HttpClient();
