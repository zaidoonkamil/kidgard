import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://backend.thinger.io',
        receiveDataWhenStatusError: true,
      ),
    );

  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async
  {
    dio!.options.headers =
    {
      'Authorization': token??'',
      'Content-Type': 'application/json',
      'Accept': 'application/json',

    };

    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

}


