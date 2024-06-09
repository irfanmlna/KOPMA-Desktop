import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/sidebar.dart';
import 'package:kopma_app/styles/app_colors.dart';

class FormEditBarang extends StatefulWidget {
  final int barangId;

  const FormEditBarang({required this.barangId});

  @override
  _FormEditBarangState createState() => _FormEditBarangState();
}

class _FormEditBarangState extends State<FormEditBarang> {
  TextEditingController _namaBarangController = TextEditingController();
  TextEditingController _hargaController = TextEditingController();
  TextEditingController _stokController = TextEditingController();
  int _selectedSupplierId = 0;
  int _selectedKategoriId = 0;
  List<Map<String, dynamic>> kategoriList = [];
  List<Map<String, dynamic>> supplierList = [];
  final SideBar _sideBar = SideBar(selectedIndex: 0);

  @override
  void initState() {
    super.initState();
    fetchBarangDetails();
  }

  Future<void> fetchBarangDetails() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/barangs/${widget.barangId}'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final barangDetails = data['data'];

      setState(() {
        _namaBarangController.text = barangDetails['nama_barang'];
        _hargaController.text = barangDetails['harga'].toString();
        _stokController.text = barangDetails['stok'].toString();
        _selectedSupplierId = barangDetails['supplier_id'];
        _selectedKategoriId = barangDetails['kategori_id'];
      });

      await fetchKategoriList();
      await fetchSupplierList();
    } else {
      // Error handling
      print('Failed to fetch barang details');
    }
  }

  Future<void> fetchKategoriList() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/kategoris'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        kategoriList = List<Map<String, dynamic>>.from(data['data']);
      });
    } else {
      // Error handling
      print('Failed to fetch kategori list');
    }
  }

  Future<void> fetchSupplierList() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/suppliers'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        supplierList = List<Map<String, dynamic>>.from(data['data']);
      });
    } else {
      // Error handling
      print('Failed to fetch supplier list');
    }
  }

  Future<void> updateBarang() async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/barangs/${widget.barangId}'),
      body: {
        'nama_barang': _namaBarangController.text,
        'harga': _hargaController.text,
        'stok': _stokController.text,
        'supplier_id': _selectedSupplierId.toString(),
        'kategori_id': _selectedKategoriId.toString(),
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final message = data['message'];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Error handling
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update barang'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
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
                    TextField(
                      controller: _namaBarangController,
                      decoration: InputDecoration(labelText: 'Nama Barang'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _hargaController,
                      decoration: InputDecoration(labelText: 'Harga'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _stokController,
                      decoration: InputDecoration(labelText: 'Stok'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    Text('Supplier'),
                    DropdownButtonFormField<int>(
                      value: _selectedSupplierId,
                      onChanged: (value) {
                        setState(() {
                          _selectedSupplierId = value!;
                        });
                      },
                      items: supplierList.map((supplier) {
                        return DropdownMenuItem<int>(
                          value: supplier['id'],
                          child: Text(supplier['nama_supplier']),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Supplier',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Kategori'),
                    DropdownButtonFormField<int>(
                      value: _selectedKategoriId,
                      onChanged: (value) {
                        setState(() {
                          _selectedKategoriId = value!;
                        });
                      },
                      items: kategoriList.map((kategori) {
                        return DropdownMenuItem<int>(
                          value: kategori['id'],
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
                            updateBarang();
                          },
                          child: Text('Update'),
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
