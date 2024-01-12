import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/screens/auth/password_reset_success.dart';

import '../../utils/reusable_widgets.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, required this.email});

  final String email;

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordConfirmTextController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isPasswordNotMatch = false;
  bool _isPasswordValid = true;
  final validPassword = RegExp(r"^(?=.*[0-9]).{8,}$");

  void _handlePasswordSubmit() {
    setState(() {
      if (_passwordTextController.text != _passwordConfirmTextController.text) {
        _isPasswordNotMatch = true;
        return;
      }
      else if (!validPassword.hasMatch(_passwordTextController.text)
          || !validPassword.hasMatch(_passwordConfirmTextController.text)) {
        _isPasswordValid = false;
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PasswordResetSuccess(email: widget.email,
            newPassword: _passwordTextController.text)));
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
                'Ubah Kata Sandi Baru',
                style: GoogleFonts.inter(
                    fontSize: 22, fontWeight: FontWeight.bold
                )
            ),
            Text(
                'Masukkan Password baru kamu',
                style: GoogleFonts.inter(
                    fontSize: 16, color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500
                )
            ),
            const SizedBox(height: 60),
            Text(
                'Password Baru',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w600
                )
            ),
            const SizedBox(height: 7),
            reusableTextField(
                "**** **** ****", false, _passwordTextController
            ),
            const SizedBox(height: 10),
            Text(
                'Konfirmasi Password',
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w600
                )
            ),
            const SizedBox(height: 7),
            reusableTextField(
                "**** **** ****", false, _passwordConfirmTextController
            ),
            _isPasswordNotMatch
                ? Container(
                      margin: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Mohon Cocokkan kata sandi kamu',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                      )
                  )
                : const SizedBox(),
            _isPasswordValid
                ? const SizedBox()
                : Container(
                      margin: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Password minimal 8 Karakter & mengandung angka',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(fontSize: 22, color: Colors.red),
                      )
                  ),
            const SizedBox(height: 10),
            Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 60),
                    child: ElevatedButton(
                        onPressed: _handlePasswordSubmit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF314797),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 105, vertical: 20
                            )
                        ),
                        child: Text('Submit',
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.background
                            ))
                    )
                )
            )
          ],
        ),
      ),
    );
  }

}