import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/sidebar.dart';
import 'package:kopma_app/styles/app_colors.dart';

class FormEditSupplier extends StatefulWidget {
  final int supplierId;

  const FormEditSupplier({required this.supplierId});

  @override
  _FormEditSupplierState createState() => _FormEditSupplierState();
}

class _FormEditSupplierState extends State<FormEditSupplier> {
  TextEditingController _namaSupplierController = TextEditingController();
  TextEditingController _noTelpController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  final SideBar _sideBar = SideBar(selectedIndex: 2);

  @override
  void initState() {
    super.initState();
    fetchSupplierDetails();
  }

  Future<void> fetchSupplierDetails() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/suppliers/${widget.supplierId}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _namaSupplierController.text = data['data']['nama_supplier'].toString();
        _noTelpController.text = data['data']['no_telp'].toString();
        _alamatController.text = data['data']['Alamat'].toString();
      });
    } else {
      // Error handling
      print('Failed to fetch supplier details');
    }
  }

  Future<void> updateSupplier() async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/suppliers/${widget.supplierId}'),
      body: {
        'nama_supplier': _namaSupplierController.text,
        'no_telp': _noTelpController.text,
        'Alamat': _alamatController.text,
      },
    );

    if (response.statusCode == 200) {
      // Success handling
      print('Supplier updated successfully');
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      // Error handling
      print('Failed to update supplier');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _sideBar,
          Expanded(
            flex: 3,
            child: Scaffold(
              body: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _namaSupplierController,
                      decoration: InputDecoration(labelText: 'Nama Supplier'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _alamatController,
                      decoration: InputDecoration(labelText: 'Alamat'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _noTelpController,
                      decoration: InputDecoration(labelText: 'No. Telepon'),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .grey, // Sesuaikan dengan warna yang diinginkan
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: updateSupplier,
                          child: Text('Update Supplier'),
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
