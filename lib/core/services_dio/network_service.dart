import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';
import 'api_error_handler.dart';

class NetworkService {
  static late Dio _dio;

  static Dio get dio {
    return _dio;
  }

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          "x-api-key": ApiConstants.apiKey,
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint("🚀 [DIO REQUEST] ${options.method} => ${options.uri}");
            if (options.queryParameters.isNotEmpty) {
              debugPrint("   Query Parameters: ${options.queryParameters}");
            }
            if (options.data != null) {
              debugPrint("   Request Body: ${options.data}");
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              "✅ [DIO RESPONSE] [${response.statusCode}] <= ${response.requestOptions.uri}",
            );
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          if (kDebugMode) {
            debugPrint(
              "❌ [DIO ERROR] [${error.type}] <= ${error.requestOptions.uri}: ${error.message}",
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

   static Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        endPoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  /// Generic POST request
  static Future<Response> post({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  /// Generic PUT request
  static Future<Response> put({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  /// Generic DELETE request
  static Future<Response> delete({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
