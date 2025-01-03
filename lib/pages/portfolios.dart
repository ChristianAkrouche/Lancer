import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lancer1/db/portfoliosDatabase.dart' as portfoliosDatabase;
import 'package:lancer1/Components/Drawer%20Components/drawer.dart';
import '../db/portfoliosDatabase.dart';

class portfolios extends StatefulWidget {
  const portfolios({super.key});
  @override
  _portfoliosState createState() => _portfoliosState();
}

class _portfoliosState extends State<portfolios> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  Future<void> createPortfolio(BuildContext context) async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    double budget = double.tryParse(_budgetController.text.trim()) ?? 0.0;

    if (title.isNotEmpty && description.isNotEmpty && budget > 0) {
      // Using createJobOffering instead of createPortfolio
      portfolio newPortfolio = portfolio(
        portfolioId: '', // Will be assigned after creation
        title: title,
        description: description,
        budget: budget,
        rating: 0.0,
        userId: FirebaseAuth.instance.currentUser!.uid,
      );
      await portfoliosDatabase.portfolio.createPortfolio(newPortfolio);
      Navigator.pop(context);
      setState(() {}); // Refresh the UI
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly.")),
      );
    }
  }

  void _showCreatePortfolioDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create Portfolio"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Portfolio Title"),
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
            onPressed: () => createPortfolio(context),
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
            onPressed: () => _showCreatePortfolioDialog(context),
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
        stream: FirebaseFirestore.instance
            .collection('portfolios')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Portfolios available."));
          }

          var portfolios = snapshot.data!.docs;

          return ListView.builder(
            itemCount: portfolios.length,
            itemBuilder: (context, index) {
              var portfolio = portfolios[index];
              String userIdFromPortfolio = portfolio['userId'];

              // FutureBuilder to fetch username dynamically
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userIdFromPortfolio).get(),
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
                              portfolio['title'] ?? "No Title",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900]),
                            ),
                            SizedBox(height: 8),
                            Text(
                              portfolio['description'] ?? "No Description",
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "\$${portfolio['budget'].toStringAsFixed(2)}",
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
