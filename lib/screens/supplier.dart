import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/form_input_supplier.dart';
import 'package:kopma_app/styles/app_colors.dart';
import 'sidebar.dart';
import 'form_edit_supplier.dart';

class SupplierPage extends StatefulWidget {
  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  List<Map<String, dynamic>> supplierItems = [];
  final SideBar _sideBar = SideBar(selectedIndex: 2);

  @override
  void initState() {
    super.initState();
    fetchSupplierItems();
  }

  Future<void> fetchSupplierItems() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/suppliers'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        supplierItems = List<Map<String, dynamic>>.from(data['data']);
      });
    } else {
      // Error handling
      print('Failed to fetch supplier items');
    }
  }

  void navigateToFormInputSupplier() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero, // Menghilangkan animasi transisi
        pageBuilder: (_, __, ___) => FormInputSupplier(),
      ),
    );
  }

  void navigateToFormEditSupplier(int supplierId) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero, // Menghilangkan animasi transisi
        pageBuilder: (_, __, ___) => FormEditSupplier(supplierId: supplierId),
      ),
    ).then((value) {
      // Refresh supplier list after returning from FormEditSupplier
      fetchSupplierItems();
    });
  }

  Future<void> deleteSupplier(int supplierId) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/suppliers/$supplierId'),
    );

    if (response.statusCode == 200) {
      // Success handling
      print('Supplier deleted successfully');
      fetchSupplierItems(); // Refresh supplier list after deletion
    } else {
      // Error handling
      print('Failed to delete supplier');
    }
  }

  void showDeleteConfirmationDialog(int supplierId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin menghapus supplier ini?'),
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
                deleteSupplier(supplierId);
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Daftar Supplier',
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
                                  DataColumn(label: Text('Nama Supplier')),
                                  DataColumn(label: Text('Alamat')),
                                  DataColumn(label: Text('No Telephone')),
                                  DataColumn(label: Text('Aksi')),
                                ],
                                rows:
                                    supplierItems.asMap().entries.map((entry) {
                                  int index = entry.key + 1;
                                  Map<String, dynamic> supplier = entry.value;
                                  return DataRow(cells: [
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(supplier['nama_supplier'])),
                                    DataCell(Text(supplier['Alamat'])),
                                    DataCell(Text(supplier['no_telp'])),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color:
                                                Color.fromRGBO(255, 166, 12, 1),
                                          ),
                                          onPressed: () {
                                            navigateToFormEditSupplier(
                                                supplier['id']);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Color.fromRGBO(255, 0, 0, 1),
                                          ),
                                          onPressed: () {
                                            showDeleteConfirmationDialog(
                                                supplier['id']);
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
        onPressed: navigateToFormInputSupplier,
        child: Icon(Icons.add),
      ),
    );
  }
}
