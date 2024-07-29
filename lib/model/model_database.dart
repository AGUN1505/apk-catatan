class ModelCatatan {
  int? id;
  String? title;
  String? content;
  String? date;

  ModelCatatan({this.id, this.title, this.content, this.date});

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

  ModelCatatan.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.content = map['content'];
    this.date = map['date'];
  }
}

class ModelDatabase {
  int? id;
  String? tipe;
  String? keterangan;
  String? jml_uang;
  String? tanggal;

  ModelDatabase({
    this.id,
    this.tipe,
    this.keterangan,
    this.jml_uang,
    this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipe': tipe,
      'keterangan': keterangan,
      'jml_uang': jml_uang,
      'tanggal': tanggal,
    };
  }

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
