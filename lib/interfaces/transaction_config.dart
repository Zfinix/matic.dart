import 'dart:typed_data';
import 'package:web3dart/web3dart.dart';

class ITransactionRequestConfig{
  final BigInt? gasLimit;
  final BigInt? chainId;
  final String? chain;
  final String? hardfork;
  final String? type;

  /// The address of the sender of this transaction.
  ///
  /// This can be set to null, in which case the client will use the address
  /// belonging to the credentials used to this transaction.
  final EthereumAddress? from;

  /// The recipient of this transaction, or null for transactions that create a
  /// contract.
  final EthereumAddress? to;

  /// The maximum amount of gas to spend.
  ///
  /// If [maxGas] is `null`, this library will ask the rpc node to estimate a
  /// reasonable spending via [Web3Client.estimateGas].
  ///
  /// Gas that is not used but included in [maxGas] will be returned.
  final int? maxGas;

  /// How much ether to spend on a single unit of gas. Can be null, in which
  /// case the rpc server will choose this value.
  final EtherAmount? gasPrice;

  /// How much ether to send to [to]. This can be null, as some transactions
  /// that call a contracts method won't have to send ether.
  final EtherAmount? value;

  /// For transactions that call a contract function or create a contract,
  /// contains the hashed function name and the encoded parameters or the
  /// compiled contract code, respectively.
  final Uint8List? data;

  /// The nonce of this transaction. A nonce is incremented per sender and
  /// transaction to make sure the same transaction can't be sent more than
  /// once.
  ///
  /// If null, it will be determined by checking how many transactions
  /// have already been sent by [from].
  final int? nonce;

  final EtherAmount? maxPriorityFeePerGas;
  final EtherAmount? maxFeePerGas;

  const ITransactionRequestConfig({
    this.gasLimit,
    this.chainId,
    this.chain,
    this.hardfork,
    this.type,
    this.from,
    this.to,
    this.maxGas,
    this.gasPrice,
    this.value,
    this.data,
    this.nonce,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
  });

  ITransactionRequestConfig copyWith({
    BigInt? gasLimit,
    BigInt? chainId,
    String? chain,
    String? hardfork,
    String? type,
    EthereumAddress? from,
    EthereumAddress? to,
    int? maxGas,
    EtherAmount? gasPrice,
    EtherAmount? value,
    Uint8List? data,
    int? nonce,
    EtherAmount? maxPriorityFeePerGas,
    EtherAmount? maxFeePerGas,
  }) {
    return ITransactionRequestConfig(
      gasLimit: gasLimit ?? this.gasLimit,
      chainId: chainId ?? this.chainId,
      chain: chain ?? this.chain,
      hardfork: hardfork ?? this.hardfork,
      type: type ?? this.type,
      from: from ?? this.from,
      to: to ?? this.to,
      maxGas: maxGas ?? this.maxGas,
      gasPrice: gasPrice ?? this.gasPrice,
      value: value ?? this.value,
      data: data ?? this.data,
      nonce: nonce ?? this.nonce,
      maxFeePerGas: maxFeePerGas ?? this.maxFeePerGas,
      maxPriorityFeePerGas: maxPriorityFeePerGas ?? this.maxPriorityFeePerGas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gasLimit': gasLimit.toString(),
      'chainId': chainId.toString(),
      'chain': chain,
      'hardfork': hardfork,
      'type': type,
      'from': from?.toString(),
      'to': to?.toString(),
      'maxGas': maxGas,
      'gasPrice': gasPrice?.getInWei,
      'value': value?.getInWei,
      'data': data?.toList() ?? [],
      'nonce': nonce,
      'maxPriorityFeePerGas': maxPriorityFeePerGas?.getInWei,
      'maxFeePerGas': maxFeePerGas?.getInWei,
    };
  }

  Transaction get tx {
    return Transaction(
      from: from ?? this.from,
      to: to ?? this.to,
      maxGas: maxGas ?? this.maxGas,
      gasPrice: gasPrice ?? this.gasPrice,
      value: value ?? this.value,
      data: data ?? this.data,
      nonce: nonce ?? this.nonce,
      maxFeePerGas: maxFeePerGas ?? this.maxFeePerGas,
      maxPriorityFeePerGas: maxPriorityFeePerGas ?? this.maxPriorityFeePerGas,
    );
  }

  factory ITransactionRequestConfig.fromMap(Map<String, dynamic> map) {
    return ITransactionRequestConfig(
      gasLimit: BigInt.parse(map['gasLimit']),
      chainId: BigInt.parse(map['chainId']),
      chain: map['chain'],
      hardfork: map['hardfork'],
      type: map['type'],
      from: map['from'] != null ? EthereumAddress.fromHex(map['from']) : null,
      to: map['to'] != null ? EthereumAddress.fromHex(map['to']) : null,
      maxGas: map['maxGas'],
      gasPrice:
          map['gasPrice'] != null ? EtherAmount.inWei(map['gasPrice']) : null,
      value: map['value'] != null ? EtherAmount.inWei(map['value']) : null,
      data: map['data'] != null ? Uint8List.fromList(map['data']) : null,
      nonce: map['nonce'],
      maxPriorityFeePerGas: map['maxPriorityFeePerGas'] != null
          ? EtherAmount.inWei(map['maxPriorityFeePerGas'])
          : null,
      maxFeePerGas: map['maxFeePerGas'] != null
          ? EtherAmount.inWei(map['maxFeePerGas'])
          : null,
    );
  }
}
