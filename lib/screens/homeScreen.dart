import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goalpulse/screens/targetScreen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../Provider/sign_in_provider.dart';
import '../model/achievement.dart';
import '../provider/next_Screen.dart';
import 'achievementsScreen.dart';
import 'addTargets.dart';
import 'loginScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInitialDataLoaded = false;
  Achievements? selectedAchievement;
  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    //backward navigation disable
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        //appbar
        appBar: AppBar(
          title: Text('Goal Pulse'),
          backgroundColor: HexColor('ff7050'),
          automaticallyImplyLeading:
              false, // This line disables the back button
          actions: [
            IconButton(
              icon: Icon(Icons.login, color: Colors.black),
              onPressed: () {
                sp.userSignOut();
                nextScreenReplace(context, const LoginScreen());
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('achievement')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  var documents = snapshot.data!.docs
                      .map((doc) => Achievements.fromJson(
                          doc.data() as Map<String, dynamic>))
                      .toList();

                  // Initialize or re-validate selectedAchievement
                  if (!isInitialDataLoaded ||
                      selectedAchievement == null ||
                      !documents.contains(selectedAchievement)) {
                    selectedAchievement = documents.first;
                    isInitialDataLoaded = true;
                    // Force a rebuild to propagate the initial selection
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {});
                    });
                  }
// Determine the color of the progress bar based on the ratio
                  Color progressColor =
                      calculateAchievementRatio(selectedAchievement!) >= 1.0
                          ? Colors.green
                          : Colors.redAccent;

                  return Column(
                    children: [
                      //dropdown button
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 20),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: HexColor(
                                  'f4ebeb'), //You can adjust the color to match your screenshot
                              borderRadius: BorderRadius.circular(
                                  30), // Adjust for rounded corners
                            ),
                            child: DropdownButton<Achievements>(
                              value: selectedAchievement,
                              onChanged: (Achievements? newValue) {
                                setState(() {
                                  selectedAchievement = newValue;
                                });
                              },
                              isExpanded: true,
                              icon: const Icon(Icons
                                  .arrow_drop_down), // Adjust icon if needed
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  color: Colors
                                      .deepPurple), // Adjust text style as needed
                              items: documents
                                  .map<DropdownMenuItem<Achievements>>(
                                      (Achievements achievement) {
                                return DropdownMenuItem<Achievements>(
                                  value: achievement,
                                  child: Text(
                                    achievement.title,
                                    style: TextStyle(
                                        color: Colors
                                            .black), // Adjust text color to match your screenshot
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

                      if (selectedAchievement != null) ...[
                        CustomPaint(
                          foregroundPainter: CircleProgress(
                              calculateAchievementRatio(selectedAchievement!),
                              progressColor), // Add the progressColor here
                          child: Container(
                            width: 200,
                            height: 200,
                            alignment: Alignment.center,
                            child: Text(
                              '${(calculateAchievementRatio(selectedAchievement!) * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Target vs Achievement'),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          children: <Widget>[
                            //Target card
                            _buildStatisticCard(
                                'Target',
                                '${selectedAchievement!.value} LKR',
                                Icons.trending_up,
                                Colors.blue),
                            //Achievement card
                            _buildStatisticCard(
                                'Achievement',
                                '${selectedAchievement!.achievement} LKR',
                                Icons.trending_down,
                                Colors.red),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        //bottom navigation bar
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: HexColor('ff7050'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Left tab icon
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.emoji_events,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AchievementScreen(),
                          ),
                        );
                      },
                    ),
                    Text('Achievements',
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
                SizedBox(width: 8), // The dummy placeholder for the FAB
                // Right tab icon and text
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.center_focus_strong),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TargetsScreen(),
                          ),
                        );
                      },
                    ),
                    Text('Targets',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white)), // Adjust the style as needed
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // add new target FloatingActionButton
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => AddTargetScreen(),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  double calculateAchievementRatio(Achievements? achievement) {
    if (achievement == null) return 0.0;
    final value = double.tryParse(achievement.value) ?? 0.0;
    final achievementValue = double.tryParse(achievement.achievement) ?? 0.0;
    return achievementValue / value;
  }

  Widget _buildStatisticCard(
      String title, String value, IconData icon, Color color) {
    bool isAchievementCard = title == 'Achievement';
    bool isAchievementGreaterThanTarget = isAchievementCard &&
        selectedAchievement != null &&
        calculateAchievementRatio(selectedAchievement!) > 1.0;

    // Choose the icon and color based on the condition.
    IconData cardIcon =
        isAchievementGreaterThanTarget ? Icons.trending_up : icon;
    Color cardColor = isAchievementGreaterThanTarget ? Colors.green : color;

    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Icon(cardIcon, color: cardColor),
            SizedBox(height: 10),
            Text(title),
            SizedBox(height: 5),
            Text(value),
          ],
        ),
      ),
    );
  }
}

class CircleProgress extends CustomPainter {
  double currentProgress;
  Color progressColor;

  CircleProgress(this.currentProgress, this.progressColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 10
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 10
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * currentProgress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
