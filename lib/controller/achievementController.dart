import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/achievement.dart';

//Achievements retrieve method
@override
Stream<List<Achievements>> fetchAchievements() {
  final adsRef = FirebaseFirestore.instance
      .collection('achievement') //Achievements retrieve database path
      .withConverter<Achievements>(
        fromFirestore: (snapshot, _) => Achievements.fromJson(snapshot.data()!),
        toFirestore: (achievements, _) => achievements.toJson(),
      );

  return adsRef.snapshots().map(mapRecords);
}

List<Achievements> mapRecords(QuerySnapshot<Achievements> records) {
  var list = records.docs
      .map(
        (achievements) => Achievements(
          id: achievements.id,
          title: achievements['title'] ?? '',
          value: achievements['value'] ?? '',
          achievement: achievements['achievement'] ?? '',
        ),
      )
      .toList();
  return list;
}
