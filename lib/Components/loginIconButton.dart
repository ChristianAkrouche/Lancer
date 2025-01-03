import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class loginIconButton extends StatelessWidget {

  final void Function() onPressed;
  final String buttonText;
  final Color backgroundColor;
  final Image  image;

  const loginIconButton({super.key,required this.onPressed,required this.buttonText,required this.backgroundColor, required this.image});

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 22),
                  image,
                  const SizedBox(width: 15),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )



                ],
              ),



            ),
          ),
        ],
      ),
    );
  }
}
