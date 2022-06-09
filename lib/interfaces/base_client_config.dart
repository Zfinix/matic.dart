class IBaseClientConfig {
  final List<String>? network;
  final List<String>? version;
  final bool? log;
  final num? requestConcurrency;
  IBaseClient? parent;
  IBaseClient? child;

  IBaseClientConfig({
    this.network,
    this.version,
    this.parent,
    this.child,
    this.log,
    this.requestConcurrency,
  });

  IBaseClientConfig copyWith({
    List<String>? network,
    List<String>? version,
    IBaseClient? parent,
    IBaseClient? child,
    bool? log,
    num? requestConcurrency,
  }) {
    return IBaseClientConfig(
      network: network ?? this.network,
      version: version ?? this.version,
      parent: parent ?? this.parent,
      child: child ?? this.child,
      log: log ?? this.log,
      requestConcurrency: requestConcurrency ?? this.requestConcurrency,
    );
  }
}

class IBaseClient {
  dynamic provider;
  IBaseClient defaultConfig;
  IBaseClient({
    required this.provider,
    required this.defaultConfig,
  });

  IBaseClient copyWith({
    dynamic provider,
    IBaseClient? defaultConfig,
  }) {
    return IBaseClient(
      provider: provider ?? this.provider,
      defaultConfig: defaultConfig ?? this.defaultConfig,
    );
  }
}

class IBaseClientDefaultConfig {
  final List<String> from;

  const IBaseClientDefaultConfig({this.from = const []});
}
