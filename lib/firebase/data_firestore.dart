import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_market/firebase/firebase.dart';

class GetDataFromFirestore extends StatefulWidget {
  final String documentId;

  const GetDataFromFirestore(this.documentId, {super.key});

  @override
  State<GetDataFromFirestore> createState() => _GetDataFromFirestoreState();
}

class _GetDataFromFirestoreState extends State<GetDataFromFirestore> {
  final usernameController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  myDialog(Map data, dynamic mykey) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Container(
            padding: const EdgeInsets.all(22),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: usernameController,
                    maxLength: 20,
                    decoration:
                        InputDecoration(hintText: "  ${data[mykey]}    ")),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          users
                              .doc(getAuthInfo("uid"))
                              .update({mykey: usernameController.text});

                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 17),
                        )),
                    TextButton(
                        onPressed: () {
                          // addnewtask();
                        
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 17),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );


   
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
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
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email: ${data['email']}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          myDialog(data, 'email');
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Password: ${data['password']}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          myDialog(data, 'password');
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Username: ${data['username']}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                deleteField("username");
                              });
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              myDialog(data, 'username');
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Age: ${data['age']}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                deleteField("age");
                              });
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              myDialog(data, 'age');
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Title: ${data['title']}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                deleteField("title");
                              });
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              myDialog(data, 'title');
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                Center(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            deleteDocAllDoc();
                          });
                        },
                        child: const Text("Delete Data",
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline))))
              ],
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
