import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/productvariants_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class VariantsProvider extends ChangeNotifier{
  final List<ProductVariants> _variant = [];
  List<ProductVariants> get variant => _variant;

  void addVariant(ProductVariants productVariants) {
    _variant.add(productVariants);

    notifyListeners();
  }

  void removeVariant(ProductVariants productVariants) {
    _variant.remove(productVariants);

    notifyListeners();
  }

  void updateVariant(ProductVariants productVariants, String productname, String material) {
    productVariants.productname = productname;
    productVariants.material = material;

    notifyListeners();
  }

  // DI PA GUMAGANA
  void saveVariant(String id) {
    FirebaseFirestore.instance.collection("products").add({
      'variants' : FieldValue.arrayUnion(variant),
    });

    notifyListeners();
  }
}
