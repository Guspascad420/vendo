import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vando/screens/main/home_screen.dart';
import 'package:vando/screens/main/order_history.dart';
import 'package:vando/screens/main/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<Widget> bodyWidgetOptions = <Widget> [
      HomeScreen(),
      OrderHistory(),
      ProfileScreen()
    ];

    List<PreferredSizeWidget> appBarWidgetOptions = <PreferredSizeWidget>[
      homeAppBar(context),
      orderHistoryAppBar(context),
      profileAppBar(context)
    ];

    return Scaffold(
      appBar: appBarWidgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)
            ),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('images/ic_home.svg',
                          color: const Color(0xFF4B5563)),
                      activeIcon: SvgPicture.asset('images/ic_home.svg'),
                      label: ''
                  ),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('images/ic_orders.svg'),
                      activeIcon: SvgPicture.asset('images/ic_orders.svg',
                          color: const Color(0xFF4B5563)),
                      label: ''
                  ),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('images/ic_profile.svg'),
                      activeIcon: SvgPicture.asset('images/ic_profile.svg',
                          color: const Color(0xFF4B5563)),
                      label: ''
                  )
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
            ),
          )
      ),
      body: bodyWidgetOptions.elementAt(_selectedIndex)
    );
  }
}

PreferredSizeWidget homeAppBar(BuildContext context) {
  return AppBar(
    surfaceTintColor: Colors.white,
    leading: const SizedBox(),
    backgroundColor: Theme.of(context).colorScheme.background,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: Color(0xFF314797)),
        const SizedBox(width: 4),
        Text('Universitas Brawijaya',
            style: GoogleFonts.inter(
                fontSize: 16, color: const Color(0xFF4B5563)))
      ],
    ),
    actions: [Image.asset('images/shopping_cart.png', scale: 2)
    ],
  );
}

PreferredSizeWidget orderHistoryAppBar(BuildContext context) {
  return AppBar(
    surfaceTintColor: Colors.white,
    title: Text('Riwayat Pemesanan',
        style: GoogleFonts.inter(
            fontSize: 20, color: Theme.of(context).colorScheme.onBackground)),
    centerTitle: true
  );
}

PreferredSizeWidget profileAppBar(BuildContext context) {
  return AppBar(
      surfaceTintColor: Colors.white,
      title: Text('Profil',
          style: GoogleFonts.inter(
              fontSize: 20, color: Theme.of(context).colorScheme.onBackground)),
      centerTitle: true
  );
}