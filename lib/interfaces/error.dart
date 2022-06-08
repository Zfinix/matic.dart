import 'package:matic_dart/enums/error_type.dart';

class IError {
  final ERROR_TYPE type;
  String message;

  IError({
    required this.type,
    required this.message,
  });

  @override
  String toString() => 'IError[$type, $message]';
}
