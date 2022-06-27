

// // Implementation adapted from Tom French's `matic-proofs` library used under MIT License
// // https://github.com/TomAFrench/matic-proofs


// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:dart_numerics/dart_numerics.dart';
// import 'package:ethers/crypto/formatting.dart';
// import 'package:ethers/utils/typed_data.dart';
// import 'package:matic_dart/index.dart';
// import 'package:web3dart/crypto.dart';
// import 'package:web3dart/web3dart.dart';

// class ProofUtil {

//    static Future<List<String>>   getFastMerkleProof(
//       { required MaticWeb3Client web3,
//       required BlockNum  blockNumber,
//       required BlockNum   startBlock,
//        required BlockNum  endBlock}
//     )   async{
//         final merkleTreeDepth = log2(endBlock.blockNum - startBlock.blockNum + 1).ceil();

//         // We generate the proof root down, whereas we need from leaf up
//         var reversedProof = <String>[];

//         final offset = startBlock.blockNum;
//         final targetIndex = blockNumber.blockNum - offset;
//         var leftBound = 0;
//         var rightBound = endBlock.blockNum - offset;
//         //   console.log("Searching for", targetIndex);
//         for (var depth = 0; depth < merkleTreeDepth; depth += 1) {
//             var nLeaves = 2 ^ (merkleTreeDepth - depth);

//             // The pivot leaf is the last leaf which is included in the left subtree
//             final pivotLeaf = leftBound + nLeaves / 2 - 1;

//             if (targetIndex > pivotLeaf) {
//                 // Get the root hash to the merkle subtree to the left
//                 final newLeftBound = pivotLeaf + 1;
//                 // eslint-disable-next-line no-await-in-loop
//                 final subTreeMerkleRoot = await queryRootHash(client:web3, startBlock: BlockNum.exact(offset + leftBound),endBlock:BlockNum.exact((offset + pivotLeaf).toInt(),),);
//                 reversedProof.add(subTreeMerkleRoot);
//                 leftBound = newLeftBound;
//             } else {
//                 // Things are more complex when querying to the right.
//                 // Root hash may come some layers down so we need to build a full tree by padding with zeros
//                 // Some trees may be completely empty

//                 const newRightBound = Math.min(rightBound, pivotLeaf);

//                 // Expect the merkle tree to have a height one less than the current layer
//                 const expectedHeight = merkleTreeDepth - (depth + 1);
//                 if (rightBound <= pivotLeaf) {
//                     // Tree is empty so we repeatedly hash zero to correct height
//                     final subTreeMerkleRoot = recursiveZeroHash(expectedHeight, web3);
//                     reversedProof.add(subTreeMerkleRoot);
//                 } else {
//                     // Height of tree given by RPC node
//                     const subTreeHeight = Math.ceil(Math.log2(rightBound - pivotLeaf));

//                     // Find the difference in height between this and the subtree we want
//                     const heightDifference = expectedHeight - subTreeHeight;

//                     // For every extra layer we need to fill 2*n leaves filled with the merkle root of a zero-filled Merkle tree
//                     // We need to build a tree which has heightDifference layers

//                     // The first leaf will hold the root hash as returned by the RPC
//                     // eslint-disable-next-line no-await-in-loop
//                     const remainingNodesHash = await this.queryRootHash(web3, offset + pivotLeaf + 1, offset + rightBound);

//                     // The remaining leaves will hold the merkle root of a zero-filled tree of height subTreeHeight
//                     const leafRoots = this.recursiveZeroHash(subTreeHeight, web3);

//                     // Build a merkle tree of correct size for the subtree using these merkle roots
//                     const leaves = Array.from({ length: 2 ** heightDifference }, () => toUint8List(leafRoots));
//                     leaves[0] = remainingNodesHash;
//                     const subTreeMerkleRoot = new MerkleTree(leaves).getRoot();
//                     reversedProof.push(subTreeMerkleRoot);
//                 }
//                 rightBound = newRightBound;
//             }
//         }

//         return reversedProof.reverse();
//     }

//     static buildBlockProof(maticWeb3: BaseWeb3Client, startBlock: number, endBlock: number, blockNumber: number) {
//         return ProofUtil.getFastMerkleProof(
//             maticWeb3, blockNumber, startBlock, endBlock
//         ).then(proof => {
//             return Uint8ListToHex(
//                 Uint8List.concat(
//                     proof.map(p => {
//                         return toUint8List(p);
//                     })
//                 )
//             );
//         });
//     }

//     static Future<Uint8List?> queryRootHash({required MaticWeb3Client client,required BlockNum startBlock, required BlockNum endBlock}) async{
//         try {
//           final rootHash = await  client.getRootHash(startBlock:startBlock.toBlockParam(), endBlock: startBlock.toBlockParam());
//             return hexToBytes ('0x$rootHash');
//         } catch (e) {
//           return null;
          
//         }
       
//     }

//     static recursiveZeroHash(num n, MaticWeb3Client client) {
//         if (n == 0) return '0x0000000000000000000000000000000000000000000000000000000000000000';
//        /*  final subHash = recursiveZeroHash(n - 1, client);
//         return keccak256(
//             toUint8List(client.encodeParameters([subHash, subHash], ['bytes32', 'bytes32'],))
//         ); */
//     }

//    /*  static getReceiptProof(receipt: ITransactionReceipt, block: IBlockWithTransaction, web3: BaseWeb3Client, requestConcurrency = Infinity, receiptsVal?: ITransactionReceipt[]) {
//         const stateSyncTxHash = Uint8ListToHex(ProofUtil.getStateSyncTxHash(block));
//         const receiptsTrie = new TRIE();
//         let receiptPromise: Promise<ITransactionReceipt[]>;
//         if (!receiptsVal) {
//             const receiptPromises = [];
//             block.transactions.forEach(tx => {
//                 if (tx.transactionHash == stateSyncTxHash) {
//                     // ignore if tx hash is bor state-sync tx
//                     return;
//                 }
//                 receiptPromises.push(
//                     web3.getTransactionReceipt(tx.transactionHash)
//                 );
//             });
//             receiptPromise = mapPromise(
//                 receiptPromises,
//                 val => {
//                     return val;
//                 },
//                 {
//                     concurrency: requestConcurrency,
//                 }
//             );
//         }
//         else {
//             receiptPromise = promiseResolve(receiptsVal);
//         }

//         return receiptPromise.then(receipts => {
//             return Promise.all(
//                 receipts.map(siblingReceipt => {
//                     const path = rlp.encode(siblingReceipt.transactionIndex);
//                     const rawReceipt = ProofUtil.getReceiptBytes(siblingReceipt);
//                     return receiptsTrie.put(path, rawReceipt);
//                 })
//             );
//         }).then(_ => {
//             return receiptsTrie.findPath(rlp.encode(receipt.transactionIndex), true);
//         }).then(result => {
//             if (result.remaining.length > 0) {
//                 throw new Error('Node does not contain the key');
//             }
//             // result.node.value
//             const prf = {
//                 blockHash: toUint8List(receipt.blockHash),
//                 parentNodes: result.stack.map(s => s.raw()),
//                 root: ProofUtil.getRawHeader(block).receiptTrie,
//                 path: rlp.encode(receipt.transactionIndex),
//                 value: ProofUtil.isTypedReceipt(receipt) ? result.node.value : rlp.decode(result.node.value)
//             };
//             return prf;
//         });
//     }
//  */
  
//     // getStateSyncTxHash returns block's tx hash for state-sync receipt
//     // Bor blockchain includes extra receipt/tx for state-sync logs,
//     // but it is not included in transactionRoot or receiptRoot.
//     // So, while calculating proof, we have to exclude them.
//     //
//     // This is derived from block's hash and number
//     // state-sync tx hash = keccak256("matic-bor-receipt-" + block.number + block.hash)
//     static Uint8List getStateSyncTxHash(block) {
//         return keccak256(
//             uint8ListFromList([
//                 // prefix for bor receipt
//                ...utf8.encode('matic-bor-receipt-'),
//                 setLengthLeft(toUint8List(block.number), 8), // 8 bytes of block number (BigEndian)
//                 toUint8List(block.hash), // block hash
//             ])
//         );
//     }

//     static getReceiptBytes(receipt: ITransactionReceipt) {
//         let encodedData = rlp.encode([
//             toUint8List(
//                 receipt.status !== undefined && receipt.status != null ? (receipt.status ? '0x1' : '0x') : receipt.root
//             ),
//             toUint8List(receipt.cumulativeGasUsed),
//             toUint8List(receipt.logsBloom),
//             // encoded log array
//             receipt.logs.map(l => {
//                 // [address, [topics array], data]
//                 return [
//                     toUint8List(l.address), // convert address to Uint8List
//                     l.topics.map(toUint8List), // convert topics to Uint8List
//                     toUint8List(l.data), // convert data to Uint8List
//                 ];
//             }),
//         ]);
//         if (ProofUtil.isTypedReceipt(receipt)) {
//             encodedData = Uint8List.concat([toUint8List(receipt.type), encodedData]);
//         }
//         return encodedData;
//     }

//     static getRawHeader(_block) {
//         _block.difficulty = Converter.toHex(_block.difficulty) as any;
//         const common = new Common({
//             chain: Chain.Mainnet, hardfork: Hardfork.London
//         });
//         const rawHeader = BlockHeader.fromHeaderData(_block, {
//             common: common
//         });
//         return rawHeader;
//     }
// }
