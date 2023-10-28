import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:vendo/models/category.dart';
import 'package:vendo/database/database_service.dart';
import 'package:vendo/screens/vendo_map.dart';

import '../main/main_screen.dart';

class PaymentCompleted extends StatefulWidget {
  const PaymentCompleted({super.key, required this.productCategory,
    required this.uniqueCode});

  final Category productCategory;
  final String uniqueCode;

  @override
  State<PaymentCompleted> createState() => _PaymentCompletedState();
}

class _PaymentCompletedState extends State<PaymentCompleted> {
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  String _uniqueCode = "";
  String _productCategory = "";

  @override
  void initState() {
    setState(() {
      _productCategory = widget.productCategory == Category.foodOrBeverage
          ? "F&B" : "Fashion";
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainScreen()),
                  (route) => false
          );
          return true;
        },
        child: Scaffold(
            body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 27),
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    Image.asset('images/success_icon.png', scale: 2.5),
                    const SizedBox(height: 20),
                    Text('Sukses',
                        style: GoogleFonts.inter(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground)),
                    const SizedBox(height: 15),
                    Text('Selamat, orderan kamu berhasil!',
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text('VENDO MACHINE $_productCategory',
                        style: GoogleFonts.inter(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    Text(widget.uniqueCode,
                        style: GoogleFonts.montserrat(
                            fontSize: 61,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2A4399))),
                    const SizedBox(height: 15),
                    Text('Tukarkan kode unik ini di Vendo Machine F&B terdekat kamu ya!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            color: Colors.grey)),
                    const SizedBox(height: 50),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Container(
                            width: 280,
                            child: Text('Perhatian!! Vendo machine F&B berbeda '
                                'dengan Vendo machine Fashion',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.white))
                        )
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()
                              ), (route) => false
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A4399),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 17)
                        ),
                        child: Text('Kembali ke Home',
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.background
                            ))
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const VendoMap()
                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF2A4399),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(
                                    color: Color(0xFF2A4399)
                                )
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20
                            )
                        ),
                        child: Text('Lihat Vending Machine Terdekat',
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ))
                    )
                  ],
                )
            )
        )
    );
  }
}