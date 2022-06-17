import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:web3dart/web3dart.dart';

class FeeHistoryModel with EquatableMixin {
  final List<String> baseFeePerGas;
  final List<double> gasUsedRatio;
  final BlockNum oldestBlock;
  final List<List<String>> reward;
  FeeHistoryModel({
    required this.baseFeePerGas,
    required this.gasUsedRatio,
    required this.oldestBlock,
    required this.reward,
  });

  FeeHistoryModel copyWith({
    List<String>? baseFeePerGas,
    List<double>? gasUsedRatio,
    BlockNum? oldestBlock,
    List<List<String>>? reward,
  }) {
    return FeeHistoryModel(
      baseFeePerGas: baseFeePerGas ?? this.baseFeePerGas,
      gasUsedRatio: gasUsedRatio ?? this.gasUsedRatio,
      oldestBlock: oldestBlock ?? this.oldestBlock,
      reward: reward ?? this.reward,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baseFeePerGas': baseFeePerGas,
      'gasUsedRatio': gasUsedRatio,
      'oldestBlock': oldestBlock,
      'reward': reward,
    };
  }

  factory FeeHistoryModel.fromMap(Map<String, dynamic> map) {
    return FeeHistoryModel(
      baseFeePerGas: List<String>.from(map['baseFeePerGas']),
      gasUsedRatio: List<double>.from(map['gasUsedRatio']),
      oldestBlock: map['oldestBlock'] != null
          ? BlockNum.exact(int.parse(map['oldestBlock'] as String))
          : const BlockNum.pending(),
      reward: List<List<String>>.from(map['reward']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FeeHistoryModel.fromJson(String source) =>
      FeeHistoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FeeHistoryModel(baseFeePerGas: $baseFeePerGas, gasUsedRatio: $gasUsedRatio, oldestBlock: $oldestBlock, reward: $reward)';
  }

  @override
  List<Object> get props => [baseFeePerGas, gasUsedRatio, oldestBlock, reward];
}
