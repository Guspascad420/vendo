import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vando/models/category.dart';
import 'package:vando/screens/umkm/finished_product_regist.dart';
import 'package:vando/utils/reusable_widgets.dart';

class ProductRegist extends StatefulWidget {
  const ProductRegist({super.key, required this.category});

  final Category category;

  @override
  State<StatefulWidget> createState() => _ProductRegistState();
}

class _ProductRegistState extends State<ProductRegist> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _descriptionTextController = TextEditingController();
  final TextEditingController _volumeTextController = TextEditingController();

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
          title: Text('Daftarkan Produk',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground)),
          centerTitle: true
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              timelineView(1),
              const SizedBox(height: 45),
              Text("Nama Produk",
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              reusableTextField("", false, _nameTextController),
              const SizedBox(height: 30),
              Text("Deskripsi Produk",
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              reusableTextField("", false, _descriptionTextController),
              const SizedBox(height: 30),
              Text("Volume (gr.)",
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              reusableTextField("", false, _volumeTextController),
              const SizedBox(height: 30),
              Text("Dimensi Kemasan",
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              reusableTextField("", false, _volumeTextController),
              const SizedBox(height: 30),
              Text("Foto Produk",
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              photoRegist(),
              const SizedBox(height: 45),
              Text("Sertifikat BPOM",
                  style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
              photoRegist(),
              const SizedBox(height: 45),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FinishedProductRegist()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A4399),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 85, vertical: 12)),
                    child: Text('Submit',
                        style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.background
                        ))
                ),
              ),
              const SizedBox(height: 45)
            ],
          )
        )
      )
    );
  }
}

Widget photoRegist() {
  return Row(
    children: [
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)
        ),
        child: const Center(
            child: Icon(Icons.add)
        ),
      ),
      Container(
          margin: const EdgeInsets.only(left: 10),
          height: 90,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Jpg/Png. Max 5Mb",
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.grey
                  )),
              Text("Ganti Foto",
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.grey,
                      decoration: TextDecoration.underline
                  ))
            ],
          )
      )
    ],
  );
}