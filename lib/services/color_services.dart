import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/color_model.dart';

class ColorService {
  final CollectionReference _colorCollection =
      FirebaseFirestore.instance.collection('colors');

  Future<void> addColor(Map<String, dynamic> colorsData) async {
    try {
      final colorTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      colorsData['timestamp'] =
          colorTimestamp; // Add the timestamp to your data
      DocumentReference productDocRef =
          await _colorCollection.add(colorsData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> deleteColor(String colorId) async {
    try {
      // delete file in firestorage

      await _colorCollection.doc(colorId).delete();
    } catch (e) {
      print('Error deleting material: $e');
    }
  }

  Stream<DocumentSnapshot<Object?>> editColor(String colorId) {
    // delete file in firestorage
    return _colorCollection.doc(colorId).snapshots();
  }

  Future<void> updateColor(
      Map<String, dynamic> colorData, String colorId) async {
    try {
      final materialTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      colorData['timestamp'] =
          materialTimestamp; // Add the timestamp to your data

      await _colorCollection.doc(colorId).set(colorData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> reducedQuantity(List<dynamic> color) async {
    try {
      // await _materialsCollection
      //     .doc(materialId)
      //     .update({'quantity': FieldValue.increment(-quantity)});
      // print(materials);
      if (color[0]['materialId'] == "") return;
      for (var material in color) {
        DocumentSnapshot doc =
            await _colorCollection.doc(material['materialId']).get();
        Map data = doc.data() as Map;
        var variants = data['variants'];
        List<Map> newVariants = [];
        for (var variant in variants) {
          if (variant['id'] == material['variationId']) {
            variant['stocks'] = variant['stocks'] - material['quantity'];
          }
          newVariants.add(variant);
        }
        await _colorCollection
            .doc(material['materialId'])
            .update({'variants': newVariants});
        // .update({'quantity': FieldValue.increment(-quantity)});
      }
    } catch (e) {
      print('Error updating material quantity: $e');
    }
  }

  Future<void> addQuantity(List<dynamic> color) async {
    try {
      // await _materialsCollection
      //     .doc(materialId)
      //     .update({'quantity': FieldValue.increment(-quantity)});
      // print(materials);
      if (color[0]['materialId'] == "") return;
      for (var material in color) {
        DocumentSnapshot doc =
            await _colorCollection.doc(material['materialId']).get();
        Map data = doc.data() as Map;
        var variants = data['variants'];
        List<Map> newVariants = [];
        for (var variant in variants) {
          if (variant['id'] == material['variationId']) {
            variant['stocks'] = variant['stocks'] + material['quantity'];
          }
          newVariants.add(variant);
        }
        await _colorCollection
            .doc(material['materialId'])
            .update({'variants': newVariants});
        // .update({'quantity': FieldValue.increment(-quantity)});
      }
    } catch (e) {
      print('Error updating material quantity: $e');
    }
  }

  Stream<QuerySnapshot> getAllcolor() {
    return _colorCollection.snapshots();
  }

  // Stream<QuerySnapshot> getProductVariations(String productId) {
  //   return _materialsCollection
  //       .doc(productId)
  //       .collection('variations')
  //       .snapshots();
  // }

  // Query a subcollection
  Stream<List<ColorModel>> streamColor() {
    return _colorCollection.orderBy('color').snapshots().map(
          (event) => event.docs
              .map(
                (e) => ColorModel.fromFirestore(e),
              )
              .toList()
              .cast(),
        );
  }

  // Future<String?> getProductImage(String productId) async {
  //   try {
  //     DocumentSnapshot productDoc =
  //         await _materialsCollection.doc(productId).get();

  //     if (productDoc.exists) {
  //       // Check if the product document exists
  //       Map<String, dynamic> productData =
  //           productDoc.data() as Map<String, dynamic>;

  //       // Retrieve the image URL from the product data
  //       String imageUrl = productData['product_images'][0];

  //       return imageUrl;
  //     } else {
  //       // Handle the case where the product doesn't exist
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting product image: $e');
  //     return null;
  //   }
  // }

  // Future<String?> getProductName(String productId) async {
  //   try {
  //     DocumentSnapshot productDoc =
  //         await _materialsCollection.doc(productId).get();

  //     if (productDoc.exists) {
  //       // Check if the product document exists
  //       Map<String, dynamic> productData =
  //           productDoc.data() as Map<String, dynamic>;

  //       // Retrieve the image URL from the product data
  //       String productName = productData['product_name'];

  //       return productName;
  //     } else {
  //       // Handle the case where the product doesn't exist
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error getting product image: $e');
  //     return null;
  //   }
  // }
}