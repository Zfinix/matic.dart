import 'package:matic_dart/enums/error_type.dart';
import 'package:matic_dart/interfaces/error.dart';

class ErrorHelper extends IError {
  final ERROR_TYPE type;
  final String? info;

  ErrorHelper({
    this.type = ERROR_TYPE.unknown,
    this.info,
  }) : super(type: type, message: '') {
    message = getMsg_(info);
  }

  IError get() => IError(message: this.message, type: this.type);

  String getMsg_(String? info) {
    String errMsg;
    switch (this.type) {
      case ERROR_TYPE.allowedOnRoot:
        errMsg = "The action ${info} is allowed only on child token.";
        break;
      case ERROR_TYPE.allowedOnRoot:
        errMsg = "The action ${info} is allowed only on root token.";
        break;
      case ERROR_TYPE.proofAPINotSet:
        errMsg = "Proof api is not set, please set it using 'setProofApi'";
        break;
      case ERROR_TYPE.burnTxNotCheckPointed:
        errMsg = "Burn transaction has not been checkpointed as yet";
        break;
      case ERROR_TYPE.eIP1559NotSupported:
        errMsg =
            "${info != null ? 'Root' : 'Child'} chain doesn't support eip-1559";
        break;
      case ERROR_TYPE.nullSpenderAddress:
        errMsg = "Please provide spender address.";
        break;
      default:
        errMsg = this.message;
        break;
    }
    return errMsg;
  }
}
