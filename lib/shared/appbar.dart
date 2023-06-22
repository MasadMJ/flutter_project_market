import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../screens/checkout.dart';

class AppBarMine extends StatefulWidget {
  const AppBarMine({super.key});

  @override
  State<AppBarMine> createState() => _AppBarMineState();
}

class _AppBarMineState extends State<AppBarMine> {
  @override
  Widget build(BuildContext context) {
    final cartBag = Provider.of<Cart>(context);

    return Row(children: [
      Stack(
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CheckOut()));
              },
              icon: const Icon(
                Icons.add_shopping_cart,
                size: 20,
              )),
          Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(211, 164, 255, 193),
                  shape: BoxShape.circle),
              child: Text(
                "${cartBag.iteamCount}",
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              )),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(right: 11.0),
        child: Text(
          "\$${cartBag.getPrice()}",
          style: const TextStyle(fontSize: 18),
        ),
      )
    ]);
  }
}
