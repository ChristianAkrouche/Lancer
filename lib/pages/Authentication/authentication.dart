import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lancer1/pages/home.dart';
import 'package:lancer1/pages/Authentication/login.dart';
import 'package:lancer1/pages/Authentication/verifyEmail.dart';

class authentication extends StatelessWidget {
  const authentication({super.key});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: StreamBuilder<User?>(  //This is a StreamBuilder widget that listens to a stream of User? objects from Firebase Authentication.
                                     //The User? type means it can either be a User (when the user is logged in) or null (when the user is logged out).
          stream: FirebaseAuth.instance.authStateChanges(),// Listening to auth state changes from Firebase
          builder:(context, snapshot) {

            //user logged in
            if(snapshot.hasData){
              return verifyEmail();
            }
            //user not logged in
            else{
              return login();
            }
          },
        ),
      ),




    );
  }
}
