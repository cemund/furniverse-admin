import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/products.dart';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final productTimestamp =
          FieldValue.serverTimestamp(); // Get a server-side timestamp
      productData['timestamp'] =
          productTimestamp; // Add the timestamp to your data
      DocumentReference productDocRef =
          await _productsCollection.add(productData);

      // for (int i = 0; i < productVariations.length; i++) {
      //   await productDocRef.collection('variants').add(productVariations[i]);
      // }
    } catch (e) {
      print('Error adding a product: $e');
    }
  }
  // Future<void> addProduct(Map<String, dynamic> productData,
  //     List<Map<String, dynamic>> productVariations) async {
  //   try {
  //     final productTimestamp =
  //         FieldValue.serverTimestamp(); // Get a server-side timestamp
  //     productData['timestamp'] =
  //         productTimestamp; // Add the timestamp to your data
  //     DocumentReference productDocRef =
  //         await _productsCollection.add(productData);

  //     for (int i = 0; i < productVariations.length; i++) {
  //       await productDocRef.collection('variants').add(productVariations[i]);
  //     }
  //   } catch (e) {
  //     print('Error adding a product: $e');
  //   }
  // }

  Future<void> deleteProduct(String productId) async {
    try {
      // delete file in firestorage

      await _productsCollection.doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Stream<QuerySnapshot> getAllProducts() {
    return _productsCollection.snapshots();
  }

  Stream<QuerySnapshot> getProductVariations(String productId) {
    return _productsCollection
        .doc(productId)
        .collection('variations')
        .snapshots();
  }

  // Query a subcollection
  Stream<List<Product>> streamProducts() {
    return _productsCollection.orderBy('product_name').snapshots().map(
          (event) => event.docs
              .map(
                (e) => Product.fromFirestore(e),
              )
              .toList()
              .cast(),
        );
  }
}
