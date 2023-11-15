import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:furniverse_admin/models/edit_product_variants_model.dart';
import 'package:furniverse_admin/models/product_variants_model.dart';
import 'package:furniverse_admin/services/upload_image_services.dart';
import 'package:furniverse_admin/services/upload_model_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class VariantsProvider extends ChangeNotifier {
  final List<ProductVariants> _variant = [];
  List<ProductVariants> get variant => _variant;
  final List<EditProductVariants> _oldvariants = [];
  List<EditProductVariants> get oldvariants => _oldvariants;

  void addVariant(ProductVariants productVariants) {
    _variant.add(productVariants);

    notifyListeners();
  }

  void oldvariant(EditProductVariants editProductVariants) {
    print("hello");
    _oldvariants.add(editProductVariants);
    print(_oldvariants.length);
  }

  void removeVariant(ProductVariants productVariants) {
    _variant.remove(productVariants);

    notifyListeners();
  }

  void clearVariant() {
    _variant.clear();
  }

  void clearOldVariant() {
    _oldvariants.clear();
  }

  void updateVariant(
    ProductVariants productVariants,
    ProductVariants newVariant,
  ) {
    int indexOfValue = _variant.indexOf(productVariants);
    if (indexOfValue != -1) {
      // Check if the value exists in the list
      _variant[indexOfValue] =
          newVariant; // Replace the value with the new value
    } else {
      // Handle the case where the value is not found in the list
      print("Value $productVariants not found in the list.");
    }

    notifyListeners();
  }

  // DI PA GUMAGANA
  // void saveVariant(String id) {
  //   FirebaseFirestore.instance.collection("products").add({
  //     'variants': FieldValue.arrayUnion(variant),
  //   });

  //   notifyListeners();
  // }

  Future<List<Map<String, dynamic>>> getMap() async {
    List<Map<String, dynamic>> productMaps = [];

    print("oldvariants.lengh");
    print(_oldvariants.length);

    for (EditProductVariants products in _oldvariants) {
      productMaps.add({
        'variant_name': products.variantName,
        'material': products.material,
        'size': products.size,
        'color': products.color,
        'price': products.price,
        'stocks': products.stocks,
        'image': products.image,
        'model': products.model,
        'id': products.id,
      });
    }

    for (ProductVariants product in _variant) {
      print("oldvariants.lengh");
      print(_oldvariants.length);

      String? imageReference = '';
      String? modelReference = '';

      imageReference = await uploadVariantImageToFirebase(product.image);

      // final imageFile = product.image!;
      // final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      // final imageTask = storage.ref().child('images/$imageFileName').putFile(imageFile);
      // await imageTask.whenComplete(() async {
      //   imageReference = await imageTask.snapshot.ref.getDownloadURL();
      // });

      modelReference = await uploadModelToFirebase(product.model);

      // if (product.modelFile != null) {
      //   final modelFile = product.modelFile!;
      //   final modelFileName = DateTime.now().millisecondsSinceEpoch.toString();
      //   final modelTask =
      //       storage.ref().child('models/$modelFileName').putFile(modelFile);
      //   await modelTask.whenComplete(() async {
      //     modelReference = await modelTask.snapshot.ref.getDownloadURL();
      //   });
      // }

      productMaps.add({
        'variant_name': product.variantName,
        'material': product.material,
        'size': product.size,
        'color': product.color,
        'price': product.price,
        'stocks': product.stocks,
        'image': imageReference,
        'model': modelReference,
        'id': product.id,
      });
    }

    // List<Map<String, dynamic>> productMaps = _variant.map((product) {
    //   // final image = await

    //   return {
    //     'variant name': product.variantName,
    //     'material': product.material,
    //     'size': product.size,
    //     'color': product.color,
    //     'price': product.price,
    //     'stocks': product.stocks,
    //     'image': product.image,
    //     'model': product.model,
    //   };
    // }).toList();
    // print(productMaps);
    return productMaps;
  }
}
