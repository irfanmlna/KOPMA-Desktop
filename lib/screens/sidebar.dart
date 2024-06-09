import 'package:flutter/material.dart';
import 'package:kopma_app/screens/kategori.dart';
import 'package:kopma_app/screens/barang.dart';
import 'package:kopma_app/screens/login_screen.dart';
import 'package:kopma_app/screens/supplier.dart';
import 'package:kopma_app/screens/transaksi.dart';
import 'package:kopma_app/styles/app_icons.dart';

class SideBar extends StatelessWidget {
  final int selectedIndex;

  SideBar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.orange,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset(
                    AppIcons.logo,
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'KOPMA',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.shopping_bag,
                color: selectedIndex == 0 ? Colors.black : Colors.white70,
              ),
              title: Text(
                'Barang',
                style: TextStyle(
                  color: selectedIndex == 0 ? Colors.black : Colors.white70,
                ),
              ),
              onTap: () {
                if (selectedIndex != 0) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          BarangPage(),
                      transitionDuration: Duration.zero,
                      opaque: true,
                    ),
                  );
                }
              },
              selected: selectedIndex == 0,
              tileColor: selectedIndex == 0 ? Colors.grey[300] : null,
            ),
            ListTile(
              leading: Icon(
                Icons.category,
                color: selectedIndex == 1 ? Colors.black : Colors.white70,
              ),
              title: Text(
                'Kategori',
                style: TextStyle(
                  color: selectedIndex == 1 ? Colors.black : Colors.white70,
                ),
              ),
              onTap: () {
                if (selectedIndex != 1) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          KategoriPage(),
                      transitionDuration: Duration.zero,
                      opaque: true,
                    ),
                  );
                }
              },
              selected: selectedIndex == 1,
              tileColor: selectedIndex == 1 ? Colors.grey[300] : null,
            ),
            ListTile(
              leading: Icon(
                Icons.people_alt,
                color: selectedIndex == 2 ? Colors.black : Colors.white70,
              ),
              title: Text(
                'Supplier',
                style: TextStyle(
                  color: selectedIndex == 2 ? Colors.black : Colors.white70,
                ),
              ),
              onTap: () {
                if (selectedIndex != 2) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SupplierPage(),
                      transitionDuration: Duration.zero,
                      opaque: true,
                    ),
                  );
                }
              },
              selected: selectedIndex == 2,
              tileColor: selectedIndex == 2 ? Colors.grey[300] : null,
            ),
            ListTile(
              leading: Icon(
                Icons.money,
                color: selectedIndex == 3 ? Colors.black : Colors.white70,
              ),
              title: Text(
                'Transaksi',
                style: TextStyle(
                  color: selectedIndex == 3 ? Colors.black : Colors.white70,
                ),
              ),
              onTap: () {
                if (selectedIndex != 3) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          TransaksiPage(),
                      transitionDuration: Duration.zero,
                      opaque: true,
                    ),
                  );
                }
              },
              selected: selectedIndex == 3,
              tileColor: selectedIndex == 3 ? Colors.grey[300] : null,
            ),
            Spacer(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white70,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              onTap: () {
                // Membersihkan input dan mereset keadaan LoginScreen
                BackButton();
              },
            ),
          ],
        ),
      ),
    );
  }
}
