import 'dart:typed_data';

import 'package:furniverse_admin/models/sales_analytics.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makePDF() async {
  final pdf = Document();
  pdf.addPage(Page(
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 14),
      build: (context) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration:
                const BoxDecoration(color: PdfColor.fromInt(0xff6F2C3E)),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "A.C.Q WOOD WORKS",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 24,
                  ),
                ),
                Text(
                  "Malolos, Bulacan",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 18,
                  ),
                ),
                Text(
                  "www.facebook.com/ACQWoodWorks",
                  style: const TextStyle(
                    color: PdfColor.fromInt(0xFFFFFFFF),
                    fontSize: 16,
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          SizedBox(height: 20),
          _buildCityTable(),
          SizedBox(height: 20),
          _buildCityTable(),
          SizedBox(height: 40),
          Container()
        ]);
      }));
  return pdf.save();
}

Table _buildCityTable() {
  return Table(children: [
    TableRow(children: [
      Expanded(
        child: Text(""),
      ),
      _buildHeader(title: "Population"),
      _buildHeader(title: "Total Retail Sales"),
      _buildHeader(title: "Per Capita Income"),
      _buildHeader(title: "Trade Area Capture"),
      _buildHeader(title: "Total Sales Pull Factor"),
    ]),
    _buildCityRow(),
    _buildCityRow(),
  ]);
}

TableRow _buildCityRow() {
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
                  "Malolos",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                  ),
                ),
              )),
        ),
        _buildNextCell(value: 2000000),
        _buildNextCell(value: 2000000),
        _buildNextCell(value: 2000000),
        _buildNextCell(value: 2000000),
        _buildNextCell(value: 2000000),
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

Container _buildNextCell({required int? value}) {
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
