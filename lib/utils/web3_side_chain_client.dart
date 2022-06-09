

import 'package:matic_dart/abstracts/base_web3_client.dart';
import 'package:matic_dart/interfaces/base_client_config.dart';
import 'package:matic_dart/utils/abi_manager.dart';
import 'package:matic_dart/utils/index.dart';
import 'package:matic_dart/utils/logger.dart';

class Web3SideChainClient{
    final BaseWeb3Client parent;
    final BaseWeb3Client child;


   final ABIManager abiManager;

  final  logger =  Logger();
   final Map resolution ;
     T_CONFIG config;

  Web3SideChainClient({
    required this.parent,
    required this.child,
    required this.config,
    required this.abiManager,
     this.resolution= const{},
  });

    init(IBaseClientConfig _config) {
        config?.parent.defaultConfig = _config.parent?.defaultConfig;
        config.child.defaultConfig = config.child.defaultConfig;
        this.config = _config;

        // tslint:disable-next-line
        const Web3Client =Utils.Web3Client;

        if (!Web3Client) {
            throw 'Web3Client is not set';
        }

        if (utils.UnstoppableDomains) {
            this.resolution = utils.UnstoppableDomains;
        }

        this.parent = new (Web3Client as any)(config.parent.provider, this.logger);
        this.child = new (Web3Client as any)(config.child.provider, this.logger);

        this.logger.enableLog(config.log);

        const network = config.network;
        const version = config.version;
        const abiManager = this.abiManager =
            new ABIManager(network, version);
        this.logger.log("init called", abiManager);
        return abiManager.init().catch(err => {
            throw new Error(`network ${network} - ${version} is not supported`);
        });
    }

    getABI(name: string, type?: string) {
        return this.abiManager.getABI(name, type);
    }

    getConfig(path: string) {
        return this.abiManager.getConfig(path);
    }

    get mainPlasmaContracts() {
        return this.getConfig("Main.Contracts");
    }

    get mainPOSContracts() {
        return this.getConfig("Main.POSContracts");
    }

    isEIP1559Supported(isParent: boolean): boolean {
        return isParent ? this.getConfig("Main.SupportsEIP1559") :
            this.getConfig("Matic.SupportsEIP1559");
    }


}

