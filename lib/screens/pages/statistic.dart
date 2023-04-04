import 'package:flutter/material.dart';
import 'package:mobile_project/screens/navbar/hamburger_menu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Statistic", home: StatisticPage());
  }
}

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {

  List<String> subjectType = ["Wellness", "Entrepreneurship", "Foreign Language"];
  double all_credit = 0;
  double gpa = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  @override
  void initState(){
    super.initState();
    uid = getUid()!;
    gpaCalculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Statistic"), backgroundColor: Colors.green.shade700),
      drawer: HambergerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 50),
                summaryCreditAndGPABox(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: subjectType.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: 40),
                        FutureBuilder<double>(
                          future: calCreditType(subjectType[index]),
                          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                return sumCreditBox(subjectType[index], snapshot.data);
                              } else {
                                return Text('No data');
                              }
                            } else {
                              return Center();
                              // return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    );
                  }
                )
              ],
            ),
          ),
        ),
      )
    );
  }


  Widget sumCreditBox(subjectType, credit) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${subjectType}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            creditChart(subjectType, credit, 6.0)
          ],
        ),
      ),
    );
  }

  Widget creditChart(subjectType, credit, maxCredit) {
    List<_ChartData> chartData = [_ChartData(subjectType, credit.round(), Colors.green.shade700, maxCredit)];
    return Container(
      width: 100,
      height: 200,
      child: SfCircularChart(
        series: <CircularSeries<_ChartData, String>>[
          RadialBarSeries<_ChartData, String>(
            maximumValue: chartData[0].maxCredit,
            dataSource: chartData,
            xValueMapper: (_ChartData data, _) => data.subject_type,
            yValueMapper: (_ChartData data, _) => data.credit,
            pointColorMapper: (_ChartData data, _) {
              return data.color;
            },
            animationDuration: 1000,
            trackColor: Color(0xFFFF0000),
            cornerStyle: CornerStyle.bothCurve,
            radius: '100%',
            innerRadius: '60%',
            dataLabelSettings: DataLabelSettings(
                isVisible: true, color: Colors.black87, labelPosition: ChartDataLabelPosition.outside),
          )
        ]
      )
    );
  }

  Future<double> calCreditType(type) async {
    double creditType = 0;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('enrolls').where('uid', isEqualTo: uid).get();
    final List<QueryDocumentSnapshot> enroll_subject = querySnapshot.docs;
    for (final QueryDocumentSnapshot x in enroll_subject) {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('enrolls').doc(x.id).collection('enroll_subject').get();
      final List<QueryDocumentSnapshot> res = querySnapshot.docs;
      for (final QueryDocumentSnapshot y in res) {
        final dynamic data = y.data();
        if (data['type'] == type && data['grade'] != '-') {
          creditType += data['credit'];
        }
      }
    }    
    return creditType;
  }

  void gpaCalculate() async {
    double totalGradePoints = 0;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('enrolls').where('uid', isEqualTo: uid).get();
    final List<QueryDocumentSnapshot> test = querySnapshot.docs;
    for(final QueryDocumentSnapshot x in test){
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('enrolls').doc(x.id).collection('enroll_subject').get();
      final List<QueryDocumentSnapshot> enroll_subject = querySnapshot.docs;
      for(final QueryDocumentSnapshot y in enroll_subject){
        final dynamic data = y.data();
        if(data['grade'] != '-'){
          setState(() {
            all_credit += data['credit'];
          });
          totalGradePoints += gradePoint(data['grade']) * data['credit'];
        }
      }
    }
    if(all_credit > 0){
      setState(() {
        gpa = totalGradePoints / all_credit;
      });
    }    
  }

  double gradePoint(grade) {
    if (grade == 'A') {
      return 4.0;
    } else if (grade == 'B+') {
      return 3.5;
    } else if (grade == 'B') {
      return 3.0;
    } else if (grade == 'C+') {
      return 2.5;
    } else if (grade == 'C') {
      return 2.0;
    } else if (grade == 'D+') {
      return 1.5;
    } else if (grade == 'D') {
      return 1.0;
    } else {
      return 0.0;
    }
  }

  String? getUid() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return uid;
  }

  Widget summaryCreditAndGPABox(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(5, 5),
          ),
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Credit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${all_credit}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(width: 60),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'GPA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${gpa}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  late Color color;
  late int credit;
  late String subject_type;
  late double maxCredit;

  _ChartData(this.subject_type, this.credit, this.color, this.maxCredit);
}
