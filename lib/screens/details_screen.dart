// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';


import '../clases/item.dart';
import '../shared/appbar.dart';
import '../shared/colors.dart';

class DetailsScreen extends StatefulWidget {
  final Iteam prodect;
  const DetailsScreen({super.key, required this.prodect});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool showMoreClicked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        centerTitle: false,
        title: Text("Details screen"),
        actions: [AppBarMine()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                color: Colors.amber, child: Image.asset(widget.prodect.image)),
            SizedBox(
              height: 10,
            ),
            Text("\$${widget.prodect.price}"),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(208, 244, 67, 54)),
                  child: Text(
                    "New",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  width: 22,
                ),
                Row(
                  children: [
                    for (int i = 1; i < widget.prodect.rating.round(); i++)
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 26,
                      ),
                  ],
                ),
                SizedBox(
                  width: 60,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.edit_location,
                      color: bTNgreen,
                      size: 26,
                    ),
                    Text(
                      widget.prodect.store,
                      style: TextStyle(fontSize: 19),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                width: double.infinity,
                child: Text(
                  "detaills",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.start,
                )),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.prodect.dec,
              maxLines: showMoreClicked ? 3 : null,
              overflow: TextOverflow.fade,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    showMoreClicked = !showMoreClicked;

                    // print("test");
                  });
                },
                child: Text(showMoreClicked ? "Show More" : "Show Less"))
          ],
        ),
      ),
    );
  }
}
