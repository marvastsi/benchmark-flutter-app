class Config {
  final int testLoad;
  final String mediaUri;
  final String uploadUri;
  final String downloadUri;
  final String serverUrl;
  final int specificScenario;

  const Config(this.testLoad, this.mediaUri, this.uploadUri, this.downloadUri,
      this.serverUrl, this.specificScenario);
}
