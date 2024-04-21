import 'package:cloud_firestore/cloud_firestore.dart';

//Targets model class
class Targets {
  final String id;
  final String title;
  final String value;
  final DateTime? time;
  Targets({
    required this.id,
    required this.title,
    required this.value,
    required this.time,
  });

  Targets.fromJson(
    Map<String, dynamic> json,
  ) : this(
          id: json['id'] ?? '',
          title: json['title'] ?? '',
          value: json['value'] ?? '',
          time: json['time'] != null
              ? (json['time'] as Timestamp).toDate()
              : null,
        );
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
    };
  }
}
