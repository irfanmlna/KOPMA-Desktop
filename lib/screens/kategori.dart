import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/form_edit_kategori.dart';
import 'package:kopma_app/screens/form_input_kategori.dart';
import 'package:kopma_app/styles/app_colors.dart';
import 'sidebar.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class KategoriPage extends StatefulWidget {
  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  List<String> kategoriItems = [];
  final SideBar _sideBar = SideBar(selectedIndex: 1);

  @override
  void initState() {
    super.initState();
    fetchKategoriItems();
  }

  Future<void> fetchKategoriItems() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/kategoris'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final kategoris =
          List<String>.from(data['data'].map((item) => item['nama_kategori']));
      setState(() {
        kategoriItems = kategoris;
      });
    } else {
      // Error handling
      print('Failed to fetch kategori items');
    }
  }

  void navigateToFormInputKategori() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormInputKategori()),
    ).then((value) {
      // Refresh kategori items after returning from FormInputKategori
      fetchKategoriItems();
    });
  }

  void navigateToFormEditKategori(String kategori) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEditKategori(kategori: kategori),
      ),
    ).then((value) {
      // Refresh kategori items after returning from FormEditKategori
      fetchKategoriItems();
    });
  }

  Future<void> deleteKategori(String kategoriId) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/kategoris/$kategoriId'),
    );

    if (response.statusCode == 200) {
      // Success handling
      print('Kategori deleted successfully');
      fetchKategoriItems(); // Refresh kategori items after deletion
    } else {
      // Error handling
      print('Failed to delete kategori');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Row(
        children: [
          _sideBar,
          Expanded(
            child: Container(
              padding: EdgeInsets.all(128),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 32,
                crossAxisSpacing: 32,
                children: kategoriItems.map((kategori) {
                  return InkWell(
                    onTap: () {
                      // Handle kategori item tap
                      print('Kategori: $kategori');
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                kategori,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'edit') {
                                navigateToFormEditKategori(kategori);
                              } else if (value == 'delete') {
                                deleteKategori(kategori);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToFormInputKategori,
        child: Icon(Icons.add),
      ),
    );
  }
}
