import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordResetSuccess extends StatefulWidget {
  const PasswordResetSuccess({super.key, required this.email,
    required this.newPassword});
  final String email;
  final String newPassword;

  @override
  State<PasswordResetSuccess> createState() => _PasswordResetSuccessState();

}

class _PasswordResetSuccessState extends State<PasswordResetSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/success_icon.png', scale: 2,),
          const SizedBox(height: 20),
          Text('Sukses',
              style: GoogleFonts.inter(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 33, vertical: 10),
            child: Text("Password kamu sudah dirubah. Sekarang saatnya "
                "kamu mulai berbelanja produk-produk UMKM pilihan kami!",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 17,
                    color: Colors.grey)),
          ),
          Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const MerchantDashboard()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A4399),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12)),
                    child: Text('Dashboard Penjual',
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.background
                        ))
                ),
              )
          )
        ],
      ),
    );
  }

}