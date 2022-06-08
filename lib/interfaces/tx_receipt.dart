class ITransactionReceipt {
  final String transactionHash;
  final num transactionIndex;
  final String blockHash;
  final num blockNumber;
  final String from;
  final String to;
  final String contractAddress;
  final num cumulativeGasUsed;
  final num gasUsed;
  final List<ILog>? logs;
  final List<IEventLog>? events;
  final bool status;
  final String logsBloom;
  final String root;
  final String type;

  const ITransactionReceipt({
    required this.transactionHash,
    required this.transactionIndex,
    required this.blockHash,
    required this.blockNumber,
    required this.from,
    required this.to,
    required this.contractAddress,
    required this.cumulativeGasUsed,
    required this.gasUsed,
    this.logs,
    this.events,
    required this.status,
    required this.logsBloom,
    required this.root,
    required this.type,
  });
}

class ILog {
  final String address;
  final String data;
  final List<String> topics;
  final num logIndex;
  final String transactionHash;
  final num transactionIndex;
  final String blockHash;
  final num blockNumber;
  const ILog({
    required this.address,
    required this.data,
    required this.topics,
    required this.logIndex,
    required this.transactionHash,
    required this.transactionIndex,
    required this.blockHash,
    required this.blockNumber,
  });
}

class IEventLog {
  final String event;
  final String address;
  final dynamic returnValues;
  final num logIndex;
  final num transactionIndex;
  final String transactionHash;
  final String blockHash;
  final num blockNumber;
  final IEventRaw? raw;
  const IEventLog({
    required this.event,
    required this.address,
    required this.returnValues,
    required this.logIndex,
    required this.transactionIndex,
    required this.transactionHash,
    required this.blockHash,
    required this.blockNumber,
    this.raw,
  });
}

class IEventRaw {
  final String data;
  final List<String> topics;

  IEventRaw({
    required this.data,
    this.topics = const [],
  });
}
