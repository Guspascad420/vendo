import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vendo/screens/auth/welcome_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
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
                          builder: (context) => const WelcomePage()));
                    },
                    child: Text('Skip',
                        style: GoogleFonts.inter(
                            fontSize: 16, color: const Color(0xFF4B5563)))),
                SmoothPageIndicator(
                    controller: controller,
                    count: 2,
                    effect: const SlideEffect()),
                _currentPage == 0
                    ? const Icon(Icons.arrow_forward, color: Color(0xFF2A4399))
                    : const SizedBox(width: 22)
              ],
            )
        ),
        body: PageView(
          controller: controller,
          children: [
            OnboardingContent(
                title: 'Nearby Vending Machine',
                description: 'Kamu tidak perlu bingung mencari Vendo berada.'
                    'Kamu bisa mencarinya lewat aplikasi, dimana ada'
                    'Vending Machine Vendo terdekat dengan kamu!',
                svgAsset: 'images/tracking_maps.svg',
                svgMarginTop: 80,
                svgMarginBottom: 105,
                onButtonPressed: () { }
            ),
            OnboardingContent(
                title: 'Select Local Products',
                description: 'Sekarang kamu bisa membeli lokal produk dari '
                    'UMKM Indonesia dengan mudah menjadi satu '
                    'mesin yang terintegrasikan dengan aplikasi!',
                svgAsset: 'images/order_illustration.svg',
                svgMarginTop: 30,
                svgMarginBottom: 20,
                showButton: true,
                onButtonPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WelcomePage()));
                })
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
      required this.svgMarginBottom,
      this.showButton = false,
      this.onButtonPressed});

  final String svgAsset;
  final String title;
  final String description;
  final double svgMarginTop;
  final double svgMarginBottom;
  final bool showButton;
  final void Function()? onButtonPressed;

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
        Text(title,
            style:
                GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 24)),
        const SizedBox(height: 10),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 12, color: const Color(0xFF4B5563)))),
        const SizedBox(height: 30),
        showButton
            ? ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF314797),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12)),
                child: Text('Mulai',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.background)))
            : const SizedBox()
      ],
    ));
  }
}
