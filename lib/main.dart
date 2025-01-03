import 'package:flutter/material.dart';
import 'package:lancer1/pages/Authentication/authentication.dart';
import 'package:lancer1/pages/Authentication/login.dart';
import 'package:lancer1/pages/Authentication/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lancer1/pages/Authentication/verifyEmail.dart';
import 'firebase_options.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    initialRoute: '/authentication',
    routes:{ // this takes maps as parameters meaning key value pairs.
      '/login':(context) => login(),
      '/signUp':(context) => signUp(),
      '/authentication':(context) => authentication(),
      '/verifyEmail':(context) => verifyEmail(),


    },

  ));
}




