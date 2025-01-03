import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class portfolio {
  String portfolioId;
  String title;
  String description;
  double budget;
  List<String>? skills;
  double rating;
  String userId;

  portfolio({
    required this.portfolioId,
    required this.title,
    required this.description,
    required this.budget,
    this.skills,
    required this.rating,
    required this.userId, // Include userId in constructor
  });

  Future<void> setBudget(double newBudget) async {
    this.budget = newBudget;
    await _updatePortfolio();
  }

  Future<void> setSkills(List<String>? newSkills) async {
    this.skills = newSkills;
    await _updatePortfolio();
  }

  Future<void> setRating(double newRating) async {
    this.rating = newRating;
    await _updatePortfolio();
  }

  Future<void> setTitle(String newTitle) async {
    this.title= newTitle ;
    await _updatePortfolio();
  }

  Future<void> _updatePortfolio() async {
    final jobRef = FirebaseFirestore.instance.collection('portfolios').doc(portfolioId);
    await jobRef.update({
      'title': this.title,
      'description': this.description,
      'budget': this.budget,
      'skills': this.skills,
      'rating': this.rating,
      'userId': this.userId, // Ensure userId is not lost
    });
  }

  static Future<void> createPortfolio( portfolio portfolio) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newJobRef = FirebaseFirestore.instance.collection('portfolios').doc();
      await newJobRef.set({
        'title': portfolio.title,
        'description': portfolio.description,
        'budget': portfolio.budget,
        'skills': portfolio.skills,
        'rating': portfolio.rating,

        'date': FieldValue.serverTimestamp(),
        'userId': user.uid, // Associate the job with the current user
      });
      portfolio.portfolioId = newJobRef.id;
    }
  }

}