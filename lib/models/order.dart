import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final Timestamp orderDate;
  final List<dynamic> products;
  final double totalPrice;
  final String shippingAddress;
  final String shippingMethod;
  final String shippingStatus;
  final Timestamp completedDate;
  final dynamic requestDetails;

  OrderModel(
      {required this.userId,
      required this.orderDate,
      required this.products,
      required this.totalPrice,
      required this.shippingAddress,
      required this.shippingMethod,
      required this.completedDate,
      required this.shippingStatus,
      required this.orderId,
      required this.requestDetails});

  factory OrderModel.fromMap(Map data, String orderId) {
    return OrderModel(
      orderId: orderId,
      userId: data['userId'] ?? "",
      completedDate: data['completedDate'] ?? Timestamp.now(),
      orderDate: data['orderDate'] ?? Timestamp.now(),
      shippingAddress: data['shippingAddress'] ?? "",
      shippingMethod: data['shippingMethod'] ?? "",
      shippingStatus: data['shippingStatus'] ?? "",
      totalPrice: data['totalPrice'] ?? 0.0,
      products: data['products'] ?? [],
      requestDetails: data['requestDetails'] ?? {},
    );
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] ?? "",
      completedDate: data['completedDate'] ?? Timestamp.now(),
      orderDate: data['orderDate'] ?? Timestamp.now(),
      shippingAddress: data['shippingAddress'] ?? "",
      shippingMethod: data['shippingMethod'] ?? "",
      shippingStatus: data['shippingStatus'] ?? "",
      totalPrice: data['totalPrice'] ?? 0.0,
      products: data['products'] ?? [],
      requestDetails: data['requestDetails'] ?? {},
    );
  }
}
