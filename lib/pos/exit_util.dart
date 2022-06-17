
import 'package:matic_dart/index.dart';
import 'package:matic_dart/matic_dart/web3/index.dart';
import 'package:matic_dart/pos/root_chain.dart';
import 'package:matic_dart/utils/error_helper.dart';
import 'package:web3dart/web3dart.dart';

class IChainBlockInfo {
    final String lastChildBlock;
    final BlockNum txBlockNumber;

  const IChainBlockInfo({required this.lastChildBlock,required this.txBlockNumber,});
}



 class ExitUtil {
    MaticWeb3Client? maticClient_;

    RootChain? rootChain;

    num? requestConcurrency;
    IBaseClientConfig? config;

    ExitUtil(Web3SideChainClient<IBaseClientConfig> client , RootChain rootChain) {
        this.maticClient_ = client.child;
        this.rootChain = rootChain;
        this.config =  client.config;
        this.requestConcurrency = config?.requestConcurrency;
    }

     getLogIndex_(String logEventSig, TransactionReceipt receipt) {
        var logIndex = -1;

        switch (logEventSig) {
            case '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef':
            case '0xf94915c6d1fd521cee85359239227480c7e8776d7caf1fc3bacad5c269b66a14':
                logIndex = receipt.logs.indexWhere(
                    (log) =>
                        log.topics?[0].toLowerCase() == logEventSig.toLowerCase() &&
                        log.topics?[2].toLowerCase() == '0x0000000000000000000000000000000000000000000000000000000000000000'
                );
                break;

            case '0xc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62':
            case '0x4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb':
                logIndex = receipt.logs.indexWhere(
                    (log) =>
                        log.topics?[0].toLowerCase() == logEventSig.toLowerCase() &&
                        log.topics?[3].toLowerCase() == '0x0000000000000000000000000000000000000000000000000000000000000000'
                );
                break;

            default:
                logIndex = receipt.logs.indexWhere((log) => log.topics?[0].toLowerCase() == logEventSig.toLowerCase());
        }
        if (logIndex < 0) {
            throw "Log not found in receipt";
        }
        return logIndex;
    }

  Future<IChainBlockInfo>  getChainBlockInfo(String burnTxHash) async{


       return  IChainBlockInfo (
                lastChildBlock:'${await rootChain?.getLastChildBlock()}',
                txBlockNumber: (await maticClient_?.getTransaction(burnTxHash))!.blockNumber
             ); 
    }

    bool isCheckPointed_(IChainBlockInfo data) {
        // lastchild block is greater equal to transacton block number; 
        return BigInt.parse(data.lastChildBlock) >= BigInt.from(data.txBlockNumber.blockNum);
    }

    Future<bool> isCheckPointed(String burnTxHash) async{
        final result = await  this.getChainBlockInfo(
            burnTxHash
        );

       return  isCheckPointed_(
                result
            );
    }

    /**
     * returns info about block number existance on parent chain
     * 1. root block number, 
     * 2. start block number, 
     * 3. end block number 
     *
     * @private
     * @param {number} txBlockNumber - transaction block number on child chain
     * @return {*} 
     * @memberof ExitUtil
     */
 Future<IRootBlockInfo?>    getRootBlockInfo(BigInt txBlockNumber)async {
        // find in which block child was included in parent
        BigInt? rootBlockNumber;
        final blockNumber =  await this.rootChain?.findRootBlockFromChild(
            txBlockNumber
        );      
 rootBlockNumber = blockNumber;
            final method = await  this.rootChain?.method(
                "headerBlocks",
                [Converter.bigIntToHex(blockNumber?? BigInt.zero)]
            );
            final rootBlockInfo = await method?.read<IRootBlockInfo>();
 return rootBlockInfo?.copyWith(
                // header block number - root block number in which child block exist 
                headerBlockNumber: rootBlockNumber,
                // range of block
                // end - block end number
                end: rootBlockInfo.end.toString(),
                // start - block start number
                start: rootBlockInfo.start.toString(),
            );
        
    }

     getRootBlockInfoFromAPI(BigInt txBlockNumber)async {
        maticClient_?.logger.log("block info from API 1");
        final headerBlock = await service.network?.getBlockIncluded(
            network:config?.network ?? '',
            blockNumber: txBlockNumber
        );


         maticClient_?.logger.log(["block info from API 2", headerBlock]);
            if (!headerBlock || !headerBlock.start || !headerBlock.end || !headerBlock.headerBlockNumber) {
                throw 'Network API Error';
            }
        
            maticClient_?.logger.log("block info from API");
            return this.getRootBlockInfo(txBlockNumber);
    }

     getBlockProof(BigInt txBlockNumber,  IRootBlockInfo rootBlockInfo) {
       /*  return ProofUtil.buildBlockProof(
            this.maticClient_,
            parseInt(rootBlockInfo.start, 10),
            parseInt(rootBlockInfo.end, 10),
            parseInt(txBlockNumber + '', 10)
        ); */
    }

     getBlockProofFromAPI(BigInt txBlockNumber, IRootBlockInfo rootBlockInfo)async {

        final blockProof =  await service.network?.getProof(
           network: config!.network,
           root: rootBlockInfo.copyWith(blockNumber:txBlockNumber),
            
        );


        final _blockProof = getBlockProof(txBlockNumber, rootBlockInfo);

 if (_blockProof != null) {
                throw 'Network API Error';
            }
            maticClient_?.logger.log("block proof from API 1");
            return blockProof;
    }

    buildPayloadForExit(String burnTxHash, String logEventSig,bool isFast) async{

        if (isFast && service.network != null) {
             ErrorHelper(type:ERROR_TYPE.proofAPINotSet).throwException();
        }

         BigInt? txBlockNumber ;
         IRootBlockInfo?   rootBlockInfo;
         TransactionReceipt?   receipt;
          IBlockWithTransaction?  block;
           var blockProof;

        final blockInfo =await  this.getChainBlockInfo(
            burnTxHash
        );
         if (this.isCheckPointed_(blockInfo) == false) {
                throw
                    'Burn transaction has not been checkpointed as yet';
            }
        
        // step 1 - Get Block number from transaction hash
            txBlockNumber = blockInfo.txBlockNumber;
            // step 2-  get transaction receipt from txhash and 
            // block information from block number
            return Promise.all([
                this.maticClient_.getTransactionReceipt(burnTxHash),
                this.maticClient_.getBlockWithTransaction(txBlockNumber)
            ]);
            
            
            d.then(result => {
            [receipt, block] = result;
            // step  3 - get information about block saved in parent chain 
            return (
                isFast ? this.getRootBlockInfoFromAPI(txBlockNumber) :
                    this.getRootBlockInfo(txBlockNumber)
            );
        }).then(rootBlockInfoResult => {
            rootBlockInfo = rootBlockInfoResult;
            // step 4 - build block proof
            return (
                isFast ? this.getBlockProofFromAPI(txBlockNumber, rootBlockInfo) :
                    this.getBlockProof(txBlockNumber, rootBlockInfo)
            );
        }).then(blockProofResult => {
            blockProof = blockProofResult;
            // step 5- create receipt proof
            return ProofUtil.getReceiptProof(
                receipt,
                block,
                this.maticClient_,
                this.requestConcurrency
            );
        }).then((receiptProof: any) => {
            const logIndex = this.getLogIndex_(
                logEventSig, receipt
            );
            // step 6 - encode payload, convert into hex
            return this.encodePayload_(
                rootBlockInfo.headerBlockNumber.toNumber(),
                blockProof,
                txBlockNumber,
                block.timestamp,
                Buffer.from(block.transactionsRoot.slice(2), 'hex'),
                Buffer.from(block.receiptsRoot.slice(2), 'hex'),
                ProofUtil.getReceiptBytes(receipt), // rlp encoded
                receiptProof.parentNodes,
                receiptProof.path,
                logIndex
            );
        });
    }

    private encodePayload_(
        headerNumber,
        buildBlockProof,
        blockNumber,
        timestamp,
        transactionsRoot,
        receiptsRoot,
        receipt,
        receiptParentNodes,
        path,
        logIndex
    ) {
        return bufferToHex(
            rlp.encode([
                headerNumber,
                buildBlockProof,
                blockNumber,
                timestamp,
                bufferToHex(transactionsRoot),
                bufferToHex(receiptsRoot),
                bufferToHex(receipt),
                bufferToHex(rlp.encode(receiptParentNodes)),
                bufferToHex(Buffer.concat([Buffer.from('00', 'hex'), path])),
                logIndex,
            ])
        );
    }

    getExitHash(burnTxHash, logEventSig) {
        let lastChildBlock: string,
            receipt: ITransactionReceipt,
            block: IBlockWithTransaction;

        return Promise.all([
            this.rootChain.getLastChildBlock(),
            this.maticClient_.getTransactionReceipt(burnTxHash)
        ]).then(result => {
            lastChildBlock = result[0];
            receipt = result[1];
            return this.maticClient_.getBlockWithTransaction(
                receipt.blockNumber
            );
        }).then(blockResult => {
            block = blockResult;
            if (!this.isCheckPointed_({ lastChildBlock: lastChildBlock, txBlockNumber: receipt.blockNumber })) {
                this.maticClient_.logger.error(ERROR_TYPE.burnTxNotCheckPointed).throw();
            }
            return ProofUtil.getReceiptProof(
                receipt,
                block,
                this.maticClient_,
                this.requestConcurrency
            );
        }).then((receiptProof: any) => {
            const logIndex = this.getLogIndex_(logEventSig, receipt);
            const nibbleArr = [];
            receiptProof.path.forEach(byte => {
                nibbleArr.push(Buffer.from('0' + (byte / 0x10).toString(16), 'hex'));
                nibbleArr.push(Buffer.from('0' + (byte % 0x10).toString(16), 'hex'));
            });

            return this.maticClient_.etheriumSha3(
                receipt.blockNumber, bufferToHex(Buffer.concat(nibbleArr)), logIndex
            );
        });
    }
}