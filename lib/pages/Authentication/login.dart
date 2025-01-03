import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lancer1/Components/dividerWithText.dart';
import 'package:lancer1/Components/loginIconButton.dart';
import 'package:lancer1/Components/loginButton.dart';
import 'package:lancer1/Components/textfield.dart';
import 'package:lancer1/pages/Authentication/ForgotPasswordPage.dart';

class login extends StatefulWidget {

  login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  
  //controllers:
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  // user login logic:
  Future<void> loginUser() async{

   // showing loading circle
    showDialog(context: context, builder: (context){
      return const Center(
        child:CircularProgressIndicator(color: Colors.green,),
      );
    },);

   //login authentication
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the user profile already exists
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // If the profile doesn't exist, create it
          // using the createUserProfile function and assigning default values
          await createUserProfile(user, "defaultUsername", "defaultBio", "https://via.placeholder.com/150");
        }


      }

      Navigator.pop(context);//pop loading circle

    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      print("Caught FirebaseAuthException: ${e.code}");//helps with debugging
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
  //widget tree UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,//lets widgets become obscured by the keyboard
      backgroundColor: Colors.grey[300],

      body: SafeArea(
          child:SingleChildScrollView( //allows a single child widget to become scrollable when its content exceeds the screen size, preventing overflow errors.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //logo
                const SizedBox(width: double.infinity),// takes hole width of the screen
                const Image(image: AssetImage('assets/lancer-nobackground.png'),width: 600,height:270),


                //username textfield
                textfield(controller: emailController, hintText:'Email', obscureText: false),
                const SizedBox(height: 10),

                //password textfield
                textfield(controller: passwordController, hintText:'Password', obscureText: true),

                //forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28,vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      GestureDetector(
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context){return ForgotPasswordPage();} ));
                        },
                        child: Text(
                          'forgot password?',
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),


                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //loginButton
                loginButton(onPressed: loginUser, buttonText: 'Login',backgroundColor: Colors.green.shade900,),


                //divider with text
                const SizedBox(height: 10),
                const dividerWithText(text: "or"),

                //google button
                const SizedBox(height: 10),
                loginIconButton(
                  onPressed: loginUser,
                  buttonText: 'Continue with google',
                  backgroundColor: Colors.grey.shade500,
                  image: Image(image: AssetImage('assets/google-logo.png'),height: 25,),
                ),

                //don't have an account?
                const SizedBox(height: 60,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signUp'); // pushes a new location on top
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.green[900], // Text color for the clickable link
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ],
                )


              ]

                  ),
          )
    ),);


  }
}
