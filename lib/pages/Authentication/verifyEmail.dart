import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lancer1/pages/home.dart';

class verifyEmail extends StatefulWidget {
  const verifyEmail({super.key});
  @override
  State<verifyEmail> createState() => _verifyEmailState();
}
class _verifyEmailState extends State<verifyEmail> {

  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState(){
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    //sending email verification if email is not verified
    if(!isEmailVerified){
      sendEmailVerification();
      timer = Timer.periodic(
        Duration(seconds: 3),
          (_) => checkEmailVerified(),
        );
    }
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload(); //reload the user before checking

    setState(() { //checking
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified){//cancel the timer if the email is verified
      timer?.cancel();
    }

  }

  Future sendEmailVerification() async{
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }


  void navigateToLoginScreen() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  //check if email is verified
  @override
  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? home() // return home page if it is verified
        : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: navigateToLoginScreen,
        ),
        title: Text('Verify Email'),
      ),
      body: Center(
        child: Text('Please verify your email to continue.'),
      ),
    );
  }

}
