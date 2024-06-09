import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/sidebar.dart';
import 'package:kopma_app/styles/app_colors.dart';

class FormInputBarang extends StatefulWidget {
  @override
  _FormInputBarangState createState() => _FormInputBarangState();
}

class _FormInputBarangState extends State<FormInputBarang> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final SideBar _sideBar = SideBar(selectedIndex: 0);

  List<Map<String, dynamic>> _supplierList = [];
  List<Map<String, dynamic>> _kategoriList = [];

  String? _selectedSupplierId;
  String? _selectedKategoriId;

  @override
  void initState() {
    super.initState();
    fetchSupplierList();
    fetchKategoriList();
  }

  Future<void> fetchSupplierList() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/suppliers'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _supplierList = List<Map<String, dynamic>>.from(data['data']);
      });
    } else {
      // Error handling
      print('Failed to fetch supplier list');
    }
  }

  Future<void> fetchKategoriList() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/kategoris'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _kategoriList = List<Map<String, dynamic>>.from(data['data']);
      });
    } else {
      // Error handling
      print('Failed to fetch kategori list');
    }
  }

  Future<void> _simpanBarang() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/barangs');
    final response = await http.post(
      url,
      body: {
        'nama_barang': _namaBarangController.text,
        'harga': _hargaController.text,
        'stok': _stokController.text,
        'desc': _descController.text,
        'supplier_id': _selectedSupplierId!,
        'kategori_id': _selectedKategoriId!,
      },
    );

    if (response.statusCode == 200) {
      // Sukses menyimpan barang
      print('Barang berhasil disimpan');
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } else {
      // Gagal menyimpan barang
      print('Gagal menyimpan barang');
    }
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
                    TextFormField(
                      controller: _namaBarangController,
                      decoration: InputDecoration(labelText: 'Nama Barang'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(labelText: 'Deskripsi'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _hargaController,
                      decoration: InputDecoration(labelText: 'Harga'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _stokController,
                      decoration: InputDecoration(labelText: 'Stok'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSupplierId,
                      onChanged: (value) {
                        setState(() {
                          _selectedSupplierId = value;
                        });
                      },
                      items: _supplierList.map((supplier) {
                        return DropdownMenuItem<String>(
                          value: supplier['id'].toString(),
                          child: Text(supplier['nama_supplier']),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Supplier',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedKategoriId,
                      onChanged: (value) {
                        setState(() {
                          _selectedKategoriId = value;
                        });
                      },
                      items: _kategoriList.map((kategori) {
                        return DropdownMenuItem<String>(
                          value: kategori['id'].toString(),
                          child: Text(kategori['nama_kategori']),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
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
                            _simpanBarang();
                          },
                          child: Text('Simpan'),
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
