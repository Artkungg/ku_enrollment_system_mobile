import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/screens/authenticate/login.dart';
import 'package:mobile_project/screens/pages/account.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyAppPage());
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';

  String getUid() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    if(uid == null){
      return "Logout";
    }
    return uid;
  }

  @override
  void initState(){
    super.initState();
    uid = getUid();
  }
  @override
  Widget build(BuildContext context) {
    if(uid == "Logout"){
      return Scaffold(
        body: LoginPage(),
      );
    }
    else{
      return Scaffold(
        // body: page[_selectedIndex],
        // bottomNavigationBar: bottom_nav()
        body: AccountPage(),
      );
    }
  }

  // Widget bottom_nav() {
  //   return BottomNavigationBar(
  //     selectedItemColor: Color(0xFF345832),
  //     currentIndex: _selectedIndex,
  //     onTap: _onItemTapped,
  //     items: <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.home),
  //         label: "Home",
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.menu_book),
  //         label: "Register",
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.school),
  //         label: "Account",
  //       ),
  //     ],
  //   );
  // }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
}
