import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vando/screens/auth/welcome_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
        bottomNavigationBar: Container(
            padding: const EdgeInsets.only(bottom: 17, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WelcomePage()));
                    },
                    child: Text('Skip',
                        style: GoogleFonts.inter(
                            fontSize: 16, color: const Color(0xFF4B5563)))
                ),
                SmoothPageIndicator(
                    controller: controller,
                    count: 2,
                    effect: const SlideEffect()),
                const Icon(Icons.arrow_forward, color: Color(0xFF2A4399))
              ],
            )),
        body: PageView(
          controller: controller,
          children: const [
            OnboardingContent(
              title: 'Nearby Vending Machine',
              description: 'Kamu tidak perlu bingung mencari Vendo berada.'
                  'Kamu bisa mencarinya lewat aplikasi, dimana ada'
                  'Vending Machine Vendo terdekat dengan kamu!',
              svgAsset: 'images/tracking_maps.svg',
              svgMarginTop: 80,
              svgMarginBottom: 105,
            ),
            OnboardingContent(
              title: 'Select Local Products',
              description: 'Sekarang kamu bisa membeli lokal produk dari '
                  'UMKM Indonesia dengan mudah menjadi satu '
                  'mesin yang terintegrasikan dengan aplikasi!',
              svgAsset: 'images/order_illustration.svg',
              svgMarginTop: 30,
              svgMarginBottom: 20,
            )
          ],
        ));
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent(
      {super.key,
      required this.title,
      required this.description,
      required this.svgAsset,
      required this.svgMarginTop,
      required this.svgMarginBottom});

  final String svgAsset;
  final String title;
  final String description;
  final double svgMarginTop;
  final double svgMarginBottom;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: Image.asset('images/logo_vendo_1.png', scale: 3),
        ),
          Container(
            margin: EdgeInsets.only(top: svgMarginTop, bottom: svgMarginBottom),
            child: SvgPicture.asset(svgAsset),
        ),
          Text(
              title,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 24)
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 12, color: const Color(0xFF4B5563))
            )
          )
      ],
    ));
  }
}
