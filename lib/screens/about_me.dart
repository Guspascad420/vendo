import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/reusable_widgets.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<StatefulWidget> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  final TextEditingController _fullNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _currentPassTextController =
      TextEditingController();
  final TextEditingController _newPassTextController = TextEditingController();
  final TextEditingController _confirmPassTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
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
            reusableTextField("Kylian Mbappe", false, _fullNameTextController),
            const SizedBox(height: 10),
            reusableTextField(
                "kylianmbappe@gmail.com", false, _emailTextController),
            const SizedBox(height: 10),
            reusableTextField(
                "kylianmbappe@gmail.com", false, _phoneTextController),
            const SizedBox(height: 25),
            Text('Ubah Kata Sandi',
                style: GoogleFonts.inter(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground)),
            const SizedBox(height: 10),
            reusableTextField(
                "kylianmbappe@gmail.com", false, _currentPassTextController),
            const SizedBox(height: 10),
            reusableTextField(
                "kylianmbappe@gmail.com", false, _newPassTextController),
            const SizedBox(height: 10),
            reusableTextField(
                "kylianmbappe@gmail.com", false, _confirmPassTextController),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
