import 'package:flutter/material.dart';
import 'package:goalpulse/screens/loginScreen.dart';
import 'package:goalpulse/screens/targetScreen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../Provider/sign_in_provider.dart';
import '../controller/achievementController.dart';
import '../model/achievement.dart';
import '../provider/next_Screen.dart';
import 'addTargets.dart';
import 'homeScreen.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  // backward navigation function
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
    return false; // Prevents the app from exiting
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    // backward navigation function
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                nextScreenReplace(context, HomeScreen());
                //navigate to home screen
              },
            ),
            title: Text('Achievement ', style: TextStyle(color: Colors.black)),
            backgroundColor: HexColor('ff7050'),
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.login, color: Colors.black),
                onPressed: () {
                  sp.userSignOut();
                  nextScreenReplace(context, LoginScreen());
                },
              )
            ],
          ),
          body: StreamBuilder<List<Achievements>>(
              //Achievements list
              stream: fetchAchievements(), //Achievements retrieve method call
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //until loading show CircularProgressIndicator
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  //if Error show Error message
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  //list view code
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var achievement = snapshot.data![index];
//value convert to int
                      int targetValue = int.tryParse(achievement.value) ?? 0;
                      int achievementValue =
                          int.tryParse(achievement.achievement) ?? 0;
                      Color cardColor = HexColor("f4ebeb");
                      IconData arrowIcon = Icons.arrow_forward;
                      Color arrowColor = Colors.grey;
//check achievementValue < targetValue if true  show red arrow if false show green arrow
                      if (achievementValue < targetValue) {
                        arrowIcon = Icons.trending_down;
                        arrowColor = Colors.red;
                      } else if (achievementValue > targetValue) {
                        arrowIcon = Icons.trending_up;
                        arrowColor = Colors.green;
                      }
//list card
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                achievement.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Target ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.center_focus_strong,
                                            color: Colors.blueAccent,
                                          ),
                                          Text("${achievement.value} LKR",
                                              style: TextStyle(
                                                  color: Colors.black))
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      const Text(
                                        'Achievement ',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            arrowIcon,
                                            color: arrowColor,
                                          ),
                                          Text(
                                            '${achievement.achievement} LKR',
                                            style: TextStyle(color: arrowColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 4),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No achievements found'));
                }
              }),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
                          // Handle "Achievements" tab press
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
                              color:
                                  Colors.white)), // Adjust the style as needed
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
