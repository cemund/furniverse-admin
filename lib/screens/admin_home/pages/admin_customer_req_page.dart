import 'package:flutter/material.dart';

class CustomerRequestPage extends StatelessWidget {
  const CustomerRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // controller: controller,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Customer Request',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer List',
                style: TextStyle(
                  color: Color(0xFF171625),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              Icon(
                Icons.more_horiz_outlined,
                color: Color(0xffB5B5BE),
                size: 24,
              )
            ],
          ),
          const CustomerCard(),
          const CustomerCard(),
          const CustomerCard(),
          const CustomerCard(),
          const CustomerCard(),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: const Text(
              'VIEW MORE CUSTOMERS',
              style: TextStyle(
                color: Color(0xFFF6BE2C),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: 0.80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const SizedBox(
        height: 36,
        width: 36,
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/images/juan.jpeg"),
        ),
      ),
      minLeadingWidth: 10,
      title: const Text(
        'Juan Dela Cruz',
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
        'Customer ID#02342',
        style: TextStyle(
          color: Color(0xFF92929D),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 0,
        ),
      ),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 24, maxWidth: 24),
        icon: const Icon(Icons.mail_outline),
        iconSize: 24,
        onPressed: () {},
      ),
    );
  }
}
