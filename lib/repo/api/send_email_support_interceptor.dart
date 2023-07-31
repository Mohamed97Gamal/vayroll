import 'package:dio/dio.dart';
import 'package:vayroll/models/models.dart';
import 'package:vayroll/repo/api/logging_interceptor.dart';
import 'package:vayroll/repo/api/refresh_token_interceptor.dart';
import 'package:vayroll/repo/disk/disk_repo.dart';
import 'package:vayroll/utils/utils.dart';

class SendEmailApi {
  //region Singleton
  static final SendEmailApi _singleton = SendEmailApi._internal();

  final Dio _client, _tokenClient;

  factory SendEmailApi() {
    return _singleton;
  }

  SendEmailApi._internal()
      : _client = _generateClient(),
        _tokenClient = _generateTokenClient();

  static Dio _generateClient() {
    final client = Dio();
    client.options.baseUrl = Urls.baseUrl;
    client.options.connectTimeout = Duration(seconds: 120);
    client.options.receiveTimeout = Duration(seconds: 40);
    // if (!kReleaseMode) client.interceptors.add(LoggingInterceptor());
    client.interceptors.add(LoggingInterceptor());
    client.interceptors.add(RefreshTokenInterceptor(client));
    return client;
  }

  static Dio _generateTokenClient() {
    final client = Dio();
    client.options.baseUrl = Urls.baseUrl;
    client.options.connectTimeout = Duration(seconds: 40);
    client.options.receiveTimeout = Duration(seconds: 40);
    // if (!kReleaseMode) client.interceptors.add(LoggingInterceptor());
    client.interceptors.add(LoggingInterceptor());
    return client;
  }

  Future<BaseResponse<LoginDTO>> refreshToken() async {
    try {
      final refreshToken = (await DiskRepo().getTokens()).last;
      final response = await _tokenClient
          .post(Urls.refreshToken, data: {"token": refreshToken});
      if (response.data['result'] != null) {
        BaseResponse<LoginDTO> refreshResponse = BaseResponse.fromJson(
            response.data, (_) => LoginDTO.fromJson(response.data['result']));
        await DiskRepo().saveTokens(
          refreshResponse.result!.accessToken!,
          refreshResponse.result!.refreshToken!,
        );
        return refreshResponse;
      }
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }

  static BaseResponse getErrorResponse(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          return BaseResponse(
            status: false,
            code: e.response!.statusCode,
            message: (e.response!.data ?? "").toString().isNotEmpty
                ? e.response!.data['error'] ?? e.response!.data['message']
                : e.error.toString(),
            errors: (e.response?.data['errors'] as List?)
                ?.map((e) => e as String)
                .toList(),
          );
        case DioExceptionType.unknown:
          return BaseResponse(status: false, message: 'Connection Failed');
        case DioExceptionType.connectionTimeout:
          break;
        case DioExceptionType.sendTimeout:
          break;
        case DioExceptionType.receiveTimeout:
          break;
        case DioExceptionType.cancel:
          break;
        case DioExceptionType.badCertificate:
          // TODO: Handle this case.
          break;
        case DioExceptionType.connectionError:
          // TODO: Handle this case.
          break;
      }
    }
    printIfDebug(e.toString());
    return BaseResponse(status: false);
  }

  Future<BaseResponse<String>> sendEmailSupport(
      {String? request, String? resourceUri, String? responseBody}) async {
    try {
      final accessToken = (await DiskRepo().getTokens()).first;
      final String? employeeId = await DiskRepo().getEmployeeId();

      final response = await _client.post(
        "admin/support",
        data: {
          "token": accessToken,
          "employeeId": employeeId,
          "request": request,
          "resourceUri": resourceUri,
          "response": responseBody,
        },
      );
      if (response.data['result'] != null)
        return BaseResponse.fromJson(
            response.data, (_) => response.data['result'] as String?);
      return BaseResponse.fromMap(response.data);
    } catch (e) {
      return BaseResponse.fromMap(getErrorResponse(e).toMap());
    }
  }
}

class SendEMailSupportInterceptor extends Interceptor {
  final Dio originalDio;

  SendEMailSupportInterceptor(Dio dio)
      : originalDio = dio;

  @override
  Future onError(DioError? e, ErrorInterceptorHandler handler) async {
    if (e?.response?.statusCode == 200 ||
        e!.requestOptions.path.contains("login")) {
      return super.onError(e!, handler);
    }
    await _sendEmailSupport(e);
    return super.onError(e, handler);
  }

  Future<bool?> _sendEmailSupport(DioError e) async {
    final sendEmailSupportResponse = await SendEmailApi().sendEmailSupport(
      request: e.requestOptions.data?.toString(),
      resourceUri: e.requestOptions.baseUrl + e.requestOptions.path,
      responseBody: e.response?.toString(),
    );
    return sendEmailSupportResponse.status;
  }
}
