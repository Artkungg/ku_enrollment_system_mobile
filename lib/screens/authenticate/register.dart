import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_project/screens/authenticate/login.dart';
import 'package:mobile_project/screens/pages/account.dart';
import 'package:mobile_project/model/profile.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(
              child: Text("${snapshot.error}"),
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
                        Text('Register', style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold)),
                        SizedBox(height: 50),
                        emailField(),
                        SizedBox(height: 20),
                        passwordField(),
                        SizedBox(height: 20),
                        confirmPasswordField(),
                        SizedBox(height: 20),
                        registerButton(),
                        SizedBox(height: 25),
                        loginField()
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

  Widget confirmPasswordField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Confrim Password", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
              hintText: 'Confirm Password',
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

  Widget registerButton(){
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
        child: Text("REGISTER", style: TextStyle(color: Color(0xff5ac18e), fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            try {
              await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: profile.email,
                    password: profile.password)
                .then((value) {
                Fluttertoast.showToast(
                  msg: "Account has been created",
                  gravity: ToastGravity.TOP);
                _formKey.currentState!.reset();
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                    return AccountPage();
                }));
              });
            } on FirebaseAuthException catch (e) {
              String message = "";
              if (e.code == "email-already-in-use") {
                message = "email already in use";
              } else if (e.code == "weak-password") {
                message =
                    "Password must be at least 6 characters";
              }
              Fluttertoast.showToast(
                msg: message,
                gravity: ToastGravity.TOP);
            }
          }
        },
      ),
    );
  }

  Widget loginField(){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Have an Account? ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500
              )
            ),
            TextSpan(
              text: "Login",
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
