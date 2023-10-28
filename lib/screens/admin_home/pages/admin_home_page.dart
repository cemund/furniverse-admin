import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniverse_admin/screens/admin_home/pages/pdf_preview_page.dart';
import 'package:furniverse_admin/widgets/line_chart_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final List<String> items = [
    'This Year',
    'Year 2022',
    'Year 2021',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Products List',
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Show: ",
                      style: TextStyle(
                        color: Color(0xFF92929D),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.08,
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
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          height: 40,
                          width: 100,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print("hello");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PdfPreviewPage()));
                    // final pdf = pw.Document();
                    // pdf.addPage(
                    //   pw.Page(
                    //     build: (pw.Context context) => pw.Center(
                    //       child: pw.Text('Hello World!'),
                    //     ),
                    //   ),
                    // );

                    // final file = File('example.pdf');
                    // await file.writeAsBytes(await pdf.save());
                  },
                  child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xffF6BE2C)),
                      child: const Icon(
                        Icons.download,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 250,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: (1 / .7),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: const [
              Report(
                title: 'Sales',
                previous: 21340,
                percent: 2.5,
                price: 60289,
              ),
              Report(
                title: 'Purchase',
                previous: 21340,
                percent: 2.5,
                price: 60289,
              ),
              Report(
                title: 'Return',
                previous: 21340,
                percent: 2.5,
                price: 60289,
              ),
              Report(
                title: 'Marketing',
                previous: 21340,
                percent: 2.5,
                price: 60289,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales Figures',
                style: TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LineChartWidget(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Selling Products',
                style: TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const TopProducts(),
              const TopProducts(),
              const TopProducts(),
              const TopProducts(),
              const TopProducts(),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'VIEW MORE PRODUCTS',
                      style: TextStyle(
                        color: Color(0xFFF6BE2C),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}

class TopProducts extends StatelessWidget {
  const TopProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/table.jpeg'),
      ),
      title: const Text(
        'Coffee Chair',
        style: TextStyle(
          color: Color(0xFF171625),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 0,
          letterSpacing: 0.10,
        ),
      ),
      subtitle: const Text(
        'Sales: 12,567',
        style: TextStyle(
          color: Color(0xFF92929D),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: SizedBox(
          height: 30, width: 30, child: Image.asset('assets/images/top1.png')),
    );
  }
}

class Report extends StatelessWidget {
  final String title;
  final int price;
  final int previous;
  final double percent;

  const Report({
    super.key,
    required this.title,
    required this.price,
    required this.previous,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 123,
      padding: const EdgeInsets.all(14.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF171725),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '+$percent%',
                style: const TextStyle(
                  color: Color(0xFF3DD598),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const Icon(
                Icons.arrow_upward_rounded,
                size: 12,
                color: Color(0xFF3DD598),
              ),
            ],
          ),
          Text(
            '₱$price',
            style: const TextStyle(
              color: Color(0xFF171725),
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Compared to \n(₱$previous last year)',
            style: const TextStyle(
              color: Color(0xFF92929D),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
