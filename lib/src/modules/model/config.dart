class Config {
  final int testLoad;
  final String mediaUri;
  final String uploadUri;
  final String downloadUri;
  final String serverUrl;
  final int specificScenario;

  const Config(this.testLoad, this.mediaUri, this.uploadUri, this.downloadUri,
      this.serverUrl, this.specificScenario);

  Map<String, dynamic> toJson() {
    return {
      'test_load': testLoad,
      'media_uri': mediaUri,
      'upload_uri': uploadUri,
      'download_uri': downloadUri,
      'server_url': serverUrl,
      'specific_scenario': specificScenario
    };
  }

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      json['test_load'],
      json['media_uri'],
      json['upload_uri'],
      json['download_uri'],
      json['server_url'],
      json['specific_scenario']
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
