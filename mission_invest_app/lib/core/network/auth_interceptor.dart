import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // TODO: Uncomment after Firebase setup
    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   final token = await user.getIdToken();
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO: Handle token refresh or force logout
    }
    handler.next(err);
  }
}
