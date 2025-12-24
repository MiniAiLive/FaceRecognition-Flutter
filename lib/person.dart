import 'dart:typed_data';

class Person {
  final String name;
  final Uint8List faceJpg;
  final Uint8List templates;

  const Person({
    required this.name,
    required this.faceJpg,
    required this.templates,
  });

  factory Person.fromMap(Map<String, dynamic> json) {
    return Person(
      name: json["name"],
      faceJpg: json["faceJpg"],
      templates: json["templates"],
    );
  }

  Map<String, Object?> toMap() {
    return {
      "name": name,
      "faceJpg": faceJpg,
      "templates": templates,
    };
  }
}
