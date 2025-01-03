import 'package:flutter/material.dart';

// This is a button template used for sign in, login etc
// It takes as parameters onPress function and a string to be displayed

class loginButton extends StatelessWidget {

  final void Function() onPressed;
  final String buttonText;
  final Color backgroundColor;

  const loginButton({super.key,required this.onPressed,required this.buttonText,required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23.0), // Optional padding for spacing
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(

              //onPressed function:
              onPressed: onPressed,

              //style:
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),

                //background style:
                backgroundColor: backgroundColor,

                //shadow style:
                elevation: 5,
                shadowColor: Colors.black45,

                //text:
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              //actual text
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
