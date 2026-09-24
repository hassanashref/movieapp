import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout with server. Please check your internet connection.";
        case DioExceptionType.sendTimeout:
          return "Send timeout in connection with server.";
        case DioExceptionType.receiveTimeout:
          return "Receive timeout in connection with server.";
        case DioExceptionType.badCertificate:
          return "Bad certificate received from server.";
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        case DioExceptionType.cancel:
          return "Request to server was cancelled.";
        case DioExceptionType.connectionError:
          return "No internet connection. Please verify your network and try again.";
        case DioExceptionType.unknown:
        default:
          if (error.message != null &&
              error.message!.contains("SocketException")) {
            return "No internet connection. Please verify your network.";
          }
          return "Unexpected network error occurred. Please try again.";
      }
    }
    return error?.toString() ?? "An unexpected error occurred.";
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) {
      return "Something went wrong. Please try again.";
    }

    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey("status_message") &&
          data["status_message"] != null &&
          data["status_message"].toString().isNotEmpty) {
        return data["status_message"].toString();
      }
      if (data.containsKey("message") &&
          data["message"] != null &&
          data["message"].toString().isNotEmpty) {
        return data["message"].toString();
      }
      if (data.containsKey("error") &&
          data["error"] != null &&
          data["error"].toString().isNotEmpty) {
        return data["error"].toString();
      }
    }

    switch (response.statusCode) {
      case 400:
        return "Bad request. Please check your inputs.";
      case 401:
        return "Unauthorized. Authentication failed.";
      case 403:
        return "Forbidden request. Access denied.";
      case 404:
        return "Requested resource not found.";
      case 429:
        return "Too many requests. Please slow down.";
      case 500:
        return "Internal server error. Please try again later.";
      case 502:
        return "Bad gateway. Server is temporarily unavailable.";
      case 503:
        return "Service unavailable. Server is under maintenance.";
      default:
        return "Received invalid status code: ${response.statusCode}";
    }
  }
}
