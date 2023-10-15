import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vando/screens/about_me.dart';
import 'package:vando/screens/umkm_onboarding.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        userBiodata(context),
      ],
    );
  }
}

Widget userBiodata(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 10),
      Container(
        width: 100,
        height: 100,
        decoration:
            const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
      ),
      const SizedBox(height: 10),
      Text('Kylian Mbappe',
          style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground)),
      Text('kylianmbappe@gmail.com',
          style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF868889))),
      const SizedBox(height: 35),
      profileMenuContent(
          context, SvgPicture.asset('images/about_me.svg'),
          'Tentang Saya',
          () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutMe())
            );
          }
      ),
      const SizedBox(height: 25),
      profileMenuContent(
          context,
          const Icon(Icons.location_on, color: Color(0xFF2A4399)),
          'Lokasi',
          () {}),
      const SizedBox(height: 25),
      profileMenuContent(
          context,
          const Icon(Icons.payment, color: Color(0xFF2A4399)),
          'Pembayaran',
          () {}
      ),
      const SizedBox(height: 25),
      profileMenuContent(
          context,
          const Icon(Icons.notifications_none_outlined,
              color: Color(0xFF2A4399)),
          'Notifikasi',
          () {}
      ),
      const SizedBox(height: 25),
      Container(
        color: const Color(0xFFDFE2E9),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: profileMenuContent(
            context,
            const Icon(Icons.storefront, color: Color(0xFF2A4399)),
            'Mulai Jual Produkmu',
                () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UMKMOnboarding())
              );
            })
      ),
      const SizedBox(height: 25),
      profileMenuContent(
          context, SvgPicture.asset('images/sign_out.svg'), 'Sign out', () {}),
    ],
  );
}

Widget profileMenuContent(BuildContext context, Widget icon, String title,
    void Function() onMenuTapped) {
  return
    GestureDetector(
      onTap: onMenuTapped,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground))
              ],
            ),
            title != 'Sign out'
                ? const Icon(Icons.arrow_forward_ios_sharp,
                color: Color(0xFF868889))
                : const SizedBox(),
          ],
        ),
      )
    );
}
