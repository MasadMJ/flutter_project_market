import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetNameFromFirestore extends StatelessWidget {
  final String documentId;

  const GetNameFromFirestore(this.documentId, {super.key});

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
            //  width: double.infinity,
              child: Text(data['username'],style: const TextStyle(fontSize: 20, color: Colors.white)));
        }

        return const Text("loading");
      },
    );
  }
}
