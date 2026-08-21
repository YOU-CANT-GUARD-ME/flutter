import 'package:flutter/material.dart';
import 'package:nike_app/components/bottom_nav_bar.dart';
import 'package:nike_app/pages/shop_page.dart';

import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //this selected index is to control the bottom nav bar
  int _selectedIndex = 0;

  //this method will update our selected index
  // when the user taps on the bottom bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to display
  final List<Widget> _pages = [
    // shop page
    const ShopPage(),

    // cart page
    const CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
          children: [
            // logo
            Container(
              padding: EdgeInsets.only(top: 100, bottom: 20),
              child: Image.asset(
                'lib/images/logo.png',
                color: Colors.white,
                width: 150,
              ),
            ),

            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
              child: Divider(
                color: Colors.grey[800],
              ),
            )

            // other pages
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
