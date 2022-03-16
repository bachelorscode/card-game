import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text('frenzycoder7'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile', style: GoogleFonts.firaSans()),
          ),
          ListTile(
            leading: Icon(Icons.wallet_giftcard),
            title: Text('Wallet', style: GoogleFonts.firaSans()),
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share', style: GoogleFonts.firaSans()),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text('Developers', style: GoogleFonts.firaSans()),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout', style: GoogleFonts.firaSans()),
          )
        ],
      ),
    );
  }
}
