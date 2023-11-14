import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/models/analytics.dart';
import 'package:furniverse_admin/models/order.dart';
import 'package:furniverse_admin/models/products.dart';
import 'package:furniverse_admin/screens/admin_home/pages/pdf_preview_page.dart';
import 'package:furniverse_admin/services/analytics_services.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:furniverse_admin/widgets/line_chart_widget.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<int> years = [];
  List<Product> products = [];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrderModel>?>(context);

    if (orders == null) {
      return const Center(
        child: Loading(),
      );
    }

    for (int i = 0; i < orders.length; i++) {
      int year = orders[i].orderDate.toDate().year;

      if (!years.contains(year)) {
        years.add(year);
      }
    }

    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
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
                      "Show year: ",
                      style: TextStyle(
                        color: Color(0xFF92929D),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (years.isNotEmpty)
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          // alignment: Alignment.centerRight,
                          isExpanded: true,
                          hint: Text(
                            selectedValue ?? years[0].toString(),
                            style: const TextStyle(
                              color: Color(0xFF44444F),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          items: years
                              .map(
                                (int item) => DropdownMenuItem<String>(
                                  value: item.toString(),
                                  child: Text(
                                    item.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          value: selectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            width: 60,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 30,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
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
                  onTap: () async {
                    final ordersPerProvince = await AnalyticsServices()
                        .getOrdersPerProvince(
                            int.parse(selectedValue ?? years[0].toString()));
                    final ordersPerProduct = await AnalyticsServices()
                        .getOrdersPerProduct(
                            int.parse(selectedValue ?? years[0].toString()));

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfPreviewPage(
                            ordersPerProvince: ordersPerProvince,
                            ordersPerProduct: ordersPerProduct,
                            year:
                                int.parse(selectedValue ?? years[0].toString()),
                          ),
                        ),
                      );
                    }
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
        years.isNotEmpty
            ? StreamProvider.value(
                value: OrderService().streamOrdersByYear(
                    int.parse(selectedValue ?? years[0].toString())),
                initialData: null,
                child: Analytics(
                    years: years,
                    year: int.parse(selectedValue ?? years[0].toString())))
            : const Center(child: Text("No data for analytics")),
      ],
    );
  }
}

class Analytics extends StatelessWidget {
  const Analytics({
    super.key,
    required this.year,
    required this.years,
  });
  final int year;
  final List<int> years;

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrderModel>?>(context);

    if (orders == null) {
      return const Center(
        child: Loading(),
      );
    }

    // not cancelled orders
    final fullOrders = orders.map(
      (e) {
        if (e.shippingStatus.toUpperCase() != 'CANCELLED') return e;
      },
    ).toList();

    if (fullOrders[0] == null) {
      return const Center(child: Text("No data for analysis"));
    }

    // total revenue
    double sales = 0.0;
    List<double> amountPerTransaction = [];
    for (int i = 0; i < fullOrders.length; i++) {
      sales += fullOrders[i]!.totalPrice;
      amountPerTransaction.add(fullOrders[i]!.totalPrice);
    }

    // monthly sales
    Map<String, dynamic> monthlySales = {};
    for (var order in fullOrders) {
      // final month = DateFormat('MMMM')
      //     .format(DateTime(0, order?.orderDate.toDate().month ?? 0));
      final month = order!.orderDate.toDate().month.toString();
      monthlySales.putIfAbsent(month, () => 0);
      monthlySales[month] = monthlySales[month]! + order.totalPrice;
    }

    // all products
    Map<String, int> products = {};
    for (int i = 0; i < fullOrders.length; i++) {
      for (int j = 0; j < fullOrders[i]!.products.length; j++) {
        products.putIfAbsent(fullOrders[i]!.products[j]['productId'], () => 0);
        products[fullOrders[i]!.products[j]['productId']] =
            (products[fullOrders[i]!.products[j]['productId']]! +
                fullOrders[i]!.products[j]['quantity'] as int);
      }
    }

    Map<String, dynamic> ordersPerProvince = {};
    for (var order in fullOrders) {
      final province =
          order!.shippingProvince == "" ? 'Others' : order.shippingProvince;
      ordersPerProvince.putIfAbsent(
          province, () => {"users": [], "quantity": 0, "total": 0});

      // add users
      if (!ordersPerProvince[province]['users'].contains(order.userId)) {
        ordersPerProvince[province]['users'].add(order.userId);
      }

      // increment quantity
      ordersPerProvince[province]['quantity'] =
          ordersPerProvince[province]['quantity'] + 1;

      // add total
      ordersPerProvince[province]['total'] =
          ordersPerProvince[province]['total'] + order.totalPrice;
    }

    // products
    int totalQuantity = 0;
    Map<String, dynamic> ordersPerProduct = {};
    for (var order in fullOrders) {
      if (order?.products != null) {
        for (var product in order!.products) {
          final productId = product['productId'];
          ordersPerProduct.putIfAbsent(
              productId, () => {"quantity": 0, "total": 0.0});

          // add quantity
          ordersPerProduct[productId]['quantity'] =
              ordersPerProduct[productId]['quantity'] + product['quantity'];

          // add total quantity
          totalQuantity = totalQuantity + product['quantity'] as int;

          // add total
          ordersPerProduct[productId]['total'] =
              ordersPerProduct[productId]['total'] + product['totalPrice'];
        }
      }
    }

    //sorting top products
    if (products.isNotEmpty) {
      // Convert the map to a list of entries
      List<MapEntry<String, int>> sortedEntries = products.entries.toList();

      // Sort the list based on the values
      sortedEntries.sort((a, b) => b.value.compareTo(a.value));

      // Create a new map using the sorted entries
      products = Map.fromEntries(sortedEntries);
    }

    AnalyticsServices().updateAnalytics(
      year,
      AnalyticsModel(
        totalQuantity: totalQuantity,
        year: year,
        totalRevenue: sales,
        averageOrderValue: amountPerTransaction.average,
        topProducts: products,
        monthlySales: monthlySales,
        ordersPerProvince: ordersPerProvince,
        ordersPerProduct: ordersPerProduct,
      ),
    );

    return Column(
      children: [
        SizedBox(
          // height: 250,
          height: 125,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: (1 / .7),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: [
              Report(
                title: 'Total Revenue',
                previous: 21340,
                percent: 2.5,
                price: sales,
                hasPrevious: years.contains(year - 1),
                year: year,
              ),
              AOVReport(
                title: 'Average Order Value',
                previous: 21340,
                percent: 2.5,
                price: amountPerTransaction.average,
                hasPrevious: years.contains(year - 1),
                year: year,
              ),
              // const Report(
              //   title: 'Return',
              //   previous: 21340,
              //   percent: 2.5,
              //   price: 60289,
              // ),
              // const Report(
              //   title: 'Marketing',
              //   previous: 21340,
              //   percent: 2.5,
              //   price: 60289,
              // ),
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
              LineChartWidget(
                monthlySales: monthlySales,
                year: year,
                hasPrevious: years.contains(year - 1),
              ),
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
              for (int i = 0; i < products.length; i++) ...[
                TopProducts(
                    productId: products.keys.elementAt(i),
                    quantity: products.values.elementAt(i),
                    index: i)
              ],
              // Align(
              //   alignment: Alignment.center,
              //   child: TextButton(
              //       onPressed: () {},
              //       child: const Text(
              //         'VIEW MORE PRODUCTS',
              //         style: TextStyle(
              //           color: Color(0xFFF6BE2C),
              //           fontSize: 12,
              //           fontFamily: 'Inter',
              //           fontWeight: FontWeight.w500,
              //         ),
              //       )),
              // )
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
    required this.productId,
    required this.quantity,
    required this.index,
  });

  final String productId;
  final int quantity;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: FutureBuilder<String?>(
          future: ProductService().getProductImage(productId),
          builder: (context, snapshot) {
            return CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                snapshot.data ?? "http://via.placeholder.com/350x150",
              ),
            );
          }),
      title: FutureBuilder<String?>(
          future: ProductService().getProductName(productId),
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? "",
              style: const TextStyle(
                color: Color(0xFF171625),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
                letterSpacing: 0.10,
              ),
            );
          }),
      subtitle: Text(
        'Sales: $quantity',
        style: const TextStyle(
          color: Color(0xFF92929D),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: index == 0
          ? SizedBox(
              height: 30,
              width: 30,
              child: Image.asset('assets/images/top1.png'),
            )
          : index == 1
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/images/top2.png'),
                )
              : index == 2
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/images/top3.png'),
                    )
                  : const SizedBox(),
    );
  }
}

class Report extends StatelessWidget {
  final String title;
  final double price;
  final int previous;
  final double percent;
  final bool hasPrevious;
  final int year;

  const Report({
    super.key,
    required this.title,
    required this.price,
    required this.previous,
    required this.percent,
    required this.hasPrevious,
    required this.year,
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
              // Text(
              //   '+$percent%',
              //   style: const TextStyle(
              //     color: Color(0xFF3DD598),
              //     fontSize: 12,
              //     fontFamily: 'Inter',
              //     fontWeight: FontWeight.w600,
              //     height: 0,
              //   ),
              // ),
              // const Icon(
              //   Icons.arrow_upward_rounded,
              //   size: 12,
              //   color: Color(0xFF3DD598),
              // ),
            ],
          ),
          Text(
            '₱${price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF171725),
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          hasPrevious
              ? FutureBuilder<double>(
                  future: AnalyticsServices().getTotalRevenue(year - 1),
                  builder: (context, snapshot) {
                    return Text(
                      'Compared to \n(₱${snapshot.data?.toStringAsFixed(2) ?? 0.0} last year)',
                      style: const TextStyle(
                        color: Color(0xFF92929D),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  })
              : const Gap(10),
        ],
      ),
    );
  }
}

class AOVReport extends StatelessWidget {
  final String title;
  final double price;
  final int previous;
  final double percent;
  final bool hasPrevious;
  final int year;

  const AOVReport({
    super.key,
    required this.title,
    required this.price,
    required this.previous,
    required this.percent,
    required this.hasPrevious,
    required this.year,
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
            ],
          ),
          Text(
            '₱${price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF171725),
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          hasPrevious
              ? FutureBuilder<double>(
                  future: AnalyticsServices().getAOV(year - 1),
                  builder: (context, snapshot) {
                    return Text(
                      'Compared to \n(₱${snapshot.data?.toStringAsFixed(2) ?? 0.0} last year)',
                      style: const TextStyle(
                        color: Color(0xFF92929D),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  })
              : const Gap(10),
        ],
      ),
    );
  }
}
