import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniverse_admin/models/order.dart';
import 'package:furniverse_admin/models/products.dart';
import 'package:furniverse_admin/models/user.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/user_services.dart';
import 'package:furniverse_admin/shared/loading.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage(
      {super.key, required this.orderId, required this.userId});

  final String orderId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: OrderService().streamOrder(orderId), initialData: null),
        StreamProvider.value(
            value: UserService().streamUser(userId), initialData: null),
      ],
      child: SafeArea(
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
                'ORDER DETAILS',
                style: TextStyle(
                  color: Color(0xFF303030),
                  fontSize: 16,
                  fontFamily: 'Avenir Next LT Pro',
                  fontWeight: FontWeight.w700,
                ),
              )),
          body: Body(
            orderId: orderId,
          ),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    super.key,
    required this.orderId,
  });
  final String orderId;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    //tariff calculation API
    double deliveryFee = 200.0;

    var products = Provider.of<List<Product>?>(context);
    final order = Provider.of<OrderModel?>(context);
    final user = Provider.of<UserModel?>(context);

    if (products == null || order == null || user == null) {
      return const Center(
        child: Loading(),
      );
    }

    DateTime dateTime = order.orderDate.toDate();
    String orderDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

    List<Product> orderedProducts = [];

    for (int i = 0; i < order.products.length; i++) {
      for (int j = 0; j < products.length; j++) {
        if (products[j].id == order.products[i]['productId']) {
          orderedProducts.add(products[j]);
          break;
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const Text(
                  "Products",
                  style: TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                for (int i = 0; i < orderedProducts.length; i++) ...[
                  OrderListTile(
                    product: orderedProducts[i],
                    variantId: order.products[i]['variationId'],
                    quantity: order.products[i]['quantity'],
                  ),
                ],
                const Gap(10),
                const Text(
                  "Shipping Address",
                  style: TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Color(0xFF303030),
                          fontSize: 18,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      Text(
                        user.contactNumber,
                        style: const TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 14,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        order.shippingAddress.toString(),
                        style: const TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 14,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                const Text(
                  "Payment",
                  style: TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icons/codicon.svg'),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Cash On Delivery (COD)",
                          style: TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 14,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Delivery Method",
                  style: TextStyle(
                    color: Color(0xFF909090),
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: order.shippingMethod == 'J&T'
                          ? Image.asset('assets/images/jandt.jpg')
                          : Image.asset('assets/images/ninjavan.jpg'),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          order.shippingMethod == 'J&T'
                              ? "Fast (5 - 7 days)"
                              : "NinjaVan (10 days)",
                          style: const TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 14,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Delivery Fee:",
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      "₱${deliveryFee.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 18,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      "₱${order.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 18,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Order Date:",
                      style: TextStyle(
                        color: Color(0xFF909090),
                        fontSize: 16,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      orderDate,
                      style: const TextStyle(
                        color: Color(0xFF303030),
                        fontSize: 18,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Status:",
                        style: TextStyle(
                          color: Color(0xFF909090),
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                        )),
                    const Gap(10),
                    Text(
                      order.shippingStatus.toUpperCase(),
                      style: TextStyle(
                        color: order.shippingStatus == 'cancelled'
                            ? Colors.red[300]
                            : const Color(0xFF27AE60),
                        fontSize: 18,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderListTile extends StatefulWidget {
  const OrderListTile({
    super.key,
    required this.product,
    required this.variantId,
    required this.quantity,
  });

  final Product product;
  final String variantId;
  final int quantity;

  @override
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  int selectedVariantIndex = 0;
  String title = "";
  String price = "";

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.product.variants.length; i++) {
      if (widget.product.variants[i]['id'] == widget.variantId) {
        selectedVariantIndex = i;
        break;
      }
    }
    title =
        "${widget.product.name} (${widget.product.variants[selectedVariantIndex]['variant_name']})";
    price =
        "₱${(widget.product.variants[selectedVariantIndex]['price'] * widget.quantity as double).toStringAsFixed(2)}";
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.product.variants[selectedVariantIndex]['image'] ??
                    "http://via.placeholder.com/350x150",
              ),
              fit: BoxFit.cover),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF303030),
          fontSize: 14,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      ),
      subtitle: Text(
        "Quantity: ${widget.quantity}",
        style: const TextStyle(
          color: Color(0xFF808080),
          fontSize: 14,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Text(
        price,
        style: const TextStyle(
          color: Color(0xFF303030),
          fontSize: 18,
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
