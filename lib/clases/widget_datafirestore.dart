import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetDataFromFirestore extends StatelessWidget {
  final String documentId;

  GetDataFromFirestore(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email: ${data['email']}",style: const TextStyle(
                    fontSize: 17,
                  ),),
                const SizedBox(
                  height: 10,
                ),
                Text("Password: ${data['password']}",style: const TextStyle(
                    fontSize: 17,
                  ),),
                const SizedBox(
                  height: 10,
                ),
                Text("Username: ${data['username']}",style: const TextStyle(
                    fontSize: 17,
                  ),),
                const SizedBox(
                  height: 10,
                ),
                Text("Age: ${data['age']}",style: const TextStyle(
                    fontSize: 17,
                  ),),
                const SizedBox(
                  height: 10,
                ),
                Text("Title: ${data['title']}",style: const TextStyle(
                    fontSize: 17,
                  ),),
              ],
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
