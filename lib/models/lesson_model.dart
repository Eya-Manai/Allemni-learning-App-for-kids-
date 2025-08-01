class LessonModel {
  final String id;
  final String name;
  final String vdUrl;
  final String resumeImagePath;
  final String fileUrl;
  final String vdImage;

  LessonModel({
    required this.id,
    required this.name,
    required this.vdUrl,
    required this.resumeImagePath,
    required this.fileUrl,
    required this.vdImage,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      vdUrl: map['vdUrl'],
      resumeImagePath: map['resumeImagePath'],
      fileUrl: map['fileUrl'],
      vdImage: map['vdImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "vdUrl": vdUrl,
      "resumeImagePath": resumeImagePath,
      "fileUrl": fileUrl,
      "vdImage": vdImage,
    };
  }
}
