class Config {
  final int testLoad;
  final String mediaUri;
  final String uploadUri;
  final String downloadUri;
  final String serverUrl;
  final int specificScenario;

  const Config(this.testLoad, this.mediaUri, this.uploadUri, this.downloadUri,
      this.serverUrl, this.specificScenario);

  @override
  String toString() {
    return 'Config{testLoad: $testLoad, mediaUri: $mediaUri, uploadUri: $uploadUri, downloadUri: $downloadUri, serverUrl: $serverUrl, specificScenario: $specificScenario}';
  }
}
