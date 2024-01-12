import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendo/database/database_service.dart';
import 'package:vendo/models/users.dart';

import '../utils/reusable_widgets.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key, required this.user});

  final Users user;

  @override
  State<StatefulWidget> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  late final TextEditingController _fullNameTextController;
  late final TextEditingController _emailTextController;
  late final TextEditingController _phoneTextController;
  late final TextEditingController _currentPassTextController;
  late final TextEditingController _newPassTextController;
  late final TextEditingController _confirmPassTextController;
  final validEmail = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$"
  );
  final validPassword = RegExp(r"^(?=.*[0-9]).{8,}$");
  final validPhoneNumber = RegExp(r"^(\+62|62|0)8[1-9][0-9]{6,9}$");
  DatabaseService service = DatabaseService();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isEmailValid = true;
  bool _isPhoneNumberValid = true;
  bool _isPasswordNotMatch = false;
  bool _isCurrentPasswordNotMatch = false;
  bool _isPasswordValid = true;

  void _handleBioChanges() {
    setState(() {
      _isEmailValid = validEmail.hasMatch(_emailTextController.text) ? true : false;
      _isPhoneNumberValid = validPhoneNumber.hasMatch(_phoneTextController.text)
          ? true : false;
    });
    if (_isEmailValid && _fullNameTextController.text.isNotEmpty && _isPhoneNumberValid) {
      service.updateUserBio(auth.currentUser!.uid,
          _fullNameTextController.text, _emailTextController.text,
          _phoneTextController.text);
    }
    if (_confirmPassTextController.text.isNotEmpty 
        || _currentPassTextController.text.isNotEmpty 
        || _newPassTextController.text.isNotEmpty) {
      if (_newPassTextController.text != _confirmPassTextController.text) {
        setState(() {
          _isPasswordNotMatch = true;
        });
        return;
      }
      if (!validPassword.hasMatch(_newPassTextController.text)) {
        setState(() {
          _isPasswordValid = false;
        });
        return;
      }
      _reauthenticateUser();
      if (_isCurrentPasswordNotMatch) {
        return;
      }
    }
    Navigator.pop(context);
  }

  void _reauthenticateUser() async {
    try {
      await auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: auth.currentUser!.email!,
              password: _currentPassTextController.text)
      );
      setState(() {
        _isCurrentPasswordNotMatch = false;
      });
      auth.currentUser!.updatePassword(_newPassTextController.text);
    } on FirebaseAuthException {
      setState(() {
        _isCurrentPasswordNotMatch = true;
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _fullNameTextController = TextEditingController(text: widget.user.fullName);
    _emailTextController = TextEditingController(text: widget.user.email);
    _phoneTextController = TextEditingController(text: widget.user.phoneNumber);
    _currentPassTextController = TextEditingController();
    _newPassTextController = TextEditingController();
    _confirmPassTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          leading: const Icon(Icons.arrow_back),
          surfaceTintColor: Colors.white,
          title: Text('Tentang Saya',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      bottomNavigationBar: GestureDetector(
        onTap: _handleBioChanges,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22),
          color: const Color(0xFF2A4399),
          child: Text('Simpan Perubahan',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 17, color: Colors.white)),
        )
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text('Detail Saya',
                      style: GoogleFonts.inter(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 10),
                  reusableTextFieldWithIcon(widget.user.fullName, false, _fullNameTextController,
                      const Icon(Icons.person_2_outlined),
                      const Color(0xFF314797), 2),
                  const SizedBox(height: 10),
                  reusableTextFieldWithIcon(
                      widget.user.email, false, _emailTextController,
                      const Icon(Icons.email_outlined),
                      const Color(0xFF314797), 2
                  ),
                  _isEmailValid
                      ? const SizedBox()
                      : Container(
                          margin: const EdgeInsets.only(top: 7),
                          child: Text(
                            'Format email salah!',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                          )
                        ),
                  const SizedBox(height: 10),
                  reusablePhoneTextField(
                      "+62 87845245874", _phoneTextController,
                      const Icon(Icons.phone_android),
                      const Color(0xFF314797), 2
                  ),
                  const SizedBox(height: 25),
                  Text('Ubah Kata Sandi',
                      style: GoogleFonts.inter(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 10),
                  reusableTextFieldWithIcon("Password saat ini", true, _currentPassTextController,
                      const Icon(Icons.lock_outline),
                      const Color(0xFF314797), 2),
                  _isCurrentPasswordNotMatch
                      ? Container(
                            margin: const EdgeInsets.only(top: 7),
                            child: Text(
                              'Password tidak sesuai',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                            )
                        )
                      : const SizedBox(),
                  const SizedBox(height: 10),
                  reusableTextFieldWithIcon(
                      "Password Baru", true, _newPassTextController,
                      const Icon(Icons.lock_outline),
                      const Color(0xFF314797), 2
                  ),
                  const SizedBox(height: 10),
                  reusableTextFieldWithIcon("Konfirmasi password", true,
                      _confirmPassTextController,
                      const Icon(Icons.lock_outline), const Color(0xFF314797), 2),
                  const SizedBox(height: 10),
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
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.red),
                            )
                        )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
