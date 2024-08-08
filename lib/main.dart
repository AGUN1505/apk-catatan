// Import paket-paket yang diperlukan
import 'package:flutter/material.dart';
import 'package:CatatanKu/catatan/page_catatan.dart';
import 'package:CatatanKu/pemasukan/page_pemasukan.dart';
import 'package:CatatanKu/pengeluaran/page_pengeluaran.dart';
import 'package:CatatanKu/selisih/page_selisih.dart';
import 'package:CatatanKu/todo/todo_drawer.dart';

// Fungsi utama yang menjalankan aplikasi
void main() {
  runApp(const MyApp());
}

// Widget utama aplikasi yang bersifat Stateful
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// State untuk MyApp
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  // Controller untuk mengatur tab
  TabController? tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // Inisialisasi TabController dengan 4 tab
    tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // Membersihkan TabController saat widget dihapus
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Konfigurasi tema aplikasi
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow[300]!),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.yellow[300],
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow[300],
          foregroundColor: Colors.black87,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      // Menyembunyikan banner debug
      debugShowCheckedModeBanner: false,
      // Halaman utama aplikasi
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title:
              Text('CatatanKu', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: setTabBar(),
          actions: [
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: TodoDrawer(),
        // Konten utama dengan TabBarView
        body: TabBarView(
          controller: tabController,
          children: [
            PageCatatan(),
            PagePemasukan(),
            PagePengeluaran(),
            PageSelisih(),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat TabBar
  TabBar setTabBar() {
    return TabBar(
      controller: tabController,
      labelColor: Colors.black87,
      unselectedLabelColor: Colors.black54,
      indicatorColor: Colors.black87,
      indicatorWeight: 3,
      tabs: [
        Tab(text: 'Catatan', icon: Icon(Icons.note)),
        Tab(text: 'Pemasukan', icon: Icon(Icons.arrow_downward)),
        Tab(text: 'Pengeluaran', icon: Icon(Icons.arrow_upward)),
        Tab(text: 'Selisih', icon: Icon(Icons.compare_arrows)),
      ],
    );
  }
}
