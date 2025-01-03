import 'package:flutter/material.dart';
import 'package:lancer1/Components/textfield.dart';
import 'package:lancer1/Components/loginButton.dart';
import 'package:lancer1/Components/loginIconButton.dart';
import 'package:lancer1/Components/dividerWithText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lancer1/pages/Authentication/authentication.dart';
import 'package:lancer1/pages/home.dart';
import 'package:lancer1/pages/Authentication/verifyEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signUp extends StatefulWidget {


  signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {

  //controllers:
  final newUsernameController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Method to create user profile
  Future<void> createUserProfile(User user, String username, String bio, String profileImageUrl) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create or update the user document with additional fields
    await firestore.collection('users').doc(user.uid).set({
      'username': username,
      'bio': bio,
      'profileImage':"https://via.placeholder.com/150",
      'rating': 0, // Initial rating, can be updated later
    },SetOptions(merge: true)); // SetOptions(merge: true) allows updating existing data);
  }



  // user signup logic:
  Future<void> signUpUser() async {

    // showing loading circle
    showDialog(context: context, builder: (context){
      return const Center(
        child:CircularProgressIndicator(color: Colors.green,),
      );
    },);

    //signup authentication
    try{
      Navigator.pop(context);

      if(newPasswordController.text == confirmPasswordController.text){ //check if password is confirmed
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: newUsernameController.text,
            password: newPasswordController.text
        );

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Create profile with default values
          await createUserProfile(user, "defaultUsername", "defaultBio", "https://via.placeholder.com/150");
        }

        Navigator.pop(context);

      }
      else {

        showErrorMessage("Passwords don't match");
      }


    }on FirebaseAuthException catch (e){

      showErrorMessage(e.code);
    }

  }

  //Error popups
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.grey[400],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.redAccent[600],
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.4, // Improved readability with line height
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // White text color
                      backgroundColor: Colors.grey[200], // Red accent button
                      padding: EdgeInsets.symmetric(vertical: 14), // Spacious padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



////////////////////////////////////////////////////////////////////////////////
  //ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,//lets widgets become obscured by the keyboard
      backgroundColor: Colors.grey[300],

      //appBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      //body
      body:SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),// takes hole width of the screen

            Padding(
              padding: const EdgeInsets.only(left: 25.0), // Apply padding only to the left
              child: Align(
                alignment: Alignment.centerLeft, // Align the text to the left within the column
                child: Text(
                  "Create\naccount", // Combining the two texts with a new line (\n)
                  textAlign: TextAlign.left, // Align text to the left
                  style: TextStyle(
                    fontSize:45 , // Big text
                    fontWeight: FontWeight.bold, // Bold text
                    color: Colors.green[900], // Green color with shade 900
                  ),
                ),
              ),
            ),
            //username
            const SizedBox(height: 50),
            textfield(controller: newUsernameController, hintText:'Username', obscureText: false),

            //Password
            const SizedBox(height: 10),
            textfield(controller: newPasswordController, hintText:'Password', obscureText: true),

            //Confirm Password
            const SizedBox(height: 10),
            textfield(controller: confirmPasswordController, hintText:'Confirm Password', obscureText: true),

            //SignUp button
            const SizedBox(height: 20),
            loginButton(onPressed: signUpUser, buttonText: 'Sign up',backgroundColor: Colors.green.shade900,),

            //divider with text
            const SizedBox(height: 10),
            const dividerWithText(text: "or"),

            //google button
            const SizedBox(height: 10),
            loginIconButton(
              onPressed: signUpUser,
              buttonText: 'Continue with google',
              backgroundColor: Colors.grey.shade500,
              image: Image(image: AssetImage('assets/google-logo.png'),height: 25,),
            ),

            //have an account?
            const SizedBox(height: 60,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Pops the current route off the navigator stack
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.green[900], // Text color for the clickable link
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),
              ],
            )



          ],

        ),
      ),



    );
  }
}
