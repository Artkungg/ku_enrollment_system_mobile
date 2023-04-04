import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import '../Navbar/hamburger_menu.dart';

class Enroll extends StatelessWidget {
  const Enroll({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Enroll",
      home: EnrollPage(),
    );
  }
}

class EnrollPage extends StatefulWidget {
  const EnrollPage({super.key});

  @override
  State<EnrollPage> createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  String search = '';
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _enrollCollection = FirebaseFirestore.instance.collection("enrolls");
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  String? getUid() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return uid;
  }

  @override
  void initState(){
    super.initState();
    uid = getUid()!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error"), backgroundColor: Colors.green.shade700),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("Enroll"), backgroundColor: Colors.green.shade700),
            drawer: HambergerMenu(),
            body: SingleChildScrollView(
              child: Container(
                child: Column(children: [
                  SizedBox(height: 40),
                  searchSubject(),
                  SizedBox(height: 20),
                  Text('List subject'),
                  SizedBox(height: 20),
                  // Expanded(
                  //     child: ListView.builder(
                  //         itemCount: subjects.length,
                  //         itemBuilder: (context, index) {
                  //           return subjectBox(index, subjects[index].data());
                  //         })),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
                    builder:  (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator()
                        );
                      }
                      else{
                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data!.docs.map((document) {
                            return Column(
                              children: [
                                subjectBox(document),
                              ],
                            );
                          }).toList()
                        );
                      }
                    }
                  )
                ]),
              ),
            ),
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget searchSubject() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Search subject',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
          hintText: 'Subject ID, Subject name',
        ),
        keyboardType: TextInputType.text,
        onChanged: (String? value) {
          setState(() {
            search = value.toString();
          });
        },
      ),
    );
  }

  Widget subjectBox(subject) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.2), spreadRadius: 5, blurRadius: 7, offset: Offset(5, 5))],
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ExpandablePanel(
              header: Row(
                children: [
                  Text("${subject['name_en']}", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Color(0xFF73BEDB)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.5),
                      child: Text("${subject['type']}", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
              collapsed: Text("${subject['credit']} credit", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis),
              expanded: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("section: 1", softWrap: true),
                  enrollSubjectButton(subject)
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(15)
                  //     ),
                  //     backgroundColor: Color(0xff5ac18e)
                  //   ),
                  //   onPressed: () async {
                  //     // EnrollSubject(subject);
                  //     QuerySnapshot _existingEnrollTerm = await _enrollCollection
                  //       .where('term', isEqualTo: subject['term'])
                  //       .where('year', isEqualTo: subject['year'])
                  //       .get();
                  //     if(_existingEnrollTerm.docs.isEmpty){
                  //       await _enrollCollection.add({
                  //         "term": subject['term'],
                  //         "year": subject['year'],
                  //       }).then((value) {
                  //         CollectionReference _subjectCollection = FirebaseFirestore.instance
                  //           .collection("enrolls")
                  //           .doc(value.id)
                  //           .collection("enroll_subject");
                  //           _subjectCollection.add({
                  //             "course_id": subject['course_id'],
                  //             "name_en": subject['name_en'],
                  //             "name_th": subject['name_th'],
                  //             "credit": subject['credit'],
                  //             "grade": "-",
                  //             "type": subject['type'],
                  //             "prof_name": subject['prof_name']
                  //           });
                  //       }).then((value) => enrollSuccess());
                  //     }
                  //     else{
                  //       print("not create new");
                  //       final documentId = _existingEnrollTerm.docs[0].id;
                  //       CollectionReference _subjectCollection = FirebaseFirestore.instance
                  //         .collection("enrolls")
                  //         .doc(documentId)
                  //         .collection("enroll_subject");
                  //       _subjectCollection.add({
                  //         "course_id": subject['course_id'],
                  //         "name_en": subject['name_en'],
                  //         "name_th": subject['name_th'],
                  //         "credit": subject['credit'],
                  //         "grade": "-",
                  //         "type": subject['type'],
                  //         "prof_name": subject['prof_name']
                  //       }).then((value) => enrollSuccess());
                  //     }
                  //   },
                  //   child: Text('Enroll', style: TextStyle(fontWeight: FontWeight.bold),),
                  // ),
                ],
              )),
        ),
      ),
    );
  }

  Future enrollSuccess() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enrollment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You have successfully enrolled in the subject.'),
              SizedBox(height: 16),
              Icon(Icons.check_circle, color: Colors.green, size: 48),
            ],
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          elevation: 5,
        );
      },
    );
  }

  Widget enrollSubjectButton(subject) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          backgroundColor: Color(0xff5ac18e)
        ),
        onPressed: () async {
          QuerySnapshot _existingEnrollTerm = await _enrollCollection
            .where('term', isEqualTo: subject['term'])
            .where('year', isEqualTo: subject['year'])
            .get();
          if(_existingEnrollTerm.docs.isEmpty){
            await _enrollCollection.add({
              "term": subject['term'],
              "year": subject['year'],
            }).then((value) {
              CollectionReference _subjectCollection = FirebaseFirestore.instance
                .collection("enrolls")
                .doc(value.id)
                .collection("enroll_subject");
                _subjectCollection.add({
                  "course_id": subject['course_id'],
                  "name_en": subject['name_en'],
                  "name_th": subject['name_th'],
                  "credit": subject['credit'],
                  "grade": "-",
                  "type": subject['type'],
                  "prof_name": subject['prof_name']
                });
            }).then((value) => enrollSuccess());
          }
          else{
            final documentId = _existingEnrollTerm.docs[0].id;
            CollectionReference _subjectCollection = FirebaseFirestore.instance
              .collection("enrolls")
              .doc(documentId)
              .collection("enroll_subject");
            _subjectCollection.add({
              "course_id": subject['course_id'],
              "name_en": subject['name_en'],
              "name_th": subject['name_th'],
              "credit": subject['credit'],
              "grade": "-",
              "type": subject['type'],
              "prof_name": subject['prof_name']
            }).then((value) => enrollSuccess());
          }
        },
        child: Text('Enroll', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }
}
