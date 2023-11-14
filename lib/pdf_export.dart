import 'dart:typed_data';

import 'package:furniverse_admin/models/sales_analytics.dart';
import 'package:furniverse_admin/shared/company_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makePDF(Map<String, dynamic> ordersPerProvince) async {
  final pdf = Document();
  print(ordersPerProvince);

  List<Widget> widgets = [];

  // company name
  var companyInfo = Container(
    decoration: const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Text(
          companyName,
          style: const TextStyle(
            color: PdfColor.fromInt(0xFFFFFFFF),
            fontSize: 24,
          ),
        ),
        Text(
          companyAddress,
          style: const TextStyle(
            color: PdfColor.fromInt(0xFFFFFFFF),
            fontSize: 18,
          ),
        ),
        Text(
          companyLink,
          style: const TextStyle(
            color: PdfColor.fromInt(0xFFFFFFFF),
            fontSize: 16,
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
  );
  widgets.add(companyInfo);

  // sized box
  widgets.add(SizedBox(height: 20));

  // location table
  widgets.add(_buildCityTable(ordersPerProvince));

  // sized box
  widgets.add(SizedBox(height: 20));

  // product table title
  widgets.add(
    Table(
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: TableBorder(
              bottom: BorderSide(color: PdfColors.white),
            ),
          ),
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.all(10),
                decoration:
                    const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
                child: Text(
                  "Furniture Retail Sales Analysis",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );

  // product table
  widgets.add(
    Table(
      children: [
        // Headers
        TableRow(
          children: [
            Expanded(
              child: _buildHeader(title: "Furniture"),
            ),
            _buildHeader(title: "Total Retail Sales"),
            _buildHeader(title: "Potential Retail Sales"),
            _buildHeader(title: "Surplus/Leakage"),
            _buildHeader(title: "Trade Area Capture"),
            _buildHeader(title: "Pull Factor"),
          ],
        ),

        // total
        // _buildCityRow("Total"),

        // // loop
        // for (int i = 0; i < 20; i++) _buildCityRow("Coffee Table")
      ],
    ),
  );

  pdf.addPage(MultiPage(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      build: (context) => widgets));
  return pdf.save();
}

Table _buildCityTable(Map<String, dynamic> ordersPerProvince) {
  final provinces = ordersPerProvince.keys.toList();

  return Table(children: [
    TableRow(children: [
      Expanded(
        child: Text(""),
      ),
      _buildHeader(title: "No. of Customers"),
      _buildHeader(title: "No. of Orders"),
      _buildHeader(title: "Total Revenue"),
      // _buildHeader(title: "Trade Area Capture"),
      // _buildHeader(title: "Total Sales Pull Factor"),
    ]),
    for (var province in provinces) ...[
      _buildCityRow(
          title: province,
          noOfUsers: ordersPerProvince[province]['users'].length,
          quantity: ordersPerProvince[province]['quantity'],
          totalRevenue: ordersPerProvince[province]['total'])
    ],
    // _buildCityRow("Malolos"),
    // _buildCityRow("Hagonoy"),
  ]);
}

TableRow _buildCityRow(
    {required String title,
    required int noOfUsers,
    required int quantity,
    required double totalRevenue}) {
  print(noOfUsers);
  return TableRow(
      decoration: const BoxDecoration(
          border: TableBorder(bottom: BorderSide(color: PdfColors.black))),
      children: [
        Expanded(
          child: Container(
              height: 25,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                  ),
                ),
              )),
        ),
        _buildNextCell(value: noOfUsers),
        _buildNextCell(value: quantity),
        _buildNextCell(value: totalRevenue),
        // _buildNextCell(value: 2000000),
        // _buildNextCell(value: 2000000),
      ]);
}

Container _buildHeader({required String title}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 1),
    width: 90,
    height: 50,
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: PdfColor.fromInt(0xFFFFFFFF),
        fontSize: 12,
      ),
    ),
  );
}

Container _buildNextCell({required dynamic value}) {
  return Container(
    width: 90,
    height: 25,
    padding: const EdgeInsets.all(5),
    child: Text(
      value.toString(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: PdfColors.black,
        fontSize: 12,
      ),
    ),
  );
}
