import 'package:flutter/material.dart';
import 'package:goalpulse/screens/achievementsScreen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Provider/sign_in_provider.dart';
import '../controller/targetController.dart';
import '../model/targets.dart';
import '../provider/next_Screen.dart';
import 'addAchievement.dart';
import 'addTargets.dart';
import 'homeScreen.dart';
import 'loginScreen.dart';

class TargetsScreen extends StatefulWidget {
  const TargetsScreen({super.key});
  @override
  State<TargetsScreen> createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> {
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              nextScreenReplace(context, HomeScreen());
            },
          ),
          title: Text('Targets', style: TextStyle(color: Colors.black)),
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
        body: StreamBuilder<List<Targets>>(
            //Targets list
            stream: fetchTargets(), //Targets retrieve method call
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                //until loading show CircularProgressIndicator
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                //if  Error show Error message
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                //list view code
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var target = snapshot.data![index];
                    return Card(
                      color: HexColor('f4ebeb'),
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${target.title}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  Spacer(flex: 2),
                                                  Icon(Icons
                                                      .more_horiz)
                                                ],
                                              ),
                                              SizedBox(height: 4.0),
                                              Text(
                                                '${target.value} LKR',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .green, // Use the color of your choice
                                                ),
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder: (_) =>
                                                        AddAchievementScreen(
                                                            id: target.id),
                                                  );
                                                },
                                                child: const Text(
                                                  'Achievement',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 8, right: 18),
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      '${target.time != null ? DateFormat('yyyy-MM-dd | kk:mm a').format(target.time!) : 'No date'}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('No targets found'));
              }
            }),
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
        //add targets  FloatingActionButton
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
}
