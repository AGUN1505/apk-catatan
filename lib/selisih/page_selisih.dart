import 'package:flutter/material.dart';
import 'package:CatatanKu/database/DatabaseHelper.dart';
import 'package:CatatanKu/decoration/format_rupiah.dart';

class PageSelisih extends StatefulWidget {
  const PageSelisih({Key? key}) : super(key: key);

  @override
  State<PageSelisih> createState() => _PageSelisihState();
}

class _PageSelisihState extends State<PageSelisih> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int totalPemasukan = 0;
  int totalPengeluaran = 0;
  int selisih = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    int pemasukan = await databaseHelper.getJmlPemasukan();
    int pengeluaran = await databaseHelper.getJmlPengeluaran();
    setState(() {
      totalPemasukan = pemasukan;
      totalPengeluaran = pengeluaran;
      selisih = pemasukan - pengeluaran;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard('Total Pemasukan', totalPemasukan, Colors.green),
                SizedBox(height: 16),
                _buildInfoCard(
                    'Total Pengeluaran', totalPengeluaran, Colors.red),
                SizedBox(height: 16),
                _buildInfoCard('Selisih', selisih,
                    selisih >= 0 ? Colors.blue : Colors.orange),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, int amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              CurrencyFormat.convertToIdr(amount),
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
