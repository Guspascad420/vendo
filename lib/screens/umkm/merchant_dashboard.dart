import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MerchantDashboard extends StatelessWidget {
  const MerchantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          surfaceTintColor: Colors.white,
          title: Text('Toko Saya',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {}, 
                icon: const Icon(Icons.notifications)
            )
          ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Divider()
        ],
      ),
    );
  }

}