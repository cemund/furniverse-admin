import 'package:flutter/material.dart';
import 'package:furniverse_admin/screens/admin_home/pages/refundrequestdetail.dart';

class DeliveryMethodList extends StatefulWidget {
  const DeliveryMethodList({super.key});

  @override
  State<DeliveryMethodList> createState() => _DeliveryMethodListState();
}

class _DeliveryMethodListState extends State<DeliveryMethodList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return RefundRequestDetail();
              },
            ),
          );
          }, child: Text("data"))
        ],
      ),
    );
  }
}