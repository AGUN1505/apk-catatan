import 'package:flutter/material.dart';
import 'package:catatanku/catatan/page_catatan.dart';
import 'package:catatanku/pemasukan/page_pemasukan.dart';
import 'package:catatanku/pengeluaran/page_pengeluaran.dart';

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
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.blue),
        cardTheme: const CardTheme(surfaceTintColor: Colors.white),
        dialogTheme: const DialogTheme(
            surfaceTintColor: Colors.white, backgroundColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('CatatanKu',
              style: const TextStyle(fontSize: 20, color: Colors.white)),
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
        unselectedLabelColor: Colors.black26,
        indicatorColor: Colors.white,
        tabs: [
          Tab(text: 'Catatan', icon: const Icon(Icons.book)),
          Tab(
            text: 'Pemasukan',
            icon: Icon(Icons.archive_outlined),
          ),
          Tab(
            text: 'Pengeluaran',
            icon: Icon(Icons.unarchive_outlined),
          ),
        ]);
  }
}
