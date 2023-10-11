import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F5F9),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          userBiodata(context),

        ],
      ),
    );
  }
}

Widget userBiodata(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle
        ),
      ),
      const SizedBox(height: 10),
      Text('Kylian Mbappe',
          style: GoogleFonts.inter(fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground)),
      Text('kylianmbappe@gmail.com',
          style: GoogleFonts.inter(fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF868889))),
      profileMenuContent(context, SvgPicture.asset('images/about_me.svg'), 'About me'),
      profileMenuContent(context,
          const Icon(Icons.location_on, color: Color(0xFF2A4399)), 'Locations'),
      profileMenuContent(context,
          const Icon(Icons.payment, color: Color(0xFF2A4399)), 'Payment'),
      profileMenuContent(context,
          const Icon(Icons.notifications_none_outlined, color: Color(0xFF2A4399)),
          'Notifications'),
      profileMenuContent(context,
          SvgPicture.asset('images/sign_out.svg'), 'Sign out'),
    ],
  );
}

Widget profileMenuContent(BuildContext context, Widget icon, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Text(title,
              style: GoogleFonts.inter(fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground))
        ],
      ),
      title != 'Sign out' ? const Icon(Icons.arrow_forward_ios_sharp) : const SizedBox()
    ],
  );
}