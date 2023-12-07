import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/materials_model.dart';

class MaterialsServices {
  final CollectionReference _materialsCollection =
      FirebaseFirestore.instance.collection('materials');

  Future<void> addMaterials(Map<String, dynamic> materialsData) async {
    try {
      final materialsTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      materialsData['timestamp'] =
          materialsTimestamp; // Add the timestamp to your data
      DocumentReference productDocRef =
          await _materialsCollection.add(materialsData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> deleteMaterial(String materialId) async {
    try {
      // delete file in firestorage

      await _materialsCollection.doc(materialId).delete();
    } catch (e) {
      print('Error deleting material: $e');
    }
  }

  Stream<DocumentSnapshot<Object?>> editMaterial(String materialId) {
    // delete file in firestorage
    return _materialsCollection.doc(materialId).snapshots();
  }

  Future<void> updateMaterial(
      Map<String, dynamic> materialData, String materialId) async {
    try {
      final materialTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      materialData['timestamp'] =
          materialTimestamp; // Add the timestamp to your data

      await _materialsCollection.doc(materialId).set(materialData);

      // for (int i = 0; i < materialVariations.length; i++) {
      //   await materialDocRef.collection('variants').add(materialVariations[i]);
      // }
    } catch (e) {
      print('Error adding a material: $e');
    }
  }

  Future<void> reducedQuantity(List<dynamic> materials) async {
    try {
      // await _materialsCollection
      //     .doc(materialId)
      //     .update({'quantity': FieldValue.increment(-quantity)});
      // print(materials);
      if (materials[0]['materialId'] == "") return;
      for (var material in materials) {
        DocumentSnapshot doc =
            await _materialsCollection.doc(material['materialId']).get();
        Map data = doc.data() as Map;
        var variants = data['variants'];
        List<Map> newVariants = [];
        for (var variant in variants) {
          if (variant['id'] == material['variationId']) {
            variant['stocks'] = variant['stocks'] - material['quantity'];
          }
          newVariants.add(variant);
        }
        await _materialsCollection
            .doc(material['materialId'])
            .update({'variants': newVariants});
        // .update({'quantity': FieldValue.increment(-quantity)});
      }
    } catch (e) {
      print('Error updating material quantity: $e');
    }
  }

  Future<void> addQuantity(List<dynamic> materials) async {
    try {
      // await _materialsCollection
      //     .doc(materialId)
      //     .update({'quantity': FieldValue.increment(-quantity)});
      // print(materials);
      if (materials[0]['materialId'] == "") return;
      for (var material in materials) {
        DocumentSnapshot doc =
            await _materialsCollection.doc(material['materialId']).get();
        Map data = doc.data() as Map;
        var variants = data['variants'];
        List<Map> newVariants = [];
        for (var variant in variants) {
          if (variant['id'] == material['variationId']) {
            variant['stocks'] = variant['stocks'] + material['quantity'];
          }
          newVariants.add(variant);
        }
        await _materialsCollection
            .doc(material['materialId'])
            .update({'variants': newVariants});
        // .update({'quantity': FieldValue.increment(-quantity)});
      }
    } catch (e) {
      print('Error updating material quantity: $e');
    }
  }

  Stream<QuerySnapshot> getAllmaterials() {
    return _materialsCollection.snapshots();
  }

  // Stream<QuerySnapshot> getProductVariations(String productId) {
  //   return _materialsCollection
  //       .doc(productId)
  //       .collection('variations')
  //       .snapshots();
  // }

  // Query a subcollection
  Stream<List<Materials>> streamMaterials() {
    return _materialsCollection.orderBy('material').snapshots().map(
          (event) => event.docs
              .map(
                (e) => Materials.fromFirestore(e),
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