import 'package:matic_dart/enums/error_type.dart';
import 'package:matic_dart/utils/error_helper.dart';

class Logger {
  bool _isEnabled = false;

  void enableLog(bool value) => this._isEnabled = value;

  void log(dynamic message) {
    if (this._isEnabled) {
      print(message);
    }
  }

  ErrorHelper error(ERROR_TYPE type, [String? info]) {
    return ErrorHelper(
      type: type,
      info: info,
    );
  }
}
