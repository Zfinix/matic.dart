import 'dart:typed_data';

import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';

class ITransactionData implements TransactionInformation {
  final String transactionHash;

  /// The hash of the block containing this transaction. If this transaction has
  /// not been mined yet and is thus in no block, it will be `null`
  final String? blockHash;

  /// [BlockNum] of the block containing this transaction, or [BlockNum.pending]
  /// when the transaction is not part of any block yet.
  final BlockNum blockNumber;

  /// The sender of this transaction.
  final EthereumAddress from;

  /// How many units of gas have been used in this transaction.
  final int gas;

  /// The amount of Ether that was used to pay for one unit of gas.
  final EtherAmount gasPrice;

  /// A hash of this transaction, in hexadecimal representation.
  final String hash;

  /// The data sent with this transaction.
  final Uint8List input;

  /// The nonce of this transaction. A nonce is incremented per sender and
  /// transaction to make sure the same transaction can't be sent more than
  /// once.
  final int nonce;

  /// Address of the receiver. `null` when its a contract creation transaction
  final EthereumAddress? to;

  /// Integer of the transaction's index position in the block. `null` when it's
  /// pending.
  int? transactionIndex;

  /// The amount of Ether sent with this transaction.
  final EtherAmount value;

  /// A cryptographic recovery id which can be used to verify the authenticity
  /// of this transaction together with the signature [r] and [s]
  final int v;

  /// ECDSA signature r
  final BigInt r;

  /// ECDSA signature s
  final BigInt s;

  ITransactionData({
    required this.transactionHash,
    this.blockHash,
    required this.blockNumber,
    required this.from,
    required this.gas,
    required this.gasPrice,
    required this.hash,
    required this.input,
    required this.nonce,
    this.to,
    this.transactionIndex,
    required this.value,
    required this.v,
    required this.r,
    required this.s,
  });

  ITransactionData copyWith({
    String? transactionHash,
    String? blockHash,
    BlockNum? blockNumber,
    EthereumAddress? from,
    int? gas,
    EtherAmount? gasPrice,
    String? hash,
    Uint8List? input,
    int? nonce,
    EthereumAddress? to,
    int? transactionIndex,
    EtherAmount? value,
    int? v,
    BigInt? r,
    BigInt? s,
  }) {
    return ITransactionData(
      transactionHash: transactionHash ?? this.transactionHash,
      blockHash: blockHash ?? this.blockHash,
      blockNumber: blockNumber ?? this.blockNumber,
      from: from ?? this.from,
      gas: gas ?? this.gas,
      gasPrice: gasPrice ?? this.gasPrice,
      hash: hash ?? this.hash,
      input: input ?? this.input,
      nonce: nonce ?? this.nonce,
      to: to ?? this.to,
      transactionIndex: transactionIndex ?? this.transactionIndex,
      value: value ?? this.value,
      v: v ?? this.v,
      r: r ?? this.r,
      s: s ?? this.s,
    );
  }

  factory ITransactionData.fromTransactionInformation({
    required TransactionInformation tx,
    required String transactionHash,
  }) {
    return ITransactionData(
      transactionHash: transactionHash,
      blockHash: tx.blockHash,
      blockNumber: tx.blockNumber,
      from: tx.from,
      gas: tx.gas,
      gasPrice: tx.gasPrice,
      hash: tx.hash,
      input: tx.input,
      nonce: tx.nonce,
      to: tx.to,
      transactionIndex: tx.transactionIndex,
      value: tx.value,
      v: tx.v,
      r: tx.r,
      s: tx.s,
    );
  }

  @override

  /// The ECDSA full signature used to sign this transaction.
  MsgSignature get signature => MsgSignature(r, s, v);
}
