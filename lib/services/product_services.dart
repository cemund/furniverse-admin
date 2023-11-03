import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Map<String, dynamic> productData,
      List<Map<String, dynamic>> productVariations) async {
    try {
      print('hello');
      DocumentReference productDocRef =
          await _productsCollection.add(productData);

      for (int i = 0; i < productVariations.length; i++) {
        await productDocRef.collection('variants').add(productVariations[i]);
      }
    } catch (e) {
      print('Error adding a product: $e');
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
}
