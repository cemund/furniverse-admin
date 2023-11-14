import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsModel {
  final int year;
  final int totalQuantity;
  final double totalRevenue;
  final double averageOrderValue;
  final Map<String, int> topProducts;
  final Map<String, dynamic> monthlySales;
  final Map<String, dynamic> ordersPerProvince;
  final Map<String, dynamic> ordersPerProduct;

  AnalyticsModel({
    required this.year,
    required this.totalRevenue,
    required this.averageOrderValue,
    required this.topProducts,
    required this.monthlySales,
    required this.ordersPerProvince,
    required this.ordersPerProduct,
    required this.totalQuantity,
  });

  Map<String, dynamic> getMap() {
    return {
      'year': year,
      'totalRevenue': totalRevenue,
      'averageOrderValue': averageOrderValue,
      'topProducts': topProducts,
      'monthlySales': monthlySales,
      'ordersPerProvince': ordersPerProvince,
      'ordersPerProduct': ordersPerProduct,
      'totalQuantity': totalQuantity,
    };
  }
}
