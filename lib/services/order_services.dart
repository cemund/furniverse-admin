import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniverse_admin/models/order.dart';

class OrderService {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> placeOrder(String userId, Map<String, dynamic> orderData) async {
    try {
      await _ordersCollection.add(orderData);
    } catch (e) {
      print('Error placing an order: $e');
    }
  }

  Future<void> updateStatus(String orderId, String newStatus) async {
    try {
      await _ordersCollection.doc(orderId).update({
        'shippingStatus': newStatus,
      });
      print('Field updated successfully');
    } catch (e) {
      print('Error updating field: $e');
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

  Stream<OrderModel> streamOrder(String orderId) {
    print("hello");
    return _db
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((event) => OrderModel.fromMap(event.data() ?? {}, orderId));
  }
}
