import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/AuthService/auth_service.dart';
import 'package:my_notes/data/dummy_data.dart';

import 'create_note.dart';

class Notes extends StatelessWidget {
  Notes({super.key});

  final auth = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () {
              AuthService().signOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(auth!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return GridView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  tileColor: Colors.teal,
                  title: Text(notesData[index]['title']!),
                  subtitle: Text(notesData[index]['content']!),
                ),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            );
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateNote()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}
