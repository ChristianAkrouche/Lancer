import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//this class works by defining variables about user information
//we use setters to change the variables and call the updateUserInfo function to update the database

class UserInfo {
  String userId;
  String username;
  String bio;
  String profileImageUrl;
  int rating;


  UserInfo({
    required this.userId,
    required this.username,
    required this.bio,
    required this.profileImageUrl,
    required this.rating,
  });

  // Setters
  Future<void> setUsername(String newUsername) async {
    this.username = newUsername;
    await _updateUserInfo();
  }

  Future<void> setBio(String newBio) async {
    this.bio = newBio;
    await _updateUserInfo();
  }

  Future<void> setRating(int newRating) async {
    this.rating = newRating;
    await _updateUserInfo();
  }
  Future<void> setProfileImageUrl(String newUrl) async {
    this.profileImageUrl = newUrl;
    await _updateUserInfo();
  }


  // Firebase update function
  Future<void> _updateUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.update({
        'username': this.username,
        'rating': this.rating,
        'profileImage' : this.profileImageUrl,
        'bio': this.bio,
      });
    }
  }

  // Fetch user info from Firestore
  static Future<UserInfo> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return UserInfo(
        userId: user.uid,
        username: snapshot['username'],
        bio: snapshot['bio'],
        profileImageUrl: snapshot['profileImage'],
        rating: snapshot['rating'],
      );
    }
    throw Exception('User not logged in');
  }


}