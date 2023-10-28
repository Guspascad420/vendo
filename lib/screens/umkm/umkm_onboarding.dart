import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vendo/screens/umkm/merchant_info.dart';
import '../onboarding_page.dart';

class UMKMOnboarding extends StatefulWidget {
  const UMKMOnboarding({super.key});

  @override
  State<UMKMOnboarding> createState() => _UMKMOnboardingState();

}

class _UMKMOnboardingState extends State<UMKMOnboarding> {
  int _currentPage = 0;
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        _currentPage = controller.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 17, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MerchantInfo()));
                  },
                  child: Text('Skip',
                      style: GoogleFonts.inter(
                          fontSize: 16, color: const Color(0xFF4B5563)))
              ),
              SmoothPageIndicator(
                  controller: controller,
                  count: 2,
                  effect: const SlideEffect()),
              _currentPage == 0 ?
              const Icon(Icons.arrow_forward, color: Color(0xFF2A4399))
                  : const SizedBox(width: 22)
            ],
          )
      ),
      body: PageView(
        controller: controller,
        children: [
          const OnboardingContent(
            title: 'UMKM Support!',
            description: 'Hallo para pengusaha lokal!!!  UMKM adalah salah satu '
                'penyokong terbesar GDP suatu negara. Dengan itu kami '
                'mendukung penuh para UMKM untuk bekerjasama dengan '
                'kami sesuai arahan Kementerian Perdagangan Indonesia.',
            svgAsset: 'images/tracking_maps_2.svg',
            svgMarginTop: 80,
            svgMarginBottom: 105
          ),
          OnboardingContent(
            title: 'Pasarkan Produkmu Sekarang',
            description: 'Untuk mulai berjualan, daftar sebagai penjual dengan '
                'melengkapi informasi yang diperlukan dan mengikuti proses pendaftaran.',
            svgAsset: 'images/tracking_maps_2.svg',
            svgMarginTop: 80,
            svgMarginBottom: 105,
            showButton: true,
            onButtonPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MerchantInfo()
                  )
              );
            }
          )
        ],
      ),
    );
  }
}