

 import 'package:matic_dart/index.dart';
import 'package:web3dart/web3dart.dart';

class RootChain extends BaseToken<IPOSClientConfig> {

    RootChain(Web3SideChainClient<IPOSClientConfig> client_, EthereumAddress address): super(
         contractParam: IContractInitParam(  address: address,
            name: 'RootChain',
            isParent: true),
         client:client_,);

   Future<BaseContractMethod?> method(String methodName, [List args = const[]])async {
        final contract = await getContract();
        return contract?.method(methodName, args);
    }

   Future<String?> getLastChildBlock() async{
        final meth = await method("getLastChildBlock");
       return meth?.read<String>();
    }

    Future<BigInt>  findRootBlockFromChild(BigInt childBlockNumber)async {
        final bigOne = BigInt.one;
        final bigtwo = BigInt.two;
        var checkPointInterval = BigInt.from(10000);

        // first checkpoint id = start * 10000
        var start = bigOne;

        // last checkpoint id = end * 10000
        final method = await this.method("currentHeaderBlock");
        final currentHeaderBlock = await method?.read<String>();
        var end =BigInt.from(BigInt.parse(currentHeaderBlock ?? '')/
            checkPointInterval)
        ;

        // binary search on all the checkpoints to find the checkpoint that contains the childBlockNumber
        var ans;
        while (start<= end) {
            if (start ==end) {
                ans = start;
                break;
            }
            final mid = ( start + end)/bigtwo;
            final headerBlocksMethod = await this.method(
                "headerBlocks",
              [ ( mid * checkPointInterval.toDouble()).toString()]
            );
            final headerBlock = await headerBlocksMethod?.read();

            const headerStart = new utils.BN(headerBlock.start);
            const headerEnd = new utils.BN(headerBlock.end);

            if (headerStart.lte(childBlockNumber) && childBlockNumber.lte(headerEnd)) {
                // if childBlockNumber is between the upper and lower bounds of the headerBlock, we found our answer
                ans = mid;
                break;
            } else if (headerStart.gt(childBlockNumber)) {
                // childBlockNumber was checkpointed before this header
                end = mid.sub(bigOne);
            } else if (headerEnd.lt(childBlockNumber)) {
                // childBlockNumber was checkpointed after this header
                start = mid.add(bigOne);
            }
        }
        return ans.mul(checkPointInterval);
    }

}