import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furniverse_admin/models/request.dart';
import 'package:furniverse_admin/services/request_services.dart';
import 'package:furniverse_admin/widgets/confirmation_dialog.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage(
      {super.key,
      required this.request,
      required this.userName,
      required this.contactNumber,
      required this.productName});

  final CustomerRequests request;
  final String userName;
  final String contactNumber;
  final String productName;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _materialController = TextEditingController();
  final _othersController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  String phone = "09876543212";
  String customerName = "";

  @override
  void initState() {
    super.initState();
    phone = widget.contactNumber;
    customerName = widget.userName;
    _sizeController.text = widget.request.size;
    _colorController.text = widget.request.color;
    _materialController.text = widget.request.material;
    _othersController.text = widget.request.others;
    _priceController.text = widget.request.price?.toStringAsFixed(2) ?? "";
    _quantityController.text = widget.request.reqquantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: const Color(0xFFF0F0F0),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: const Text(
              'Customer Request',
              style: TextStyle(
                color: Color(0xFF303030),
                fontSize: 16,
                fontFamily: 'Avenir Next LT Pro',
                fontWeight: FontWeight.w700,
              ),
            )),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product ID: ${widget.request.productId}",
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 14,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              Text(
                widget.productName,
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 18,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Customer ID: ${widget.request.userId}",
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 14,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              Text(
                customerName,
                style: const TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 18,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Contact Number:",
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 14,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    phone,
                    style: const TextStyle(
                      color: Color(0xFF303030),
                      fontSize: 18,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 25,
                    child: ElevatedButton(
                      onPressed: () async {
                        final Uri url = Uri(scheme: 'tel', path: phone);

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          print("Invalid Number");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                      child: const Text(
                        "Call",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: _sizeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  labelText: 'Size',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: _colorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  labelText: 'Color',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: _materialController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  labelText: 'Material',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: _othersController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  labelText: 'Other/s',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: _quantityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  labelText: 'Quantity',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly:
                    (!(widget.request.reqStatus.toUpperCase() == 'PENDING')),
                controller: _priceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  labelText: 'Price',
                  hintText: "0.00",
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 20),
              if (widget.request.reqStatus.toUpperCase() == 'PENDING')
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text(
                            "REJECT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ConfirmationAlertDialog(
                                  title:
                                      "Are you sure you want to accept the request with amount of ₱${_priceController.text}.00?",
                                  onTapNo: () {
                                    Navigator.pop(context);
                                  },
                                  onTapYes: () async {
                                    await RequestsService().acceptRequest(
                                        widget.request.id,
                                        double.parse(_priceController.text));
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  tapNoString: "No",
                                  tapYesString: "Yes"),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text(
                            "ACCEPT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        )),
      ),
    );
  }
}
