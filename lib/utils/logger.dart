import 'package:matic_dart/enums/error_type.dart';
import 'package:matic_dart/utils/error_helper.dart';

class Logger {
  bool isEnabled = false;

  void enableLog(bool value) => this.isEnabled = value;

  void log(dynamic message) {
    if (this.isEnabled) {
      print(message);
    }
  }

  ErrorHelper error(ERROR_TYPE type, [String? info]) {
    final err = ErrorHelper(type: type, info: info);
    print('$type: ${err.message}');
    return err;
  }
}

extension ThrowErrorHelper on ErrorHelper {
  void throwException() {
    throw this;
  }
}
