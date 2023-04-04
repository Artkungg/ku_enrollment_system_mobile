import 'package:flutter/material.dart';
import 'package:mobile_project/screens/pages/statistic.dart';
import 'package:mobile_project/screens/pages/transcript.dart';
import '../pages/home.dart';
import '../authenticate/login.dart';
import 'package:mobile_project/screens/pages/account.dart';
import 'package:mobile_project/screens/pages/enroll.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HambergerMenu extends StatefulWidget {
  const HambergerMenu({super.key});

  @override
  State<HambergerMenu> createState() => _HambergerMenuState();
}

class _HambergerMenuState extends State<HambergerMenu> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  @override
  void initState(){
    super.initState();
    uid = getUid()!;
  }

  String? getUid() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff5ac18e)
            ),
            child: Column()
          ),
          // HomeScreen(context),
          EnrollScreen(context),
          TranscriptScreen(context),
          StatisticScreen(context),
          AccountScreen(context),
          Logout(context),
        ],
      ),
    );
  }

  Widget HomeScreen(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.home,
          color: Colors.black,
        ),
        title: Text("HomePage"),
        onTap: () => _navPush(context, Home()));
  }

  Widget EnrollScreen(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.menu_book,
          color: Colors.black,
        ),
        title: Text("Enroll"),
        onTap: () => _navPush(context, EnrollPage()));
  }

  Widget TranscriptScreen(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.school,
          color: Colors.black,
        ),
        title: Text("Transcript"),
        onTap: () => _navPush(context, TranscriptPage())
    );
  }

  Widget StatisticScreen(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.bar_chart,
          color: Colors.black,
        ),
        title: Text("Statistic"),
        onTap: () => _navPush(context, StatisticPage())
    );
  }

  Widget AccountScreen(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: Text("Account"),
        onTap: () => _navPush(context, AccountPage()));
  }

  Widget Logout(BuildContext context){
    return ListTile(
      leading: Icon(
        Icons.logout,
        color: Colors.black,
      ),
      title: Text("Logout"),
      onTap: () async {
        await FirebaseAuth.instance.signOut().then((value) => _navPush(context, LoginPage()));
      },
    );
  }

  Future<dynamic> _navPush(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      )
    );
  }
}