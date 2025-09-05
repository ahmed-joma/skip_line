import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection time out  with  Api server');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Send time out with Api server');

      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive time out with Api server');

      case DioExceptionType.badCertificate:
        return ServerFailure('Bad certificate with Api server');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response?.statusCode ?? 500, dioError.response!.data);

      case DioExceptionType.cancel:
        return ServerFailure('request to ApiServer was canceled');

      case DioExceptionType.connectionError:
        return ServerFailure('Connection error with Api server');

      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailure('No internet Connection');
        }
        return ServerFailure('Unexpected error, Please try again later! ');
      }
  }
  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure('Your request not found, Please try again later !');
    } else if (statusCode == 500) {
      return ServerFailure('Internal Server error, please try again later!');
    } else {
      return ServerFailure('Opps There was an Error, Please try again');
    }
  }
}
