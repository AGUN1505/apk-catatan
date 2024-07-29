import 'package:flutter/material.dart';
import 'package:CatatanKu/catatan/page_catatan.dart';
import 'package:CatatanKu/pemasukan/page_pemasukan.dart';
import 'package:CatatanKu/pengeluaran/page_pengeluaran.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:
              Text('CatatanKu', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: setTabBar(),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            PageCatatan(),
            PagePemasukan(),
            PagePengeluaran(),
          ],
        ),
      ),
    );
  }

  TabBar setTabBar() {
    return TabBar(
      controller: tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorColor: Colors.white,
      indicatorWeight: 3,
      tabs: [
        Tab(text: 'Catatan', icon: Icon(Icons.note)),
        Tab(text: 'Pemasukan', icon: Icon(Icons.arrow_downward)),
        Tab(text: 'Pengeluaran', icon: Icon(Icons.arrow_upward)),
      ],
    );
  }
}
