import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lancer1/Components/textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  //controllers:
  final emailController = TextEditingController();

  Future resetPassword() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
    } on  FirebaseAuthException catch (e){
      print(e);
      showDialog(context: context, builder:
      (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      }
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password", style: TextStyle(fontSize:20),),

      ),
      body:SingleChildScrollView(
        child: SafeArea(child: Column(
          children: [
        
            SizedBox(height: 90,),
        
            Icon(
              Icons.email,
              color: Colors.grey[700], // Set the icon color to yellow
              size: 150,         // Increase the icon size (adjust as needed)
            ),
        
        
        
            SizedBox(height: 55),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Please Enter your email",
                   textAlign: TextAlign.left,
                   style: TextStyle(
                   fontSize:20 ,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    ),
              ),
            ),
        
            textfield(controller: emailController, hintText:'Enter your email here', obscureText: true),

            SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () {
                // Logic to reset the email field
                resetPassword();
                emailController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email to reset your password will be sent shortly')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900], // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                shadowColor: Colors.black45, // Shadow color
                elevation: 8, // Shadow depth
              ), // ElevatedButton.styleFrom ends here
              child: Text(
                'Reset',
                style: TextStyle(
                  fontSize: 14.0, // Text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),


          ],






        ),
        
        
        
        
        ),
      )

    );
  }
}
