import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/targets.dart';

class AddAchievementScreen extends StatefulWidget {
  final String id;

  AddAchievementScreen({super.key, required this.id});

  @override
  _AddAchievementScreenState createState() => _AddAchievementScreenState();
}

class _AddAchievementScreenState extends State<AddAchievementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _achievementController = TextEditingController();

  Future<void> saveAchievement() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('achievement').add({
        'title': oneTarget?.title,
        'value': oneTarget?.value,
        'achievement': _achievementController.text,
        'userId': widget.id, // assuming you want to save the user's ID as well
      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getTargets();
  }

  @override
  Widget build(BuildContext context) {
    print('User ID: ${widget.id}');
    return Container(
      height: 400, // Fixed height for the bottom sheet
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use min to fit content size
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Achievement',
                style: Theme.of(context).textTheme.headline6,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 20), // You might want to add some spacing here
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Title '),
                      Spacer(
                        flex: 2,
                      ),
                      Text('${oneTarget?.title}'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Target '),
                      Spacer(
                        flex: 2,
                      ),
                      Text('${oneTarget?.value}'),
                    ],
                  ),

                  SizedBox(height: 10), // Spacing between text fields
                  TextField(
                    controller: _achievementController,
                    decoration: InputDecoration(
                      labelText: 'Achievement',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 20),

                  SizedBox(
                    width: double
                        .infinity, // makes the button stretch to full width
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: saveAchievement),
                  ), // Spacing before the button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Targets? oneTarget;
  late StreamSubscription<DocumentSnapshot> _streamSubscription;
  void getTargets() {
    final reference =
        FirebaseFirestore.instance.collection("targets").doc(widget.id);

    _streamSubscription = reference.snapshots().listen((snapshot) {
      final result =
          snapshot.data() == null ? null : Targets.fromJson(snapshot.data()!);
      print("caseDescription: ${result?.title}");
      setState(() {
        oneTarget = result;

        print("caseDescription: ${result?.title}");
      });
    });
  }
}
