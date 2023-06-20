import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:trinetraflutter/bargraph/bargraph.dart';
import 'package:trinetraflutter/screens/profileScreen.dart';

class DailyStreak extends StatefulWidget {
  const DailyStreak({super.key});

  @override
  State<DailyStreak> createState() => _DailyStreakState();
}

class _DailyStreakState extends State<DailyStreak> {
  final userDetails = FirebaseAuth.instance.currentUser;

  List cal = [10.0, 20.0, 3.0, 8.5, 10.0, 56.0, 92.0];

  Map<String, double> dataMap = {
    "Abs": 32,
    "Quads": 65,
    "Glutes": 29,
    "Chest": 31,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBody: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userInfo')
                    .doc(userDetails!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text("Loading ..."));
                  }
                  var details = snapshot.data;
                  var name = details!['name'] ?? "John";
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text("Hi, $name"),
                          subtitle: const Text("Let's check your activity"),
                          trailing: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/images/male.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25,
                          left: 25,
                          right: 25,
                          bottom: 30,
                        ),
                        child: SizedBox(
                          height: 220,
                          child: BarGraph(weeklySummary: cal),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Divider(thickness: 1.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Today's Data"),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100, top: 25),
                        child: Center(
                          child: PieChart(
                            dataMap: dataMap,
                            chartRadius:
                                MediaQuery.of(context).size.width / 1.8,
                            legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.bottom,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
