import 'dart:typed_data';

import 'package:matic_dart/index.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class EthMethod extends BaseContractMethod {
  final EthereumAddress address;
  final Logger logger;
  final Transaction method;

  const EthMethod({
    required this.address,
    required this.logger,
    required this.method,
  }) : super(logger: logger);

  String toHex(value) {
    if (value is String) {
      return Converter.stringToHex(value);
    } else if (value is int) {
      return Converter.bigIntToHex(BigInt.from(value));
    }
    if (value is BigInt) {
      return Converter.bigIntToHex(value);
    }
    return value != null && value is List<int> ? bytesToHex(value) : value;
  }

  @override
  Uint8List encodeABI() {
    // TODO: implement encodeABI
    throw UnimplementedError();
  }

  @override
  Future<BigInt> estimateGas(ITransactionRequestConfig tx) {
    // TODO: implement estimateGas
    throw UnimplementedError();
  }

  @override
  Future<T> read<T>([ITransactionRequestConfig? tx]) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  ITransactionWriteResult write(ITransactionRequestConfig tx) {
    // TODO: implement write
    throw UnimplementedError();
  }

  /*  Future<T> read<T>(ITransactionRequestConfig tx) {
        this.logger.log(["sending tx with config", tx]);
        return this.method.call(
            maticTxRequestConfigToWeb3(tx) as any
        );
    }

    write(tx: ITransactionRequestConfig) {

        return new TransactionWriteResult(
            this.method.send(
                maticTxRequestConfigToWeb3(tx) as any
            )
        );
    }

    estimateGas(tx: ITransactionRequestConfig): Promise<number> {
        return this.method.estimateGas(
            maticTxRequestConfigToWeb3(tx) as any
        );
    }

    encodeABI() {
        return this.method.encodeABI();
    } */

}
