// class ModelCatatan {
//   int? id;
//   String? title;
//   String? content;
//   String? date;

//   ModelCatatan({this.id, this.title, this.content, this.date});

//   Map<String, dynamic> toMap() {
//     var map = Map<String, dynamic>();
//     if (id != null) {
//       map['id'] = id;
//     }
//     map['title'] = title;
//     map['content'] = content;
//     map['date'] = date;

//     return map;
//   }

//   ModelCatatan.fromMap(Map<String, dynamic> map) {
//     this.id = map['id'];
//     this.title = map['title'];
//     this.content = map['content'];
//     this.date = map['date'];
//   }
// }

class ModelDatabase {
  int? id;
  String? tipe;
  String? keterangan;
  String? jml_uang;
  String? tanggal;
  String? title;
  String? date;
  String? content;

  ModelDatabase(
      {this.id,
      this.tipe,
      this.keterangan,
      this.jml_uang,
      this.tanggal,
      this.title,
      this.content,
      this.date});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['tipe'] = tipe;
    map['keterangan'] = keterangan;
    map['jml_uang'] = jml_uang;
    map['tanggal'] = tanggal;
    map['title'] = title;
    map['content'] = content;
    map['date'] = date;

    return map;
  }

  ModelDatabase.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.tipe = map['tipe'];
    this.keterangan = map['keterangan'];
    this.jml_uang = map['jml_uang'];
    this.tanggal = map['tanggal'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = map['date'];
  }
}
