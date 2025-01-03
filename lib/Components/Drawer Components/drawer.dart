import 'package:flutter/material.dart';
import 'package:lancer1/Components/Drawer%20Components/drawerTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lancer1/pages/profile.dart';

class drawer extends StatelessWidget {
  const drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Column(
        children: [
          //icon

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Icon(Icons.person,size:95,color:Colors.grey[700],),
          ),

          //home
          drawerTile(
            title: "H O M E",
            icon: Icons.home
            , onTap:() => Navigator.of(context).pop(),
          ),

          //profile
          drawerTile(
            title: "P R O F I L E",
            icon: Icons.person ,
            onTap:(){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => profile() ));
            },
          ),

          //Settings
          drawerTile(
            title: "S E T T I N G S",
            icon: Icons.settings,
            onTap:(){},
          ),

          //logout
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: drawerTile(title: " L O G O U T ", icon: Icons.logout , onTap:()async {await FirebaseAuth.instance.signOut();},),
          ),

        ],
      ),
    );
  }
}
