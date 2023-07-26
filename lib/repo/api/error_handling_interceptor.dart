import 'package:dio/dio.dart';

class ErrorHandlingInterceptor extends QueuedInterceptor {
  @override
  Future onError(DioError? err, ErrorInterceptorHandler handler) async {
    if (err?.response?.statusCode != 502 &&
        err?.response?.statusCode != 504 &&
        err?.response?.statusCode != 500 &&
        err?.response?.statusCode != 403) {
      return super.onError(err!, handler);
    }

    var systemDownResponseBody = {
      "status": false,
      "code": err?.response?.statusCode,
      "message": err?.response?.statusCode == 403 ? "Insufficient permissions!" : "Please contact system admin!",
      "errors": null,
    };

    final sr = Response(
      requestOptions: err!.requestOptions,
      statusCode: err.response!.statusCode,
      data: systemDownResponseBody,
    );
    final systemDownErrorResponse = DioError(
      requestOptions: err.response!.requestOptions,
      response: sr,
      type: DioExceptionType.badResponse,
    );
    return handler.reject(systemDownErrorResponse);
  }
}
