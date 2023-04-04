class UploadFile {
  final String name;
  final String url;

  const UploadFile({required this.name, required this.url});

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url};
  }

  factory UploadFile.fromJson(Map<String, dynamic> json) {
    return UploadFile(name: json['name'], url: json['url']);
  }
}
