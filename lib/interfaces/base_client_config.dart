abstract class IBaseClientConfig {
  final List<String>? network;
  final List<String>? version;
  final IBaseClient? parent;
  final IBaseClient? child;
  final bool? log;
  final num? requestConcurrency;

  const IBaseClientConfig({
    this.network,
    this.version,
    this.parent,
    this.child,
    this.log,
    this.requestConcurrency,
  });
}

class IBaseClient {
  final dynamic provider;
  final IBaseClient defaultConfig;
  const IBaseClient({
    required this.provider,
    required this.defaultConfig,
  });
}

class IBaseClientDefaultConfig {
  final List<String> from;

  const IBaseClientDefaultConfig({this.from = const []});
}
