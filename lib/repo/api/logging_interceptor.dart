import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vayroll/utils/utils.dart';

class LoggingInterceptor extends dio.Interceptor {
  @override
  Future onRequest(dio.RequestOptions options, RequestInterceptorHandler handler) async {
    _logToFile(options);
    final data = options.data;
    final formData = tryCast<dio.FormData>(data);
    if (formData != null) {
      final formMap = <String, dynamic>{};
      formMap.addEntries(formData.fields);
      formMap.addEntries(formData.files);
      log(jsonEncode(formMap), time: DateTime.now(), name: "Requesting => ${options.path}");
    } else {
      log(
          options.queryParameters.length != 0
              ? "QueryParameters:${jsonEncode(options.queryParameters)} ${data != null ? jsonEncode(data) : ""}"
              : jsonEncode(data),
          time: DateTime.now(),
          name: "Requesting => ${options.path}");
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(dio.Response response, ResponseInterceptorHandler handler) async {
    _logToFile(response);
    log(jsonEncode(response.data), time: DateTime.now(), name: "Response: ${response.requestOptions.path}");
    return super.onResponse(response, handler);
  }

  @override
  Future onError(dio.DioError e, dio.ErrorInterceptorHandler handler) async {
    _logToFile(e);
    log(jsonEncode(e.response?.data), time: DateTime.now(), name: "Error: ${e.requestOptions.path}");
    print("Error: ${e.error?.toString()}");
    return super.onError(e, handler);
  }

  void _logToFile(dynamic data) async {
    final String docsPath = (await getApplicationDocumentsDirectory()).path;
    final String logFilePath = '$docsPath/Logs_${dateFormat2.format(DateTime.now())}.txt';
    var file = File(logFilePath);
    if (data is dio.RequestOptions) {
      if (data.queryParameters.length != 0)
        file.writeAsString(
            "[Requesting => ${data.path} ${timeFormat.format(DateTime.now())}] QueryParameters:${jsonEncode(data.queryParameters)} ${data.data != null ? jsonEncode(data.data) : ""}\n",
            mode: FileMode.writeOnlyAppend);
      else
        file.writeAsString(
            "[Requesting => ${data.path} ${timeFormat.format(DateTime.now())}] ${data.data != null ? jsonEncode(data.data) : ""}\n",
            mode: FileMode.writeOnlyAppend);
    } else if (data is dio.Response) {
      file.writeAsString(
          "[Response: ${data.requestOptions.path} ${timeFormat.format(DateTime.now())}] ${jsonEncode(data.data)}\n",
          mode: FileMode.writeOnlyAppend);
    } else if (data is dio.DioError) {
      file.writeAsString(
          "[Error: ${data.requestOptions.path} ${timeFormat.format(DateTime.now())}] ${data.error?.toString()}\n",
          mode: FileMode.writeOnlyAppend);
    }
  }
}
