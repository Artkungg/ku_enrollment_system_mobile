import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mobile_project/screens/authenticate/register.dart';
import 'package:mobile_project/model/profile.dart';
import 'package:mobile_project/screens/pages/account.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
              ),
            body: Center(child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Color(0x665ac18e),
                  Color(0x995ac18e),
                  Color(0xcc5ac18e),
                  Color(0xff5ac18e),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 120
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold)),
                        SizedBox(height: 50),
                        emailField(),
                        SizedBox(height: 20),
                        passwordField(),
                        SizedBox(height: 20),
                        loginButton(),
                        SizedBox(height: 25),
                        registerField()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }

  Widget emailField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email, 
                color: Color(0xff5ac18e)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.black38)
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: "Please input your email"),
              EmailValidator(errorText: "email format doesn't correct")
            ]),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) {
              profile.email = value.toString();
            },
          ),
        ),
      ],
    );
  }

  Widget passwordField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock, 
                color: Color(0xff5ac18e)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.black38)
            ),
            validator: RequiredValidator(errorText: "Please input your password"),
            obscureText: true,
            onSaved: (value) {
              profile.password = value.toString();
            },
          ),
        ),
      ],
    );
  }

  Widget loginButton(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          backgroundColor: Colors.white
        ),
        child: Text("LOGIN", style: TextStyle(color: Color(0xff5ac18e), fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            print(profile.email);
            print(profile.password);
            try {
              await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: profile.email, password: profile.password)
              .then((value) {
                _formKey.currentState!.reset();
                Navigator.push(context, MaterialPageRoute(builder: ((context) => AccountPage())));
              });
            } on FirebaseException catch (e) {
              Fluttertoast.showToast(msg: e.message.toString(), gravity: ToastGravity.CENTER);
            }
          }
        },
      ),
    );
  }

  Widget registerField(){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't have an Account? ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500
              )
            ),
            TextSpan(
              text: "Sign up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ]
        )
      ),
    );
  }
}
