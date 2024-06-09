import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/sidebar.dart';
import 'package:kopma_app/styles/app_colors.dart';

class FormInputKategori extends StatefulWidget {
  @override
  _FormInputKategoriState createState() => _FormInputKategoriState();
}

class _FormInputKategoriState extends State<FormInputKategori> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _namaKategoriController = TextEditingController();
  final SideBar _sideBar = SideBar(selectedIndex: 1);

  Future saveKategori() async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/kategoris"),
      body: {
        "nama_kategori": _namaKategoriController.text,
      },
    );
    print(response.body);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _sideBar,
          Expanded(
              child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _namaKategoriController,
                      decoration: InputDecoration(labelText: 'Nama Kategori'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Kategori harus diisi';
                        }
                        return null;
                      },
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
                            saveKategori().then((value) {
                              // Handle the response or navigate to another screen
                              Navigator.pop(
                                  context); // Kembali ke halaman sebelumnya
                            });
                          }
                        },
                        child: Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
