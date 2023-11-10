import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final List<dynamic> images;
  final String description;
  final List<dynamic> variants;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.images,
    required this.variants,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    print(data);

    return Product(
        id: doc.id,
        name: data['product_name'] ?? '',
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        images: data['product_images'],
        variants: data['variants']);
  }

  int getNumVariants() {
    return variants.length;
  }

  int getNumStocks() {
    int numOfStocks = 0;
    for (int i = 0; i < variants.length; i++) {
      numOfStocks += variants[i]['stocks'] as int;
    }
    return numOfStocks;
  }

  double getLeastPrice() {
    double leastPrice = variants[0]['price'];
    if (variants.length == 1) {
      return leastPrice;
    }

    for (int i = 1; i < variants.length; i++) {
      if (leastPrice > variants[i]['price']) {
        leastPrice = variants[i]['price'];
      }
    }
    return leastPrice;
  }
}
