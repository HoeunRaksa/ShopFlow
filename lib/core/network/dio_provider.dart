import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';
import '../token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.read(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final isAuthRoute = options.path.startsWith('/auth');
        print("URL = ${options.uri}");
        if (!isAuthRoute) {
          final token = await tokenStorage.getAccessToken();
          print("ACCESS TOKEN = $token");
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("RESPONSE STATUS = ${response.statusCode}");
        return handler.next(response);
      },
        onError: (e, handler) async {
          final status = e.response?.statusCode;
          final alreadyRetried = e.requestOptions.extra['retried'] == true;

          if ((status == 401 || status == 403) && !alreadyRetried) {
            final refreshToken = await tokenStorage.getRefreshToken();

            if (refreshToken == null || refreshToken.isEmpty) {
              await tokenStorage.clearToken();
              return handler.next(e);
            }

            try {
              final refreshDio = Dio(
                BaseOptions(baseUrl: AppConstants.baseUrl),
              );

              final refreshResponse = await refreshDio.post(
                '/auth/refresh',
                data: {'refreshToken': refreshToken},
              );

              final newAccessToken = refreshResponse.data['accessToken'];

              await tokenStorage.saveAccessToken(newAccessToken);

              final requestOptions = e.requestOptions;
              requestOptions.extra['retried'] = true;
              requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

              final retryResponse = await dio.fetch(requestOptions);

              return handler.resolve(retryResponse);
            } catch (refreshError) {
              await tokenStorage.clearToken();
              return handler.next(e);
            }
          }

          return handler.next(e);
        },
    ),
  );

  return dio;
});
