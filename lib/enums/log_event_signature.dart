enum LogEventSignature<T extends Object> {
  Erc20Transfer<String>(
      "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"),

  Erc721Transfer<String>(
      "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"),

  Erc1155Transfer<String>(
      "0xc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62"),

  Erc721BatchTransfer<String>(
      "0xf871896b17e9cb7a64941c62c188a4f5c621b86800e3d15452ece01ce56073df"),

  Erc1155BatchTransfer<String>(
      "0x4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb"),

  Erc721TransferWithMetadata<String>(
      "0xf94915c6d1fd521cee85359239227480c7e8776d7caf1fc3bacad5c269b66a14");

  const LogEventSignature(this.value);
  final T value;

  @override
  String toString() => value.toString();
}
