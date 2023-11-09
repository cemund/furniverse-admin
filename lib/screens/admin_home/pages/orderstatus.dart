import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse_admin/firebasefiles/firebase_user_notification.dart';
import 'package:furniverse_admin/models/order.dart';
import 'package:furniverse_admin/services/messaging_services.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/shared/constants.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key});

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  final List<String> items = [
    'Processing',
    'On Delivery',
    'Delivered',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrderModel>?>(context);

    if (orders == null) {
      return const Center(
        child: Loading(),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset('assets/icons/chevron_left.svg'),
                  ),
                  const Column(
                    children: [
                      Text(
                        'ORDERS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF303030),
                          fontSize: 16,
                          fontFamily: 'Avenir Next LT Pro',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 24,
                  )
                ],
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return OrdersCard(
                      order: orders[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersCard extends StatefulWidget {
  const OrdersCard({super.key, required this.order});
  final OrderModel order;

  @override
  State<OrdersCard> createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {
  String? selectedValue, samplel;
  String? hintText;

  final messagingService = MessagingService();
  List<String> items = [
    'Pending',
    'Processing',
    'On Delivery',
    'Delivered',
    'Cancelled',
  ];

  void _updateDropdownItems() {
    setState(() {
      // Change the items list to update the dropdown options
      if (hintText?.toUpperCase() == 'Pending'.toUpperCase()) {
        items = ['Processing', 'Cancelled'];
      } else if (hintText?.toUpperCase() == 'Processing'.toUpperCase()) {
        items = [
          'On Delivery',
          'Cancelled',
        ];
      } else if (hintText?.toUpperCase() == 'On Delivery'.toUpperCase()) {
        items = [
          'Delivered',
          'Cancelled',
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    OrderModel order = widget.order;
    DateTime dateTime = order.orderDate.toDate();
    String orderDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    int quantity = 0;

    // get quantity
    for (int i = 0; i < order.products.length; i++) {
      quantity += order.products[i]['quantity'] as int;
    }
    hintText = order.shippingStatus;
    _updateDropdownItems();

    // initial selectedValue
    // if (order.shippingStatus.toUpperCase() == 'pending'.toUpperCase()) {
    //   items = [
    //     'Processing',
    //     'Cancelled',
    //   ];
    // }

    // if (order.shippingStatus.toUpperCase() == 'processing'.toUpperCase()) {
    //   items = [
    //     'On Delivery',
    //     'Cancelled',
    //   ];
    // }

    // if (order.shippingStatus.toUpperCase() == 'On Delivery'.toUpperCase()) {
    //   items = [
    //     'Delivered',
    //     'Cancelled',
    //   ];
    // }

    // String initialvalue = order.shippingStatus;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2.5,
                child: Text(
                  'ID: ${order.orderId.toUpperCase()}',
                  style: const TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                orderDate,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF909090),
                  fontSize: 14,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 2,
          decoration: ShapeDecoration(
            color: const Color(0xFFF0F0F0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Quantity: ',
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: quantity.toString(),
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '₱${order.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.right,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 36,
                decoration: const ShapeDecoration(
                  color: Color(0xFF303030),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: order.shippingStatus.toUpperCase() ==
                        'cancelled'.toUpperCase()
                    ? const Text(
                        "Cancelled",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : order.shippingStatus.toUpperCase() ==
                            'Delivered'.toUpperCase()
                        ? const Text(
                            "Delivered",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              alignment: Alignment.centerRight,
                              hint: Text(
                                hintText ?? "",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              items: items
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ConfirmationAlertDialog(
                                          title: "",
                                          content: const Text(
                                            "Are you sure you want to update the status?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          onTapYes: () {
                                            setState(() {
                                              // value = value;
                                            });
                                            if (value != null) {
                                              OrderService().updateStatus(
                                                  order.orderId, value);

                                              messagingService.notifyUser(
                                                  userId: order.userId,
                                                  message: value);
                                            }

                                            // notifyUser(value),
                                            // messagingService.notifyUser(
                                            //     userId: order.userId,
                                            //     message: value!);
                                            Navigator.pop(context);
                                          },
                                          onTapNo: () => Navigator.pop(context),
                                          tapYesString: "Yes",
                                          tapNoString: "No",
                                        ));
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                                width: 110,
                              ),
                              menuItemStyleData:
                                  const MenuItemStyleData(height: 40),
                            ),
                          ),
              ),
            ],
          ),
        )
      ],
    );
  }

  notifyUser(
    value,
  ) {
    FirebaseFirestore.instance
        .collection('users')
        .doc("CzKVkPWfrxcsLbac6qT28MDWGom1")
        //.where("uid", isEqualTo: "Q3tRGI2r4n8rUkGArsla")
        .get()
        .then((ds) {
      samplel = "${ds["token"]}";
      setState(() {});
    });

    FirebaseUserNotification().sendPushMessage(value!, samplel);

    Navigator.pop(context);
  }
}

class MyOrdersTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  const MyOrdersTab({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 103,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF303030)
                  : const Color(0xFF909090),
              fontSize: 18,
              fontFamily: 'Nunito Sans',
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 40,
            height: 4,
            decoration: ShapeDecoration(
              color: isSelected ? const Color(0xFF303030) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          )
        ],
      ),
    );
  }
}
