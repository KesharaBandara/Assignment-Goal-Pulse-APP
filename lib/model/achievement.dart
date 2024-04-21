//Achievements model class

class Achievements {
  final String id;
  final String title;
  final String value;
  final String achievement;

  Achievements({
    required this.id,
    required this.title,
    required this.achievement,
    required this.value,
  });

  Achievements.fromJson(
    Map<String, dynamic> json,
  ) : this(
          id: json['id'] ?? '',
          title: json['title'] ?? '',
          value: json['value'] ?? '',
          achievement: json['achievement'] ?? '',
        );
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'achievement': achievement,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Achievements &&
        other.id == id &&
        other.title == title &&
        other.value == value &&
        other.achievement == achievement;
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ value.hashCode ^ achievement.hashCode;
}
