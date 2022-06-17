import 'package:matic_dart/interfaces/base_client_config.dart';
import 'package:matic_dart/matic_dart/web3/index.dart';
import 'package:matic_dart/utils/index.dart';

class Web3SideChainClient<T_CONFIG> {
  final MaticWeb3Client? parent;
  final MaticWeb3Client? child;
  ABIManager? abiManager;
  IBaseClientConfig? config;
  Object? resolution;

  final logger = Logger();
  
  Web3SideChainClient({
    this.parent,
    this.child,
    this.config,
    this.abiManager,
    this.resolution = const {},
  });

  init(IBaseClientConfig _config) {
    if (_config.parent != null) {
      config?.parent?.defaultConfig = _config.parent!.defaultConfig;
    } else if (_config.child?.defaultConfig != null) {
      config?.child?.defaultConfig = _config.child!.defaultConfig;
    }

    this.config = _config;

    // tslint:disable-next-line
    final web3Client = Utils.web3Client;

    if (web3Client == null) {
      throw 'Web3Client is not set';
    }

    if (Utils.unstoppableDomains != null) {
      this.resolution = Utils.unstoppableDomains;
    }

    // parent =  Web3Client(config.parent.provider, this.logger);
    // child =  Web3Client(config.child.provider, this.logger);

    this.logger.enableLog(config!.log);

    final network = config!.network;
    final version = config!.version;
    abiManager = ABIManager(
      networkName: network,
      version: version,
    );

    this.logger.log(["init called", abiManager]);

    try {
      return abiManager?.init();
    } catch (e) {
      throw 'network ${network} - ${version} is not supported';
    }
  }

  Future<dynamic>? getABI({required String name, String? type}) {
    return this.abiManager?.getABI(
          contractName: name,
          bridgeType: type,
        );
  }

  T? getConfig<T>(String path) {
    return this.abiManager?.getConfig<T>(path);
  }

  get mainPlasmaContracts {
    return this.getConfig("Main.Contracts");
  }

  get mainPOSContracts {
    return this.getConfig("Main.POSContracts");
  }

  bool isEIP1559Supported(bool isParent) =>
      (isParent
          ? getConfig<bool>("Main.SupportsEIP1559")
          : getConfig<bool>("Matic.SupportsEIP1559")) ??
      false;
}
