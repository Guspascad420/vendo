import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/database/database_service.dart';
import 'package:vendo/screens/auth/otp_screen.dart';
import '../../utils/reusable_widgets.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailTextController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final validEmail = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"
  );
  DatabaseService service = DatabaseService();
  bool _isEmailValid = true;
  bool _isEmailRegistered = true;
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });
    if (!validEmail.hasMatch(_emailTextController.text)) {
      setState(() {
        _isEmailValid = false;
        _isLoading = false;
      });
      return;
    }
    service.checkRegisteredEmail(
        _emailTextController.text
    ).then((value) {
      if (value == false) {
        setState(() {
          _isLoading = false;
          _isEmailRegistered = false;
        });
        return;
      }
      http.post(
          Uri.parse('https://midtrans-go-api.lemonpond-99927c12.southeastasia.azure'
              'containerapps.io/api/otp/generate'),
          body: jsonEncode(<String, dynamic> {
            'email': _emailTextController.text
          })
      ).then((response) {
        if (response.statusCode == 201) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OTPScreen(email: _emailTextController.text)));
        }
      });
    });
  }


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
                'Lupa Password?',
                style: GoogleFonts.inter(
                    fontSize: 22, fontWeight: FontWeight.bold
                )
            ),
            Text(
                'Masukkan email kamu yang terdaftar dibawah ini',
                style: GoogleFonts.inter(
                    fontSize: 16, color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500
                )
            ),
            const SizedBox(height: 60),
            Text(
                'Email address',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w600
                )
            ),
            const SizedBox(height: 7),
            reusableTextField(
                "Contoh : namaemail@emailkamu.com", false, _emailTextController
            ),
            _isEmailValid
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.only(top: 7),
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Format email salah!',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                    )
                  ),
            _isEmailRegistered
                ? const SizedBox()
                : Container(
                      margin: const EdgeInsets.only(top: 7),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Email belum terdaftar!',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                      )
                  ),
            Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 60),
                    child: ElevatedButton(
                        onPressed: () {
                                _sendOtp();
                              },
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
        )
      )
    );
  }
}