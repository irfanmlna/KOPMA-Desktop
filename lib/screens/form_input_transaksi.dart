import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/sidebar.dart';

class FormInputTransaksi extends StatefulWidget {
  @override
  _FormInputTransaksiState createState() => _FormInputTransaksiState();
}

class _FormInputTransaksiState extends State<FormInputTransaksi> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _kodeBarangController = TextEditingController();
  TextEditingController _namaBarangController = TextEditingController();
  TextEditingController _banyakController = TextEditingController();
  TextEditingController _noTlpController = TextEditingController();
  bool _isLoading = false;
  final SideBar _sideBar = SideBar(selectedIndex: 3);

  Future saveSupplier() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/transaksis"),
      body: {
        "barang_id": _kodeBarangController,
        "no_telp": _noTlpController.text,
        "Alamat": _namaBarangController,
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
                          controller: _kodeBarangController,
                          decoration: InputDecoration(labelText: 'Kode Barang'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Kode barang harus diisi';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _namaBarangController,
                          decoration: InputDecoration(labelText: 'Nama Barang'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama barang harus diisi';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _noTlpController,
                          decoration: InputDecoration(labelText: 'Jumlah'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Jumlah harus diisi';
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
