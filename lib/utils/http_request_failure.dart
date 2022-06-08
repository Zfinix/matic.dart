import 'dart:convert';

import 'package:equatable/equatable.dart';

class HttpRequestFailure with EquatableMixin {
  final bool status;
  final String message;
  final List<Object> errors;

  const HttpRequestFailure({
    this.status = false,
    this.errors = const [],
    this.message = 'Error: Unable to process your request',
  });

  static const unableToSend = HttpRequestFailure(
    message: 'Error: Unable to send request',
  );

  static const unableToProcess = HttpRequestFailure(
    message: 'Error: Unable to process your request',
  );

  HttpRequestFailure copyWith({
    bool? status,
    String? message,
    List<Object>? errors,
  }) {
    return HttpRequestFailure(
      status: status ?? this.status,
      message: message ?? this.message,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'errors': errors,
      'message': message,
    };
  }

  factory HttpRequestFailure.fromMap(Map<String, dynamic> map) {
    return HttpRequestFailure(
      status: map['status'] ?? false,
      message: map['message'],
      errors: List<Object>.from(map['errors'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory HttpRequestFailure.fromJson(String source) =>
      HttpRequestFailure.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [status, message, errors];
}
