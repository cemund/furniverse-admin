import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/analytics.dart';

class AnalyticsServices {
  final _db = FirebaseFirestore.instance;

  Future<void> updateAnalytics(int year, AnalyticsModel analytics) async {
    try {
      Map<String, dynamic> analyticsMap = analytics.getMap();
      analyticsMap['dateUpdated'] = FieldValue.serverTimestamp();

      await _db.collection('analytics').doc(year.toString()).set(analyticsMap);
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<bool> hasPrevious(int year) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('analytics').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Access document data using documentSnapshot.data()
        if (documentSnapshot.id == (year - 1).toString()) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error adding product to cart: $e');
      return false;
    }
  }

  Future<double> getTotalRevenue(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        double totalRevenue = analyticsData['totalRevenue'];

        return totalRevenue;
      }

      return 0.0;
    } catch (e) {
      print('Error adding product to cart: $e');
      return 0.0;
    }
  }

  Future<double> getAOV(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        double totalRevenue = analyticsData['averageOrderValue'];

        return totalRevenue;
      }

      return 0.0;
    } catch (e) {
      print('Error adding product to cart: $e');
      return 0.0;
    }
  }

  Future<int> getTotalQuantity(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        int totalQuantity = analyticsData['totalQuantity'];

        return totalQuantity;
      }

      return 0;
    } catch (e) {
      print('Error adding product to cart: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>> getMonthlySales(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        Map<String, dynamic> monthlyRevenue = analyticsData['monthlySales'];

        return monthlyRevenue;
      }

      return {};
    } catch (e) {
      print('Error adding product to cart: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getOrdersPerProvince(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        Map<String, dynamic> ordersPerProvince =
            analyticsData['ordersPerProvince'];

        return ordersPerProvince;
      }

      return {};
    } catch (e) {
      print('Error adding product to cart: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getOrdersPerProduct(int year) async {
    try {
      DocumentSnapshot analyticsDoc =
          await _db.collection('analytics').doc(year.toString()).get();
      if (analyticsDoc.exists) {
        // Check if the product document exists
        Map<String, dynamic> analyticsData =
            analyticsDoc.data() as Map<String, dynamic>;

        // Retrieve the image URL from the product data
        Map<String, dynamic> ordersPerProvince =
            analyticsData['ordersPerProduct'];

        return ordersPerProvince;
      }

      return {};
    } catch (e) {
      print('Error adding product to cart: $e');
      return {};
    }
  }
}