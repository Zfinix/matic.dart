import 'package:matic_dart/config.dart';
import 'package:matic_dart/services/abi_service.dart';
import 'package:matic_dart/services/network_service.dart';

class Service {
  NetworkService? network;
  ABIService? abi;

  Service({
    this.network,
    this.abi,
  });

  Service copyWith({
    NetworkService? network,
    ABIService? abi,
  }) {
    return Service(
      network: network ?? this.network,
      abi: abi ?? this.abi,
    );
  }
}

final service = Service(abi: ABIService(config.abiStoreUrl));
