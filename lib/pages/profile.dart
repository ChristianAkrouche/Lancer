import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lancer1/main.dart';
import 'package:lancer1/db/UserInfo.dart';
import 'package:lancer1/Components/textfield.dart';

class profile extends StatefulWidget {
  const profile({super.key});
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  UserInfo? _userInfo;

  File ? _selectedImage;


  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future _pickImageFromGallery() async{
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }


  // Fetch the user data using UserInfo class
  void loadUserData() async {
    try {
      UserInfo userInfo = await UserInfo.fetchUserInfo();
      setState(() {
        _userInfo = userInfo; // Store the fetched user info

      });
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  void editProfilePic() {
    _pickImageFromGallery();
  }
  void editUsername(){

    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter new Username"),
          content: textfield(
            controller: controller,
            hintText: "Type here...",
            obscureText: false,
          ),

          actions: [
            // Close button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text("Close",style: TextStyle(color: Colors.grey[500]),),
            ),

            // Change
            TextButton(
              onPressed: () async {
                _userInfo?.setProfileImageUrl("https://via.placeholder.com/150");
                String newUsername = controller.text;
                UserInfo userInfo = await UserInfo.fetchUserInfo();
                await userInfo.setUsername(newUsername);
                Navigator.of(context).pop();
                setState(() {
                  _userInfo = userInfo; // Now the updated userInfo will be used to refresh the UI
                });

              },
              child: Text("Change",style:TextStyle(color: Colors.green[900]),),
            ),

          ],
        );
      },
    );
  }
  void editBio(){
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter new bio"),
          content: textfield(
            controller: controller,
            hintText: "Type here...",
            obscureText: false,
          ),

          actions: [
            // Close button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text("Close",style: TextStyle(color: Colors.grey[500]),),
            ),

            // Change
            TextButton(
              onPressed: () async {
                String newBio= controller.text;
                UserInfo userInfo = await UserInfo.fetchUserInfo();
                await userInfo.setBio(newBio);
                Navigator.of(context).pop();
                setState(() {
                  _userInfo = userInfo; // Now the updated userInfo will be used to refresh the UI
                });

              },
              child: Text("Change",style:TextStyle(color: Colors.green[900]),),
            ),

          ],
        );
      },
    );
  }


  //ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: _userInfo == null
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator while waiting for data
          : Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          //sizedbox empty
          SizedBox(width: MediaQuery.of(context).size.width,),

          //Profile image
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[400],
                  backgroundImage: NetworkImage(_userInfo!.profileImageUrl),
                ),
                Positioned(
                  child: IconButton(onPressed: editProfilePic, icon: Icon(Icons.edit,size: 18,color: Colors.green[900],),),
                  right: -17,
                  bottom: -12,
                )
              ],
            ),
          ),

            SizedBox(height: 8,),


            Center(
              child: Stack(
                children: [
                  Text("     "+_userInfo!.username+"     "),
                  Positioned(
                    child: IconButton(onPressed: editUsername, icon: Icon(Icons.edit,size: 18,color: Colors.green[900],),),
                    right: -15,
                    bottom: -12,
                  )
                ],
              ),
            ),



          // Bio Section
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Bio Label
                  Row(
                    children: [
                      Text("Bio", style: TextStyle(color: Colors.green[900], fontSize: 20, fontWeight: FontWeight.bold,),),

                      //bio editor
                      IconButton(onPressed: editBio, icon: Icon(Icons.edit,size: 18,color: Colors.green[900],),),
                    ],
                  ),

                  // Bio Text
                  Text(_userInfo!.bio ?? "No bio available", style: TextStyle(fontSize: 16, color: Colors.black87,)),

                  Divider(color: Colors.grey[300], thickness: 1.5,),

                  _selectedImage != null ? Image.file(_selectedImage!) : Text("select")

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

}
