import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/order.dart';

class OrderService {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateStatus(String orderId, String newStatus) async {
    try {
      await _ordersCollection.doc(orderId).update({
        'shippingStatus': newStatus,
      });
      print('Status updated successfully');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _ordersCollection.where('userId', isEqualTo: userId).snapshots();
  }

  Stream<List<OrderModel>> streamOrders() {
    return _ordersCollection
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) {
                return OrderModel.fromFirestore(e);
              },
            )
            .toList()
            .cast());
  }

  Stream<List<OrderModel>> streamOrdersByYear(int year) {
    DateTime startOfYear = DateTime(year, 1, 1);
    DateTime endOfYear = DateTime(year + 1, 1, 1);
    return _ordersCollection
        .where('orderDate', isGreaterThanOrEqualTo: startOfYear)
        .where('orderDate', isLessThan: endOfYear)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) {
                return OrderModel.fromFirestore(e);
              },
            )
            .toList()
            .cast());
  }

  Stream<OrderModel> streamOrder(String orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((event) => OrderModel.fromMap(event.data() ?? {}, orderId));
  }
}
