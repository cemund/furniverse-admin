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
      DocumentReference productDocRef = await _colorCollection.add(colorsData);

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

  Future<void> reducedQuantity(String colorId, double quantity) async {
    try {
      final colors = await _colorCollection.doc(colorId).get();
      if (colors.exists) {
        double currentStocks = (colors.data() as Map)['stocks'].toDouble() ?? 0;

        if (currentStocks >= quantity) {
          await _colorCollection
              .doc(colorId)
              .update({'stocks': FieldValue.increment(-quantity)});
        } else {
          // Handle the case where there are not enough stocks
          print('Not enough stocks available for ColorId: $colorId.');
        }

        await _colorCollection
            .doc(colorId)
            .update({'sales': FieldValue.increment(1)});
      } else {
        print("Color Id: $colorId does not exist.");
      }
    } catch (e) {
      print('Error updating color quantity: $e');
    }
  }

  Future<void> addQuantity(String colorId, double quantity) async {
    try {
      final colors = await _colorCollection.doc(colorId).get();
      if (colors.exists) {
        await _colorCollection
            .doc(colorId)
            .update({'stocks': FieldValue.increment(quantity)});

        int sales = (colors.data() as Map)['sales'] ?? 0;
        if (sales > 0) {
          await _colorCollection
              .doc(colorId)
              .update({'sales': FieldValue.increment(-1)});
        }
      } else {
        print("Color Id: $colorId does not exist.");
      }

      //TODO: add sales
    } catch (e) {
      print('Error updating color quantity: $e');
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
