import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../methods/common_methods.dart';
import '../pages/home_page.dart';
import '../widgets/loading_dialog.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetWorkIsAvailable() {
    cMethods.checkConnectivity(context);

    signUpFormValidation();
  }

  signUpFormValidation() {
    if (userNameTextEditingController.text.isEmpty ||
        userPhoneTextEditingController.text.isEmpty ||
        emailTextEditingController.text.isEmpty ||
        passwordTextEditingController.text.isEmpty) {
      cMethods.displaySnackbar(
        'fill in the required field ',
        context,
      );
    } else if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackbar(
        'Your Name Must be AT least 4  characters long ',
        context,
      );
    } else if (userPhoneTextEditingController.text.trim().length < 7) {
      cMethods.displaySnackbar(
        'Your phone number Must be At least 8  characters long ',
        context,
      );
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackbar(
        'please put in valid email',
        context,
      );
    } else if (passwordTextEditingController.text.trim().length < 6) {
      cMethods.displaySnackbar(
        'please password must be at least 6 characters long',
        context,
      );
    } else {
      //SIGN USER IN
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: 'Registering Your Account...'),
    );

    final User? userFirebase = (await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
        .catchError((errormsg) {
      Navigator.pop(context);
      cMethods.displaySnackbar(errormsg.toString(), context);
    }))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef =
    FirebaseDatabase.instance.ref().child('users').child(userFirebase!.uid);
    Map userDataMap = {
      'name': userNameTextEditingController.text.trim(),
      'email': emailTextEditingController.text.trim(),
      'phone': userPhoneTextEditingController.text.trim(),
      'id': userFirebase.uid,
      'blockStatus': 'no'
    };
    usersRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset('assets/images/rideon.png'),

              Text(
                'Create a users account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              //TEXT FIELDS + BUTTON
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  children: [
                    TextField(
                      controller: userNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'user name',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: userPhoneTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'user Phone',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'user email',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'user password',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9, // 90% of the screen width
                      child: ElevatedButton(
                        onPressed: () {
                          checkIfNetWorkIsAvailable();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[500],
                            padding: EdgeInsets.symmetric(
                                horizontal: 80, vertical: 10)),
                        child: Text('SignUp', style: TextStyle(color: Colors.white,fontSize: 15),),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => LoginScreen()));
                      },
                      child: Text(
                        'Already have an account? login here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
