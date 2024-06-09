import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopma_app/screens/form_input_transaksi.dart';
import 'package:kopma_app/styles/app_colors.dart';
import 'sidebar.dart';

class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  List<Map<String, dynamic>> transaksiItems = [];
  final SideBar _sideBar = SideBar(selectedIndex: 3);

  @override
  void initState() {
    super.initState();
    fetchTransaksiItems();
  }

  Future<void> fetchTransaksiItems() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/transaksis'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        transaksiItems = List<Map<String, dynamic>>.from(data['data']);
      });
    } else {
      // Error handling
      print('Failed to fetch supplier items');
    }
  }

  void navigateToFormInputTransaksi() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero, // Menghilangkan animasi transisi
        pageBuilder: (_, __, ___) => FormInputTransaksi(),
      ),
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
                            'Daftar Transaksi',
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
                                  DataColumn(label: Text('Jumlah Terjual')),
                                ],
                                rows:
                                    transaksiItems.asMap().entries.map((entry) {
                                  int index = entry.key + 1;
                                  Map<String, dynamic> transaksi = entry.value;
                                  return DataRow(cells: [
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(transaksi[''])),
                                    DataCell(Text(transaksi['banyakbarang'])),
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
        onPressed: navigateToFormInputTransaksi,
        child: Icon(Icons.add),
      ),
    );
  }
}
