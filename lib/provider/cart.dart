import 'package:flutter/material.dart';

import '../clases/item.dart';

class Cart with ChangeNotifier {
  // create new properties & methods

  List selectedProdects = [];

  addProdect(prodect) {
    selectedProdects.add(prodect);
    notifyListeners();
  }

  removeProdect(prodect) {
    selectedProdects.remove(prodect);
    notifyListeners();
  }

  int getPrice() {
    int price = 0;
    for (Iteam prodect in selectedProdects) {
      price += prodect.price.round();
    }

    return price;
  }

  get iteamCount {
    return selectedProdects.length;
  }
}
