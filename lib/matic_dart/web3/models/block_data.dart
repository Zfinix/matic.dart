import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ethers/crypto/formatting.dart';
import 'package:web3dart/web3dart.dart';

class BlockData with EquatableMixin {
  final EtherAmount? baseFeePerGas;
  final String difficulty;
  final String extraData;
  final EtherAmount? gasLimit;
  final EtherAmount? gasUsed;
  final String hash;
  final String logsBloom;
  final String miner;
  final String mixHash;
  final String nonce;
  final String number;
  final String parentHash;
  final String receiptsRoot;
  final String sha3Uncles;
  final String size;
  final String stateRoot;
  final String timestamp;
  final String totalDifficulty;
  final List<String> transactions;
  final String transactionsRoot;
  final List<dynamic> uncles;
  BlockData({
    required this.baseFeePerGas,
    required this.difficulty,
    required this.extraData,
    required this.gasLimit,
    required this.gasUsed,
    required this.hash,
    required this.logsBloom,
    required this.miner,
    required this.mixHash,
    required this.nonce,
    required this.number,
    required this.parentHash,
    required this.receiptsRoot,
    required this.sha3Uncles,
    required this.size,
    required this.stateRoot,
    required this.timestamp,
    required this.totalDifficulty,
    required this.transactions,
    required this.transactionsRoot,
    required this.uncles,
  });

  BlockData copyWith({
    EtherAmount? baseFeePerGas,
    String? difficulty,
    String? extraData,
    EtherAmount? gasLimit,
    EtherAmount? gasUsed,
    String? hash,
    String? logsBloom,
    String? miner,
    String? mixHash,
    String? nonce,
    String? number,
    String? parentHash,
    String? receiptsRoot,
    String? sha3Uncles,
    String? size,
    String? stateRoot,
    String? timestamp,
    String? totalDifficulty,
    List<String>? transactions,
    String? transactionsRoot,
    List<dynamic>? uncles,
  }) {
    return BlockData(
      baseFeePerGas: baseFeePerGas ?? this.baseFeePerGas,
      difficulty: difficulty ?? this.difficulty,
      extraData: extraData ?? this.extraData,
      gasLimit: gasLimit ?? this.gasLimit,
      gasUsed: gasUsed ?? this.gasUsed,
      hash: hash ?? this.hash,
      logsBloom: logsBloom ?? this.logsBloom,
      miner: miner ?? this.miner,
      mixHash: mixHash ?? this.mixHash,
      nonce: nonce ?? this.nonce,
      number: number ?? this.number,
      parentHash: parentHash ?? this.parentHash,
      receiptsRoot: receiptsRoot ?? this.receiptsRoot,
      sha3Uncles: sha3Uncles ?? this.sha3Uncles,
      size: size ?? this.size,
      stateRoot: stateRoot ?? this.stateRoot,
      timestamp: timestamp ?? this.timestamp,
      totalDifficulty: totalDifficulty ?? this.totalDifficulty,
      transactions: transactions ?? this.transactions,
      transactionsRoot: transactionsRoot ?? this.transactionsRoot,
      uncles: uncles ?? this.uncles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baseFeePerGas': baseFeePerGas,
      'difficulty': difficulty,
      'extraData': extraData,
      'gasLimit': gasLimit,
      'gasUsed': gasUsed,
      'hash': hash,
      'logsBloom': logsBloom,
      'miner': miner,
      'mixHash': mixHash,
      'nonce': nonce,
      'number': number,
      'parentHash': parentHash,
      'receiptsRoot': receiptsRoot,
      'sha3Uncles': sha3Uncles,
      'size': size,
      'stateRoot': stateRoot,
      'timestamp': timestamp,
      'totalDifficulty': totalDifficulty,
      'transactions': transactions,
      'transactionsRoot': transactionsRoot,
      'uncles': uncles,
    };
  }

  factory BlockData.fromMap(Map<String, dynamic> map) {
    return BlockData(
      baseFeePerGas:  map.containsKey('baseFeePerGas')
          ? EtherAmount.fromUnitAndValue(
              EtherUnit.wei,
              hexToInt(map['baseFeePerGas'] as String),
            )
          : null,
      difficulty: map['difficulty'] ?? '',
      extraData: map['extraData'] ?? '',
      gasLimit: map['gasLimit'] ?? '',
      gasUsed: map['gasUsed'] ?? '',
      hash: map['hash'] ?? '',
      logsBloom: map['logsBloom'] ?? '',
      miner: map['miner'] ?? '',
      mixHash: map['mixHash'] ?? '',
      nonce: map['nonce'] ?? '',
      number: map['number'] ?? '',
      parentHash: map['parentHash'] ?? '',
      receiptsRoot: map['receiptsRoot'] ?? '',
      sha3Uncles: map['sha3Uncles'] ?? '',
      size: map['size'] ?? '',
      stateRoot: map['stateRoot'] ?? '',
      timestamp: map['timestamp'] ?? '',
      totalDifficulty: map['totalDifficulty'] ?? '',
      transactions: List<String>.from(map['transactions']),
      transactionsRoot: map['transactionsRoot'] ?? '',
      uncles: List<dynamic>.from(map['uncles']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BlockData.fromJson(String source) =>
      BlockData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BlockData(baseFeePerGas: $baseFeePerGas, difficulty: $difficulty, extraData: $extraData, gasLimit: $gasLimit, gasUsed: $gasUsed, hash: $hash, logsBloom: $logsBloom, miner: $miner, mixHash: $mixHash, nonce: $nonce, number: $number, parentHash: $parentHash, receiptsRoot: $receiptsRoot, sha3Uncles: $sha3Uncles, size: $size, stateRoot: $stateRoot, timestamp: $timestamp, totalDifficulty: $totalDifficulty, transactions: $transactions, transactionsRoot: $transactionsRoot, uncles: $uncles)';
  }

  @override
  List<Object> get props {
    return [
      baseFeePerGas ?? '',
      difficulty,
      extraData,
      gasLimit ?? '',
      gasUsed ?? '',
      hash,
      logsBloom,
      miner,
      mixHash,
      nonce,
      number,
      parentHash,
      receiptsRoot,
      sha3Uncles,
      size,
      stateRoot,
      timestamp,
      totalDifficulty,
      transactions,
      transactionsRoot,
      uncles,
    ];
  }
}
