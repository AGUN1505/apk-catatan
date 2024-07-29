// Kelas ModelCatatan digunakan untuk merepresentasikan data catatan
class ModelCatatan {
  int? id; // ID unik catatan
  String? title; // Judul catatan
  String? content; // Isi catatan
  String? date; // Tanggal catatan

  // Konstruktor untuk membuat objek ModelCatatan
  ModelCatatan({this.id, this.title, this.content, this.date});

  // Metode untuk mengubah objek ModelCatatan menjadi Map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['content'] = content;
    map['date'] = date;

    return map;
  }

  // Konstruktor named untuk membuat objek ModelCatatan dari Map
  ModelCatatan.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = map['date'];
  }
}

// Kelas ModelDatabase digunakan untuk merepresentasikan data transaksi keuangan
class ModelDatabase {
  int? id; // ID unik transaksi
  String? tipe; // Tipe transaksi (pemasukan/pengeluaran)
  String? keterangan; // Keterangan transaksi
  String? jml_uang; // Jumlah uang dalam transaksi
  String? tanggal; // Tanggal transaksi

  // Konstruktor untuk membuat objek ModelDatabase
  ModelDatabase({
    this.id,
    this.tipe,
    this.keterangan,
    this.jml_uang,
    this.tanggal,
  });

  // Metode untuk mengubah objek ModelDatabase menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipe': tipe,
      'keterangan': keterangan,
      'jml_uang': jml_uang,
      'tanggal': tanggal,
    };
  }

  // Konstruktor factory untuk membuat objek ModelDatabase dari Map
  factory ModelDatabase.fromMap(Map<String, dynamic> map) {
    return ModelDatabase(
      id: map['id'],
      tipe: map['tipe'],
      keterangan: map['keterangan'],
      jml_uang: map['jml_uang'],
      tanggal: map['tanggal'],
    );
  }
}
