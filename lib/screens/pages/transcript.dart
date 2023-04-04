import 'package:flutter/material.dart';
import 'package:mobile_project/screens/navbar/hamburger_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TranscriptPage());
  }
}

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  @override
  void initState() {
    super.initState();
    uid = getUid()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transcript"), backgroundColor: Colors.green.shade700),
      drawer: HambergerMenu(),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('enrolls')
                                            .where('uid', isEqualTo: uid)
                                            // .orderBy('term', descending: true)
                                            .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((document) {
                        return Container(
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              semesterHeader(document),
                              transcriptBox(document.id)
                            ],
                          )
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }
            else {
              return Center(child: Text("ไม่พบข้อมูล"));
            }
          },
        )
      ),
    );
  }

  Widget semesterHeader(document) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xcc5ac18e),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${document['term']} ${document['year']}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                FutureBuilder(
                    future: gpaCalculate(document.id),
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          "GPA: ${snapshot.data}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    })
              ],
            ),
          ],
        ));
  }

  Widget transcriptBox(id) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('enrolls').doc(id).collection('enroll_subject').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((document) {
                return Container(
                    child: Column(
                  children: [
                    transcriptList(document),
                  ],
                ));
              }).toList(),
            );
          }
        });
  }

  Widget transcriptList(document) {
    return ListTile(
      title: Text(document["course_id"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(document["name_en"]),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${document["credit"].toString()} credit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 30),
          Text(
            '${document["grade"]}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<double> gpaCalculate(enroll_id) async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('enrolls').doc(enroll_id).collection('enroll_subject').get();
    final List<QueryDocumentSnapshot> enroll_subject = querySnapshot.docs;
    double totalGradePoints = 0.0;
    num totalCreditHours = 0;
    for (final QueryDocumentSnapshot x in enroll_subject) {
      final dynamic data = x.data();
      totalGradePoints += gradePoint(data['grade']) * data['credit'];
      totalCreditHours += data['credit'];
    }
    return totalGradePoints / totalCreditHours;
  }

  String? getUid() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    print(uid);
    return uid;
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
}
