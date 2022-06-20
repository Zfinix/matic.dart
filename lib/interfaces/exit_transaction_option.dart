import 'package:matic_dart/interfaces/index.dart';

class IExitTransactionOption extends ITransactionOption {
  /**
     * event signature for burn transaction
     *
     * @type {string}
     * @memberof IExitTransactionOption
     */
  final String burnEventSignature;

  const IExitTransactionOption({this.burnEventSignature = ''});

  static const empty = IExitTransactionOption(burnEventSignature: '');
}
