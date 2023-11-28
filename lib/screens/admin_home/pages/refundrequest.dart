import 'package:flutter/material.dart';
import 'package:furniverse_admin/screens/admin_home/pages/refundrequestdetail.dart';

class RefundRequest extends StatefulWidget {
  const RefundRequest({super.key});

  @override
  State<RefundRequest> createState() => _RefundRequestState();
}

class _RefundRequestState extends State<RefundRequest> {
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