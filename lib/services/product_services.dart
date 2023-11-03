import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      print('hello');
      await _productsCollection.add(productData);
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
