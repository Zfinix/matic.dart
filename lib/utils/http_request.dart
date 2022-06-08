import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:matic_dart/utils/http_request_failure.dart';

class HttpRequest {
  final String baseUrl;

  Dio get dio => Dio(BaseOptions(baseUrl: baseUrl));

  HttpRequest([this.baseUrl = ""]);

  Future<Either<HttpRequestFailure, Response<T>>> get<T>(
    String url, {
    Map<String, dynamic> query = const {},
  }) async {
    try {
      final req = await dio.get<T>(
        url,
        queryParameters: query,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
      );
      return Right(req);
    } catch (e) {
      return Left(HttpRequestFailure(message: e.toString()));
    }
  }

  Future<Either<HttpRequestFailure, Response<T>>> post<T>(
    String url, {
    Map<String, dynamic> body = const {},
  }) async {
    try {
      final req = await dio.post<T>(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        ),
      );

      return Right(req);
    } catch (e) {
      return Left(HttpRequestFailure(message: e.toString()));
    }
  }
}
