import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/database/database_service.dart';

import '../../models/order.dart';
import '../../utils/currency_format.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  late Future<List<Order>> futureOrders;
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseService service = DatabaseService();

  @override
  void initState() {
    super.initState();
    futureOrders = service.retrieveOrders(auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureOrders,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2A4399)
            ));
          } else if (snapshot.hasError) {
            return Text('Mohon cek koneksi internet kamu');
          }
          List<Order> orders = snapshot.data!;
          if (orders.isEmpty) {
            return emptyOrderHistory(context);
          }
          return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 20),
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                return orderContent(orders[index]);
              });
        }
    );
  }
}

Widget emptyOrderHistory(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: MediaQuery.of(context).size.height * 0.18),
      Image.asset('images/sad.png'),
      const SizedBox(height: 20),
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Text('UUUPPPSSS!!!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280))),
      ),
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Text('Kamu belum memesan apa-apa Silahkan lakukan pemesanan dan pembayaran',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280))),
      )
    ],
  );
}

Widget orderContent(Order order) {
  return Container(
    height: 100,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    width: double.infinity,
    color: const Color(0xFFE9E9E9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Order #${order.uniqueCode}",
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600)),
            Text(order.status,
                style: GoogleFonts.inter(fontSize: 15,
                    color: const Color(0xFF868889))),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(order.category,
                style: GoogleFonts.inter(fontSize: 20,
                    fontWeight: FontWeight.w600)),
            Text(CurrencyFormat.convertToIdr(order.price),
                style: GoogleFonts.inter(fontSize: 15,
                    color: const Color(0xFF868889)))
          ],
        )
      ],
    ),
  );
}