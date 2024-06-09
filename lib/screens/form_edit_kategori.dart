import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/styles/app_colors.dart';

class FormEditKategori extends StatefulWidget {
  final String kategori;

  const FormEditKategori({Key? key, required this.kategori}) : super(key: key);

  @override
  _FormEditKategoriState createState() => _FormEditKategoriState();
}

class _FormEditKategoriState extends State<FormEditKategori> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _kategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _kategoriController.text = widget.kategori;
  }

  @override
  void dispose() {
    _kategoriController.dispose();
    super.dispose();
  }

  void updateKategori() async {
    if (_formKey.currentState!.validate()) {
      final url =
          Uri.parse('http://127.0.0.1:8000/api/kategoris/${widget.kategori}');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'nama_kategori': _kategoriController.text});

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Success handling
        print('Kategori updated successfully');
        Navigator.pop(context);
      } else {
        // Error handling
        print('Failed to update kategori');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Kategori'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _kategoriController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateKategori,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.mainColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
