import 'package:dio/dio.dart';
import 'package:vayroll/repo/api/api_repo.dart';
import 'package:vayroll/utils/constants.dart';
import 'package:vayroll/views/settings/settings.dart';

import '../disk/disk_repo.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dioClient;

  RefreshTokenInterceptor(this.dioClient);

  @override
  Future onError(DioException e, ErrorInterceptorHandler handler) async {
    final request = e.requestOptions;
    if (e.response?.statusCode != 401 || !Urls.requiresAuth(url: request.uri.toString().toLowerCase()))
      return handler.next(e);

    if ((await _refreshToken())!) return handler.resolve(await _retry(e.requestOptions));

    await SettingsPage.logout(null);
    return handler.next(e);
  }

  Future<bool?> _refreshToken() async {
    final refreshResponse = await ApiRepo().refreshToken();
    return refreshResponse.status;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final accessToken = (await DiskRepo().getTokens()).first;
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    var data = requestOptions.data as Map<String, dynamic>;
    data.update("token", (_) => accessToken);

    return dioClient.request<dynamic>(
      requestOptions.path,
      data: data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
