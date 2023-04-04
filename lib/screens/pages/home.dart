import 'package:flutter/material.dart';
import 'package:mobile_project/screens/navbar/hamburger_menu.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        backgroundColor: Colors.green.shade700
      ),
      drawer: HambergerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

            ]
          ),
        )
      )
    );
  }
}
