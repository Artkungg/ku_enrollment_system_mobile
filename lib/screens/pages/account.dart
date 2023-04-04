import 'package:flutter/material.dart';
import 'package:mobile_project/screens/navbar/hamburger_menu.dart';
import 'package:mobile_project/screens/pages/activity.dart';
import 'package:mobile_project/screens/pages/news.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home",
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _selectedEvent = 0;
  List<Widget> _pages = [NewsScreen(), ActivityScreen()];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: HambergerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              userImage(size),
              userInfo(),
              userMenu(size),
              SizedBox(height: 20),
              _pages[_selectedEvent],
            ]
          ),
        )
      ),
    );
  }

  Widget userImage(size) {
    return Stack(
      children: [
        Container(
          width: size.width,
          height: 200,
          color: Colors.transparent,
          padding: EdgeInsets.only(bottom: 150 / 2.2),
          child: Container(
            width: size.width,
            height: 150,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.elliptical(10, 10), bottomRight: Radius.elliptical(10, 10)),
              color: Colors.green.shade700
            ),
          ),
        ),
        Positioned(
          top: 180 / 2,
          left: size.width / 2.6,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle),
            child: CircleAvatar(
                backgroundColor: Colors.transparent, backgroundImage: AssetImage('assets/images/avatar.png')),
          ),
        ),
      ],
    );
  }

  Widget userInfo(){
    return Container(
      child: ListTile(
        title: Row(
          children: [
            Text(
              "Art Itthipon",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22),
            ),
            SizedBox(width: 8),
          ],
        ),
        subtitle: Column(
          children: [
            SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.grey.shade400,
                  ),
                  Text(
                    "Bangkhen, Bangkok",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.grey.shade400,
                  ),
                  Text(
                    "Male",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userMenu(size){
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: size.width / 1.8,
              padding: EdgeInsets.all(8),
              child: MaterialButton(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green)),
                color:
                    _selectedEvent == 0 ? Colors.green : Colors.white,
                onPressed: () {
                  setState(() {
                    _selectedEvent = 0;
                  });
                },
                child: Text("News",
                    style: TextStyle(
                      color: _selectedEvent == 0
                          ? Colors.white
                          : Colors.green,
                    )),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: size.width / 1.8,
              padding: EdgeInsets.all(8),
              child: MaterialButton(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green)),
                color:
                    _selectedEvent == 1 ? Colors.green : Colors.white,
                onPressed: () {
                  setState(() {
                    _selectedEvent = 1;
                  });
                },
                child: Text("Activity transcript",
                    style: TextStyle(
                      color: _selectedEvent == 1
                          ? Colors.white
                          : Colors.green,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
