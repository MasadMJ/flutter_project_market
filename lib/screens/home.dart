import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../shared/IteamCard.dart';
import '../shared/appbar.dart';
import '../shared/colors.dart';
import '../shared/firebase.dart';
import '../shared/iteamsList.dart';
import 'checkout.dart';
import 'details_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const UserAccountsDrawerHeader(
                  accountName: Text(
                    "Masad jo",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  accountEmail: Text(
                    "masad@gmail.com",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("lib/assets/img/avatar.jpg"),
                    radius: 55,
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("lib/assets/img/background.jpg"),
                          fit: BoxFit.cover)),
                ),
                ListTile(
                    title: const Text("Home"),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    }),
                ListTile(
                    title: const Text("My products"),
                    leading: const Icon(Icons.add_shopping_cart),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CheckOut()));
                    }),
                ListTile(
                    title: const Text("About"),
                    leading: const Icon(Icons.help_center),
                    onTap: () {}),
                ListTile(
                    title: const Text("Logout"),
                    leading: const Icon(Icons.exit_to_app),
                    onTap: () async {
                      await logOutFireBase(context);
                      
                    }),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text("Developed by MasadJo © 2023",
                  style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: appbarGreen,
        centerTitle: false,
        title: const Text("Home"),
        //leading: IconButton(onPressed: () {}, icon: Icon(Icons.list)),

        actions: const [AppBarMine()],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 33),
            itemCount: listIteams.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            prodect: listIteams[index],
                          ),
                        ));
                  },
                  child: IteamCard(iteam: listIteams[index]));
            }),
      ),
    );
  }
}