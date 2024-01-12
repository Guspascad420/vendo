import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vendo/screens/auth/new_password.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.email});

  final String email;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 150),
            Text(
                'Kode OTP',
                style: GoogleFonts.inter(
                    fontSize: 22, fontWeight: FontWeight.bold
                )
            ),
            Text(
                'Masukkan kode OTP yang sudah dikirimkan ke email kamu',
                style: GoogleFonts.inter(
                    fontSize: 16, color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500
                )
            ),
            const SizedBox(height: 60),
            OtpTextField(
              numberOfFields: 6,
              showFieldAsBox: true,
              textStyle: GoogleFonts.inter(
                  fontSize: 17, fontWeight: FontWeight.w600
              ),
              onSubmit: (String verificationCode) {
                setState(() {
                  _isLoading = true;
                });
                http.post(
                    Uri.parse('https://midtrans-go-api.lemonpond-99927c12.southeastasia.azure'
                        'containerapps.io/api/otp/validate'),
                    body: jsonEncode(<String, dynamic> {
                      'otp': verificationCode
                    })
                ).then((response) {
                  setState(() {
                    _isLoading = false;
                  });
                  if (response.statusCode == 200) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewPassword(email: widget.email)));
                  }
                });
              }, // end onSubmit
            ),
            Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 60),
                    child: ElevatedButton(
                        onPressed: () { },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF314797),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 105, vertical: 20
                            )
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text('Submit',
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.background)
                              )
                    )
                )
            )
          ],
        ),
      ),
    );
  }

}