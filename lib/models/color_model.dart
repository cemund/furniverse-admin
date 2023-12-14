import 'package:cloud_firestore/cloud_firestore.dart';

class ColorModel {
  final String id;
  String color;
  double price;
  int stocks;
  String hexValue;

  ColorModel({
    required this.id,
    required this.color,
    required this.price,
    required this.stocks,
    required this.hexValue,
  });

  factory ColorModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ColorModel(
      id: doc.id,
      color: data['color'] ?? '',
      stocks: data['stocks'] ?? '',
      price: data['price'] ?? '',
      hexValue: data['hexValue'] ?? '',
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
