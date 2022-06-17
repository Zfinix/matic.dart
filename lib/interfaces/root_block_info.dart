class IRootBlockInfo {
  final String start;
  final String end;
  final BigInt? headerBlockNumber;
  final BigInt? blockNumber;

  IRootBlockInfo({
    required this.start,
    required this.end,
    this.headerBlockNumber,
    this.blockNumber,
  });

  IRootBlockInfo copyWith({
    String? start,
    String? end,
    BigInt? headerBlockNumber,
    BigInt? blockNumber,
  }) {
    return IRootBlockInfo(
      start: start ?? this.start,
      end: end ?? this.end,
      headerBlockNumber: headerBlockNumber ?? this.headerBlockNumber,
      blockNumber: blockNumber ?? this.blockNumber,
    );
  }
}
