import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lancer1/Components/Drawer%20Components/drawer.dart';
import 'package:lancer1/pages/Jobs.dart';
import 'package:lancer1/pages/messages.dart';
import 'package:lancer1/pages/notifications.dart';
import 'package:lancer1/pages/portfolios.dart';

class home extends StatefulWidget {
   home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int navigationIndex=0;
  List<Widget> widgetList = [
    Jobs(),
    portfolios(),
    notifications(),
    messages(),

  ];

  final user = FirebaseAuth.instance.currentUser;
 //get info about the user


  @override
  Widget build(BuildContext context) {


    return Scaffold(


      //body
      body: SafeArea(
        child: IndexedStack(children: widgetList,index: navigationIndex,),
        //IndexedStack: This widget is a type of stack that displays only one child at a time, based on the specified index.
        // It keeps all of its child widgets in memory but only shows the one at the given index.
      ),


      //Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[900],
        onTap: (index){ // on tap function receives the index and selects it
          setState(() { // set state changes the ui when we tap it
            navigationIndex = index;
          });
        },
        currentIndex: navigationIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline),label:'jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_open),label:'portfolios'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined),label:'notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_outlined),label:'messages'),
      ]
      ),



    );
  }
}
