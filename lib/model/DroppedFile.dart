class DroppedFile{
  final String url;
  final String fileName;
  final String mime;
  final int bytes;
  final dynamic fileData;

  const DroppedFile({
    required this.url,
    required this.fileName,
    required this.mime,
    required this.bytes,
    required this.fileData,
  });

  String get size{
    final kb = bytes / 1024;
    final mb = kb / 1024;
    return mb > 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
  }

}