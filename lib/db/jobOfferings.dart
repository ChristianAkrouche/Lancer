import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobOffering {
  String jobId;
  String title;
  String description;
  double budget;
  List<String>? skills;
  double rating;
  int numberApplied;
  String userId;

  JobOffering({
    required this.jobId,
    required this.title,
    required this.description,
    required this.budget,
    this.skills,
    required this.rating,
    required this.numberApplied,
    required this.userId, // Include userId in constructor
  });

  // Setters
  Future<void> setTitle(String newTitle) async {
    this.title = newTitle;
    await _updateJobOffering();
  }

  Future<void> setDescription(String newDescription) async {
    this.description = newDescription;
    await _updateJobOffering();
  }

  Future<void> setBudget(double newBudget) async {
    this.budget = newBudget;
    await _updateJobOffering();
  }

  Future<void> setSkills(List<String>? newSkills) async {
    this.skills = newSkills;
    await _updateJobOffering();
  }

  Future<void> setRating(double newRating) async {
    this.rating = newRating;
    await _updateJobOffering();
  }

  Future<void> setNumberApplied(int newNumberApplied) async {
    this.numberApplied = newNumberApplied;
    await _updateJobOffering();
  }

  // Firebase update function
  Future<void> _updateJobOffering() async {
    final jobRef = FirebaseFirestore.instance.collection('jobOfferings').doc(jobId);
    await jobRef.update({
      'title': this.title,
      'description': this.description,
      'budget': this.budget,
      'skills': this.skills,
      'rating': this.rating,
      'numberApplied': this.numberApplied,
      'userId': this.userId, // Ensure userId is not lost
    });
  }

  // Fetch job offering from Firestore
  static Future<JobOffering> fetchJobOffering(String jobId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('jobOfferings').doc(jobId).get();
    return JobOffering(
      jobId: jobId,
      title: snapshot['title'],
      description: snapshot['description'],
      budget: snapshot['budget'],
      skills: List<String>.from(snapshot['skills'] ?? []),
      rating: snapshot['rating'],
      numberApplied: snapshot['numberApplied'],
      userId: snapshot['userId'], // Include userId in data fetching
    );
  }

  // Fetch job offerings ordered by date
  static Future<List<JobOffering>> fetchJobOfferingsOrderedByDate() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('jobOfferings')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => JobOffering(
      jobId: doc.id,
      title: doc['title'],
      description: doc['description'],
      budget: doc['budget'],
      skills: List<String>.from(doc['skills'] ?? []),
      rating: doc['rating'],
      numberApplied: doc['numberApplied'],
      userId: doc['userId'], // Include userId in data mapping
    )).toList();
  }

  // Create a new job offering
  static Future<void> createJobOffering(JobOffering jobOffering) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final newJobRef = FirebaseFirestore.instance.collection('jobOfferings').doc();
      await newJobRef.set({
        'title': jobOffering.title,
        'description': jobOffering.description,
        'budget': jobOffering.budget,
        'skills': jobOffering.skills,
        'rating': jobOffering.rating,
        'numberApplied': jobOffering.numberApplied,
        'date': FieldValue.serverTimestamp(),
        'userId': user.uid, // Associate the job with the current user
      });
      jobOffering.jobId = newJobRef.id;
    }
  }
}