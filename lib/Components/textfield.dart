import 'package:flutter/material.dart';

class textfield extends StatelessWidget {

  //variables:
  final controller; //stores user input
  final String hintText;  // hint what should be typed in
  final bool obscureText; //hide characters (passwords)

  //Constructor:
  const textfield({
    super.key,
    required this.controller, //required means these should always be entered
    required this.hintText,
    required this.obscureText

  });

  //Widget:
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(

        controller: controller,
        obscureText: obscureText,


        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),

            // outline border:
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
            ),

            //fill
            filled: true,
            fillColor: Colors.grey[100],

            //focused border:
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green)
            )

        ),


      ),
    );
  }


}
