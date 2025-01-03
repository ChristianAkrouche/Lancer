import 'package:flutter/material.dart';

//this class creates a divider with a text you can insert in the constructor

class dividerWithText extends StatelessWidget {

  final String text ;
  const dividerWithText({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child:Row(
        children: [

          //firt half of divider:
          const Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey,
              )
          ),

          //text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[600]),),
          ),

          //second half of divider
          const Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey,
              )
          ),


        ],
      ),
    );
  }
}
