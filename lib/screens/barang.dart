import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/styles/app_colors.dart';
import 'sidebar.dart';
import 'form_input_barang.dart';
import 'form_edit_barang.dart';

class BarangPage extends StatefulWidget {
  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List<Map<String, dynamic>> barangItems = [];
  final SideBar _sideBar = SideBar(selectedIndex: 0);

  @override
  void initState() {
    super.initState();
    fetchBarangItems();
  }

  Future<void> fetchBarangItems() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/barangs'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        barangItems = List<Map<String, dynamic>>.from(data['data']);
      });
    } else {
      // Error handling
      print('Failed to fetch barang items');
    }
  }

  void navigateToFormInputBarang() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero, // Menghilangkan animasi transisi
        pageBuilder: (_, __, ___) => FormInputBarang(),
      ),
    );
  }

  void navigateToFormEditBarang(int barangId) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero, // Menghilangkan animasi transisi
        pageBuilder: (_, __, ___) => FormEditBarang(barangId: barangId),
      ),
    );
  }

  Future<void> deleteBarang(int barangId) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/barangs/$barangId'),
    );

    if (response.statusCode == 200) {
      // Success handling
      print('Supplier deleted successfully');
      fetchBarangItems(); // Refresh supplier list after deletion
    } else {
      // Error handling
      print('Failed to delete supplier');
    }
  }

  void showDeleteConfirmationDialog(int barangId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin menghapus barang ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                deleteBarang(barangId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              padding: EdgeInsets.all(64),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Daftar Barang',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: DataTable(
                                columns: [
                                  DataColumn(label: Text('No')),
                                  DataColumn(label: Text('Nama Barang')),
                                  DataColumn(label: Text('Harga')),
                                  DataColumn(label: Text('Stok')),
                                  DataColumn(label: Text('Nama Supplier')),
                                  DataColumn(label: Text('Nama Kategori')),
                                  DataColumn(label: Text('Aksi')),
                                ],
                                rows: barangItems.asMap().entries.map((entry) {
                                  int index = entry.key + 1;
                                  Map<String, dynamic> barang = entry.value;
                                  int supplierId =
                                      barang.containsKey('id_supplier')
                                          ? barang['id_supplier']
                                          : 0;
                                  int kategoriId =
                                      barang.containsKey('id_kategori')
                                          ? barang['id_kategori']
                                          : 0;
                                  return DataRow(cells: [
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(barang['nama_barang'])),
                                    DataCell(Text(
                                        'Rp. ${barang['harga'].toString()}')),
                                    DataCell(Text(barang['stok'].toString())),
                                    DataCell(Text(
                                        barang['nama_supplier'] ?? 'kosong')),
                                    DataCell(Text(
                                        barang['nama_kategori'] ?? 'kosong')),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color:
                                                Color.fromRGBO(255, 166, 12, 1),
                                          ),
                                          onPressed: () {
                                            navigateToFormEditBarang(
                                                barang['id']);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Color.fromRGBO(255, 0, 0, 1),
                                          ),
                                          onPressed: () {
                                            showDeleteConfirmationDialog(
                                                barang['id']);
                                          },
                                        ),
                                      ],
                                    )),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToFormInputBarang,
        child: Icon(Icons.add),
      ),
    );
  }
}
