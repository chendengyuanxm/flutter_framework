import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/common/index.dart';
import 'package:flutter_framework/net/api.dart';
import 'package:flutter_framework/service/index.dart';
import 'package:flutter_framework/service/navigation_service.dart';
import 'package:flutter_framework/util/index.dart';
import 'default_transformer.dart';
import 'http_request_exception.dart';
import 'interceptors/log_interceptor.dart';
import 'interceptors/token_interceptor.dart';

abstract class HttpClient {
  static final Dio _dio = HttpClient._singleInstance();
  static const VALIDATE_STATUS = [200, 201, 204];
  static List<Interceptor> interceptors = [];
  bool showLoading = false;

  static final BaseOptions _baseOptions = new BaseOptions(
    contentType: ContentType.json.toString(),
    connectTimeout: 60 * 1000,
    baseUrl: Api.BASE_URL,
    headers: {"accept": "application/json"},
    validateStatus: (status) => VALIDATE_STATUS.contains(status),
  );

  static _singleInstance() {
    var dio = new Dio(_baseOptions);
    dio.transformer = FlutterTransformer();
    dio.interceptors.add(TokenInterceptor());
    dio.interceptors.add(LogsInterceptors());
    return dio;
  }

  Future<T?> get<T>(
    String url,
    Map<String, dynamic> queryParams, {
    Options? options,
    CancelToken? cancelToken,
    bool isShowProgress = true,
  }) {
    return _request<T>("get", url, queryParameters: queryParams, options: options, isShowProgress: isShowProgress);
  }

  Future<T?> post<T>(
    String url,
    Map<String, dynamic> queryParams, {
    dynamic body,
    Options? options,
    CancelToken? cancelToken,
    bool isShowProgress = true,
  }) {
    return _request<T>("post", url,
        data: body == null ? {} : body, queryParameters: queryParams, options: options, cancelToken: cancelToken, isShowProgress: isShowProgress);
  }

  Future<T?> delete<T>(
    String url,
    Map<String, dynamic> queryParams, {
    dynamic body,
    Options? options,
    CancelToken? cancelToken,
    bool isShowProgress = true,
  }) {
    return _request<T>("delete", url, data: body, queryParameters: queryParams, options: options, cancelToken: cancelToken, isShowProgress: isShowProgress);
  }

  Future<T?> put<T>(
    String url,
    Map<String, dynamic> queryParams, {
    dynamic body,
    Options? options,
    CancelToken? cancelToken,
    bool isShowProgress = true,
  }) {
    return _request<T>("put", url,
        data: body == null ? {} : body, queryParameters: queryParams, options: options, cancelToken: cancelToken, isShowProgress: isShowProgress);
  }

  Future<T?> _request<T>(
    String method,
    path, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool isShowProgress = true,
  }) async {
    try {
      _showProgress(isShowProgress);
      Response resp = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options()..method = method,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      T result = _handleResult<T>(resp);
      return result;
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

  T _handleResult<T>(Response resp) {
    if (resp.data == null || resp.data == '') {
      throw HttpRequestException(-1, ErrorCode.HTTP_NOT_CONTENT, 'HTTP NOT CONTENT');
    } else {
      T t = parseResult(resp);
      return t;
    }
  }

  _showProgress(bool isShowProgress) {
    if (isShowProgress && !showLoading) {
      showLoading = true;
      BuildContext context = navigationKey.currentState!.overlay!.context;
      DialogUtil.showLoadingDialog(context);
    }
  }

  _dismissProgress() {
    if (showLoading) {
      showLoading = false;
      locator<NavigationService>().pop();
    }
  }

  T parseResult<T>(Response resp);
}
