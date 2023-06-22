import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../clases/item.dart';
import '../provider/cart.dart';

class IteamCard extends StatelessWidget {
  final Iteam iteam;

  const IteamCard({super.key, required this.iteam});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        // backgroundColor: Color.fromARGB(66, 73, 127, 110),
        trailing: Consumer<Cart>(builder: ((context, classInstancee, child) {
          return IconButton(
              color: const Color.fromARGB(255, 62, 94, 70),
              onPressed: () {classInstancee.addProdect(iteam);},
              icon: const Icon(Icons.add));
        })),

        leading: Container(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "\$${iteam.price.toString()}",
              style: const TextStyle(backgroundColor: Colors.white),
            )),

        title: const Text(
          "",
        ),
      ),
      child: Stack(children: [
        Positioned(
          top: -3,
          bottom: -9,
          right: 0,
          left: 0,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.asset(iteam.image)),
        ),
      ]),
    );
  }
}
