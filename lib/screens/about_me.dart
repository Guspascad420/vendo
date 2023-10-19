import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vando/models/users.dart';

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

  @override
  void initState() {
    super.initState();
    _fullNameTextController = TextEditingController(text: widget.user.fullName);
    _emailTextController = TextEditingController(text: widget.user.email);
    _phoneTextController = TextEditingController();
    _currentPassTextController = TextEditingController();
    _newPassTextController = TextEditingController();
    _confirmPassTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          surfaceTintColor: Colors.white,
          title: Text('Tentang Saya',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        color: const Color(0xFF2A4399),
        child: Text('Simpan Perubahan',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 17, color: Colors.white)),
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
                  reusableTextField(widget.user.fullName, false, _fullNameTextController,
                      const Color(0xFF314797), 2),
                  const SizedBox(height: 10),
                  reusableTextField(
                      widget.user.email, false, _emailTextController,
                      const Color(0xFF314797), 2
                  ),
                  const SizedBox(height: 10),
                  reusableTextField(
                      "+62 87845245874", false, _phoneTextController,
                      const Color(0xFF314797), 2
                  ),
                  const SizedBox(height: 25),
                  Text('Ubah Kata Sandi',
                      style: GoogleFonts.inter(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 10),
                  reusableTextField("Password saat ini", false, _currentPassTextController,
                      const Color(0xFF314797), 2),
                  const SizedBox(height: 10),
                  reusableTextField(
                      "", false, _newPassTextController,
                      const Color(0xFF314797), 2
                  ),
                  const SizedBox(height: 10),
                  reusableTextField("Konfirmasi password", false,
                      _confirmPassTextController, const Color(0xFF314797), 2),
                  const SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
