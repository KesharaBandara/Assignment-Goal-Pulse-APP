import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/targets.dart';

@override
Stream<List<Targets>> fetchTargets() {
  final adsRef =
      FirebaseFirestore.instance.collection('targets').withConverter<Targets>(
            fromFirestore: (snapshot, _) => Targets.fromJson(snapshot.data()!),
            toFirestore: (targets, _) => targets.toJson(),
          );

  return adsRef.snapshots().map(mapRecords);
}

List<Targets> mapRecords(QuerySnapshot<Targets> records) {
  var list = records.docs
      .map(
        (targets) => Targets(
          id: targets.id,
          title: targets['title'] ?? '',
          value: targets['value'] ?? '',
          time: targets['time'] != null
              ? (targets['time'] as Timestamp).toDate()
              : null,
        ),
      )
      .toList();
  return list;
}
