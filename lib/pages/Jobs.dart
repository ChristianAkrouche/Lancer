import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lancer1/Components/Drawer%20Components/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lancer1/db/UserInfo.dart' as customUserInfo;

// Firestore instance
FirebaseFirestore firestore = FirebaseFirestore.instance;
final userId = FirebaseAuth.instance.currentUser?.uid;

class Jobs extends StatefulWidget {
  const Jobs({super.key});
  @override
  _JobsState createState() => _JobsState();
}


class _JobsState extends State<Jobs> {
  customUserInfo.UserInfo? _userInfo;


  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Fetch the user data using UserInfo class
  void loadUserData() async {
    try {

      // Ensure `fetchUserInfo` returns an instance of `customUserInfo.UserInfo`
      customUserInfo.UserInfo userInfo = await customUserInfo.UserInfo.fetchUserInfo();
      setState(() {
        _userInfo = userInfo; // Assign the fetched user info to `_userInfo`
      });
      print(_userInfo?.username);
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  Future<void> createJobOffering(BuildContext context) async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    double budget = double.tryParse(_budgetController.text.trim()) ?? 0.0;

    if (title.isNotEmpty && description.isNotEmpty && budget > 0) {
      await firestore.collection('jobOfferings').add({
        'title': title,
        'description': description,
        'budget': budget,
        'skills': [], // Add skill input if needed
        'rating': 0.0,
        'numberApplied': 0,
        'date': FieldValue.serverTimestamp(),
        'userId': userId,
      });
      Navigator.pop(context);
      setState(() {}); // Refresh the UI
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly.")),
      );
    }
  }

  void _showCreateJobDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create Job Offering"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Job Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(labelText: "Budget"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => createJobOffering(context),
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showCreateJobDialog(context),
            icon: Icon(
              Icons.add_box_outlined,
              color: Colors.green[900],
              size: 27,
            ),
          ),
        ],
      ),
      drawer: drawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('jobOfferings')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Jobs available."));
          }

          var jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index];
              String userIdFromJob = job['userId'] ; // Get the userId associated with the job

              //FutureBuilder to fetch username dynamically
              return FutureBuilder<DocumentSnapshot>(
                future: firestore.collection('users').doc(userIdFromJob).get(), // Fetch user data based on job's userId
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show loading indicator while fetching data
                  }

                  if (userSnapshot.hasData && userSnapshot.data != null) {
                    var userData = userSnapshot.data!;
                    String username = userData['username'] ?? 'Unknown User'; // Fallback to 'Unknown User' if no username found

                    return Card(
                      elevation: 1, // Adds a shadow effect
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 1), // Adds space around the card
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Adds padding inside the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username, style: TextStyle(fontWeight: FontWeight.bold)), // Display the username
                            Text(
                              job['title'] ?? "No Title",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900]),
                            ),
                            SizedBox(height: 8),
                            Text(
                              job['description'] ?? "No Description",
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "\$${job['budget'].toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const Text('Error loading user'); // Handle case where user data is not available
                },
              );
            },
          );
        },
      ),
    );
  }
}
