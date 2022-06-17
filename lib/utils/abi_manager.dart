import 'package:matic_dart/services/index.dart';
import 'package:matic_dart/utils/resolve.dart';

/* {
    "networkName": {
        "version": {
            "address": "",
            "version": "",
            "abi": {
               "bridgeType": {
                   "contractName": ""
                }
            }
        }
    }
  } */

var cache = <String, Map<String, Map<String, dynamic>>>{};

class ABIManager {
  final String networkName;
  final String version;
  const ABIManager({
    required this.networkName,
    required this.version,
  });

  init() {
    final result = service.abi?.getAddress(
      network: networkName,
      version: version,
    );

    cache[this.networkName] = {
      version: {'address': result, 'abi': {}}
    };
  }

  T? getConfig<T>(String path) {
    return resolve<T>(cache[networkName]![version]!['address'], path);
  }

  Future<dynamic> getABI({
    required String contractName,
    String? bridgeType,
  }) async {
    final targetBridgeABICache = cache[this.networkName]![this.version]!['abi']
        [bridgeType] as Map<String, dynamic>?;

    if (targetBridgeABICache != null) {
      final abiForContract = targetBridgeABICache[contractName] as String?;
      if (abiForContract != null) {
        return Future.value(abiForContract);
      }
    }

    final result = await service.abi?.getABI(
      network: networkName,
      version: version,
      bridgeType: bridgeType ?? 'plasma',
      contractName: contractName,
    );

    setABI(
      contractName: contractName,
      bridgeType: bridgeType ?? 'plasma',
      abi: result ?? {},
    );
    return result;
  }

  void setABI({
    required String contractName,
    required String bridgeType,
    required Map<String, dynamic> abi,
  }) {
    final abiStore =
        cache[networkName]![version]!['abi'] as Map<String, dynamic>;
    final type = abiStore[bridgeType];
    if ((type is bool && type != true) || type != null) {
      abiStore[bridgeType] = {};
    }
    abiStore[bridgeType][contractName] = abi;
  }
}
