import 'package:cloud_firestore/cloud_firestore.dart';

class Materials {
  final String id;
  String material;
  double price;
  int stocks;

  Materials({
    required this.id,
    required this.material,
    required this.price,
    required this.stocks,
  });

  factory Materials.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Materials(
      id: doc.id,
      material: data['material'] ?? '',
      stocks: data['stocks'] ?? '',
      price: data['price'] ?? '',
    );
  }


  // int getNumStocks() {
  //   int numOfStocks = 0;
  //   for (int i = 0; i < variants.length; i++) {
  //     numOfStocks += variants[i]['stocks'] as int;
  //   }
  //   return numOfStocks;
  // }
}
