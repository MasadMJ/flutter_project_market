import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../shared/appbar.dart';
import '../shared/colors.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    final cartBag = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        centerTitle: false,
        title: const Text("Checkout"),
        actions: const [AppBarMine()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: ListView.builder(
                  itemCount: cartBag.iteamCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage: AssetImage(
                                "${cartBag.selectedProdects[index].image}")),
                        subtitle: Text(
                          "\$${cartBag.selectedProdects[index].price.floor()} - ${cartBag.selectedProdects[index].store}",
                          maxLines: 2,
                        ),
                        title: Text("${cartBag.selectedProdects[index].name}"),
                        trailing: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              cartBag.removeProdect(
                                  cartBag.selectedProdects[index]);
                            }),
                        //onTap: (){print("xx");},
                      ),
                    );
                  }),
            ),
       
            if (cartBag.getPrice() > 0)
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.payment,
                  color: Colors.white,
                  size: 24.0,
                ),
                label: Text(
                  "Pay \$${cartBag.getPrice()}",
                  style: const TextStyle(fontSize: 15),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(bTNpink),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                ),
              )
          ],
        ),
      ),
    );
  }
}
