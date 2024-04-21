import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// saveTargets method
void saveTargets(
    {required String title,
    required String value,
    required BuildContext context}) {
  // Get the title and value from the controllers

  // Firestore operation to save the data
  FirebaseFirestore.instance.collection('targets').add({
    'title': title,
    'value': value,
    'time': Timestamp.fromDate(DateTime.now()), // Saving current time
  }).then((result) {
    // Close the modal bottom sheet
    Navigator.pop(context);
  }).catchError((error) {
    print("Failed to add new target: $error");
  });
}
