import { Web3SideChainClient } from "./web3_side_chain_client";
import { ITransactionRequestConfig, ITransactionOption, IContractInitParam, IPOSClientConfig, IBaseClientConfig, ITransactionWriteResult } from "../interfaces";
import { BaseContractMethod, BaseContract, BaseWeb3Client } from "../abstracts";
import { Converter, merge } from ".";
import { promiseResolve } from "./promise_resolve";
import { ERROR_TYPE } from "../enums";
import { POSERC1155TransferParam, TYPE_AMOUNT } from "../types";
import { ErrorHelper } from "./error_helper";

export interface ITransactionConfigParam {
    txConfig: ITransactionRequestConfig;
    method?: BaseContractMethod;
    isWrite?: boolean;
    isParent?: boolean;
}

export class BaseToken<T_CLIENT_CONFIG> {

    private contract_: BaseContract;

    constructor(
        protected contractParam: IContractInitParam,
        protected client: Web3SideChainClient<T_CLIENT_CONFIG>,
    ) {
    }


    getContract(): Promise<BaseContract> {
        if (this.contract_) {
            return promiseResolve<BaseContract>(this.contract_ as any);
        }
        const contractParam = this.contractParam;
        return this.client.getABI(
            contractParam.name,
            contractParam.bridgeType,
        ).then(abi => {
            this.contract_ = this.getContract_({
                abi,
                isParent: contractParam.isParent,
                tokenAddress: contractParam.address
            });
            return this.contract_;
        });
    }

    protected processWrite(method: BaseContractMethod, option: ITransactionOption = {}): Promise<ITransactionWriteResult> {
        this.validateTxOption_(option);

        this.client.logger.log("process write");
        return this.createTransactionConfig(
            {
                txConfig: option,
                isWrite: true,
                method,
                isParent: this.contractParam.isParent
            }).then(config => {
                this.client.logger.log("process write config");
                if (option.returnTransaction) {
                    return merge(config, {
                        data: method.encodeABI(),
                        to: method.address
                    } as ITransactionRequestConfig);
                }
                const methodResult = method.write(
                    config,
                );
                return methodResult;
            });
    }

    protected sendTransaction(option: ITransactionOption = {}): Promise<ITransactionWriteResult> {
        this.validateTxOption_(option);

        const isParent = this.contractParam.isParent;
        const client = this.getClient(isParent);
        client.logger.log("process write");

        return this.createTransactionConfig(
            {
                txConfig: option,
                isWrite: true,
                method: null as any,
                isParent: this.contractParam.isParent
            }).then(config => {
                client.logger.log("process write config");
                if (option.returnTransaction) {
                    return config as any;
                }
                const methodResult = client.write(
                    config,
                );
                return methodResult;
            });
    }

    protected readTransaction(option: ITransactionOption = {}): Promise<ITransactionWriteResult> {
        this.validateTxOption_(option);
        const isParent = this.contractParam.isParent;
        const client = this.getClient(isParent);
        client.logger.log("process read");
        return this.createTransactionConfig(
            {
                txConfig: option,
                isWrite: true,
                method: null as any,
                isParent: this.contractParam.isParent
            }).then(config => {
                client.logger.log("write tx config created");
                if (option.returnTransaction) {
                    return config as any;
                }
                return client.read(
                    config,
                );
            });
    }

    private validateTxOption_(option: ITransactionOption) {
        if (typeof option !== 'object' || Array.isArray(option)) {
            new ErrorHelper(ERROR_TYPE.transactionOptionNotObject).throw();
        }
    }

    protected processRead<T>(method: BaseContractMethod, option: ITransactionOption = {}): Promise<T> {
        this.validateTxOption_(option);
        this.client.logger.log("process read");
        return this.createTransactionConfig(
            {
                txConfig: option,
                isWrite: false,
                method,
                isParent: this.contractParam.isParent
            }).then(config => {
                this.client.logger.log("read tx config created");
                if (option.returnTransaction) {
                    return merge(config, {
                        data: method.encodeABI(),
                        to: this.contract_.address
                    } as ITransactionRequestConfig);
                }
                return method.read(
                    config,
                );
            });
    }

    protected getClient(isParent) {
        return isParent ? this.client.parent :
            this.client.child;
    }

    private getContract_({ isParent, tokenAddress, abi }) {
        const client = this.getClient(isParent);
        return client.getContract(tokenAddress, abi);
    }

    protected get parentDefaultConfig() {
        const config: IBaseClientConfig = this.client.config as any;
        return config.parent.defaultConfig;
    }

    protected get childDefaultConfig() {
        const config: IBaseClientConfig = this.client.config as any;
        return config.child.defaultConfig;
    }

    protected createTransactionConfig({ txConfig, method, isParent, isWrite }: ITransactionConfigParam) {
        const defaultConfig = isParent ? this.parentDefaultConfig : this.childDefaultConfig;
        txConfig = merge(defaultConfig, (txConfig || {}));
        const client = isParent ? this.client.parent :
            this.client.child;
        client.logger.log("txConfig", txConfig, "onRoot", isParent, "isWrite", isWrite);
        const estimateGas = (config: ITransactionRequestConfig) => {
            return method ? method.estimateGas(config) :
                client.estimateGas(config);
        };
        // txConfig.chainId = Converter.toHex(txConfig.chainId) as any;
        if (isWrite) {
            const { maxFeePerGas, maxPriorityFeePerGas } = txConfig;
            const isEIP1559Supported = this.client.isEIP1559Supported(isParent);
            const isMaxFeeProvided = (maxFeePerGas || maxPriorityFeePerGas);

            if (!isEIP1559Supported && isMaxFeeProvided) {
                client.logger.error(ERROR_TYPE.eIP1559NotSupported, isParent).throw();
            }
            // const [gasLimit, nonce, chainId] = 
            return Promise.all([
                !(txConfig.gasLimit)
                    ? estimateGas({
                        from: txConfig.from, value: txConfig.value
                    })
                    : txConfig.gasLimit,
                !txConfig.nonce ?
                    client.getTransactionCount(txConfig.from, 'pending')
                    : txConfig.nonce,
                !txConfig.chainId ?
                    client.getChainId() : txConfig.chainId
            ]).then(result => {
                const [gasLimit, nonce, chainId] = result;
                client.logger.log("options filled");

                txConfig.gasLimit = Number(gasLimit);
                txConfig.nonce = nonce;
                txConfig.chainId = chainId;
                return txConfig;
            });
        }
        return promiseResolve<ITransactionRequestConfig>(txConfig);
    }

    protected transferERC20(to: string, amount: TYPE_AMOUNT, option?: ITransactionOption) {
        return this.getContract().then(contract => {
            const method = contract.method(
                "transfer",
                to,
                Converter.toHex(amount)
            );
            return this.processWrite(
                method, option
            );
        });
    }

    protected transferERC721(from: string, to: string, tokenId: string, option: ITransactionOption) {
        return this.getContract().then(contract => {
            const method = contract.method(
                "transferFrom",
                from,
                to,
                tokenId
            );
            return this.processWrite(
                method, option
            );
        });
    }

    protected checkForRoot(methodName) {
        if (!this.contractParam.isParent) {
            this.client.logger.error(ERROR_TYPE.allowedOnRoot, methodName).throw();
        }
    }

    protected checkForChild(methodName) {
        if (this.contractParam.isParent) {
            this.client.logger.error(ERROR_TYPE.allowedOnRoot, methodName).throw();
        }
    }

    protected transferERC1155(param: POSERC1155TransferParam, option: ITransactionOption) {
        return this.getContract().then(contract => {
            const method = contract.method(
                "safeTransferFrom",
                param.from,
                param.to,
                Converter.toHex(param.tokenId),
                Converter.toHex(param.amount),
                param.data || '0x'
            );
            return this.processWrite(
                method, option
            );
        });
    }

}