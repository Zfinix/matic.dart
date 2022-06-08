enum ERROR_TYPE<T extends Object> {
  allowedOnRoot<String>("allowed_on_root"),

  allowedOnChild<String>("allowed_on_child"),

  unknown<String>("unknown"),

  proofAPINotSet<String>("proof_api_not_set"),

  transactionOptionNotObject<String>("transation_object_not_object"),

  burnTxNotCheckPointed<String>("burn_tx_not_checkpointed"),

  eIP1559NotSupported<String>("eip-1559_not_supported"),

  nullSpenderAddress<String>("null_spender_address");

  const ERROR_TYPE(this.value);
  final T value;

  @override
  String toString() => value.toString();
}