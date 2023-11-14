import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsModel {
  final int year;
  final double totalRevenue;
  final double averageOrderValue;
  final Map<String, int> topProducts;
  final Map<String, dynamic> monthlySales;

  AnalyticsModel({
    required this.year,
    required this.totalRevenue,
    required this.averageOrderValue,
    required this.topProducts,
    required this.monthlySales,
  });

  Map<String, dynamic> getMap() {
    return {
      'year': year,
      'totalRevenue': totalRevenue,
      'averageOrderValue': averageOrderValue,
      'topProducts': topProducts,
      'monthlySales': monthlySales,
    };
  }
}
