import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class VariantsProvider extends ChangeNotifier {
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

  void updateVariant(
    ProductVariants productVariants,
    String variantName,
    String material,
  ) {
    productVariants.variantName = variantName;
    productVariants.material = material;

    notifyListeners();
  }

  // DI PA GUMAGANA
  // void saveVariant(String id) {
  //   FirebaseFirestore.instance.collection("products").add({
  //     'variants': FieldValue.arrayUnion(variant),
  //   });

  //   notifyListeners();
  // }

  List<Map<String, dynamic>> getMap() {
    List<Map<String, dynamic>> productMaps = _variant.map((product) {
      return {
        'productname': product.variantName,
        'material': product.material,
      };
    }).toList();
    print(productMaps);
    return productMaps;
  }
}
