import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerRequest extends StatefulWidget {
  const CustomerRequest({super.key});

  @override
  State<CustomerRequest> createState() => _CustomerRequestState();
}

class _CustomerRequestState extends State<CustomerRequest> {

  final _sizeController = TextEditingController();
  final _colorController = TextEditingController();
  final _materialController = TextEditingController();
  final _othersController = TextEditingController();
  final _priceController = TextEditingController();
  String phone = "09876543212";

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
          )
        ),
        body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Customer Name:",
                  style: TextStyle(
                    color: Color(0xFF303030),
                    fontSize: 14,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),

                const Text(
                  "John Doe",
                  style: TextStyle(
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
                          final Uri url =  Uri(
                            scheme: 'tel',
                            path: phone
                          );

                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            print("Invalid Number");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                        ),
                        child: const Text("Call",
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
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Size',
                  ),
                ),
                  
                const SizedBox(height: 20),
                
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Color',
                  ),
                ),
                  
                const SizedBox(height: 20),

                TextFormField(
                  controller: _materialController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Material',
                  ),
                ),
                  
                const SizedBox(height: 20),

                TextFormField(
                  controller: _othersController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Other/s',
                  ),
                ),
                  
                const SizedBox(height: 20),

                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    labelText: 'Price',
                  ),
                ),
                  
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                    ),
                    child: const Text("Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),     
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}