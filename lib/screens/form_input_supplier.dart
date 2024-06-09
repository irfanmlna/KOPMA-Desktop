import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/sidebar.dart';

class FormInputSupplier extends StatefulWidget {
  @override
  _FormInputSupplierState createState() => _FormInputSupplierState();
}

class _FormInputSupplierState extends State<FormInputSupplier> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _namaSupplierController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _noTlpController = TextEditingController();
  bool _isLoading = false;
  final SideBar _sideBar = SideBar(selectedIndex: 2);

  Future saveSupplier() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/suppliers"),
      body: {
        "nama_supplier": _namaSupplierController.text,
        "no_telp": _noTlpController.text,
        "Alamat": _alamatController.text,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to save supplier');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _sideBar,
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _namaSupplierController,
                          decoration:
                              InputDecoration(labelText: 'Nama Supplier'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama Supplier harus diisi';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _alamatController,
                          decoration: InputDecoration(labelText: 'Alamat'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Alamat harus diisi';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _noTlpController,
                          decoration: InputDecoration(labelText: 'No. Telepon'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'No. Telepon harus diisi';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
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
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            saveSupplier().then((value) {
                              showSnackBar('Supplier saved successfully');
                              Navigator.pop(
                                  context); // Kembali ke halaman sebelumnya
                            }).catchError((error) {
                              showSnackBar('Failed to save supplier');
                            });
                          }
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
