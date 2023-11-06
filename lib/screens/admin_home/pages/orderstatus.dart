import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse_admin/firebasefiles/firebase_user_notification.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';

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
                child: ListView(
                  children: const [
                    OrdersCard(),
                    OrdersCard(),
                    OrdersCard(),
                    OrdersCard(),
                    OrdersCard(),
                  ],
                )
              ),
            ]
          )
        ),
      ),
    );
  }
}

class OrdersCard extends StatefulWidget {
  const OrdersCard({super.key});

  @override
  State<OrdersCard> createState() => _OrdersCardState();
}

class _OrdersCardState extends State<OrdersCard> {

  
    final List<String> items = [
    'Processing',
    'On Delivery',
    'Delivered',
  ];
  String? selectedValue, samplel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #238562312',
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 16,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              Text(
                '20/03/2023',
                textAlign: TextAlign.right,
                style: TextStyle(
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
        const Padding(
          padding: EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Quantity: ',
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: '03',
                      style: TextStyle(
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
                    TextSpan(
                      text: 'Total Amount: ',
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '₱2,200',
                      style: TextStyle(
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
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    selectedValue ?? items[0],
                    style: const TextStyle(
                      color: Color(0xFF44444F),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  items: items
                  .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  )).toList(),

                  value: selectedValue,

                  onChanged: (String? value) {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationAlertDialog(
                        title: "",
                        content: const Text(
                          "Are you sure you want to update the status?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),

                        onTapYes: () => {
                          setState(() {
                            selectedValue = value;
                          }),

                          notifyUser(value),
                        },
                        onTapNo: () => Navigator.pop(context),
                        
                        tapYesString: "Yes",
                        tapNoString: "No",
                      )
                    );    
                  },

                  buttonStyleData: const ButtonStyleData(
                    height: 40,
                    width: 110,
                  ),
                  
                  menuItemStyleData: const MenuItemStyleData(height: 40),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  notifyUser(value){
    FirebaseFirestore.instance.collection('users').doc("CzKVkPWfrxcsLbac6qT28MDWGom1")
          //.where("uid", isEqualTo: "Q3tRGI2r4n8rUkGArsla")
      .get().then((ds) {
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
